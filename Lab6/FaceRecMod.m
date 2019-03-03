
%=========================== Lab 8: Part II: recognition faces ===============%
%===========================  =================%
% created by S. Yanushkevich, March 24, 2010, modified November 1, 2013
% The original eigenface-based recognition algorithm is credited
%to Santiago Serrano (Drexel University)

clear all
close all
clc

disp('-------------------------------------------------------------------');
disp(' Lab 6, ENCM509');
disp('Biometric Technologies Laboratory, UofC');
disp('Face recognition using eigenfaces and Euclidean distance ');
disp('-------------------------------------------------------------------');

%%%%%%%%%%%%%%% STEP 1 - LOAD ALL THE IMAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of images in your training set.
M=9;  %M could be large (for example, 16: 8 of yours and 8 of a friend)

% number of classes to train
C=3;
% in an effort to make the scores make more sense, have B and C be in the db.
% The third class in this array is the "imposter".
classes = ['B' 'C' 'A'];

% Create datatype for holding image
Image_Sets=cell(1,C); % img matrix
for i=1:C
    Image_Sets{i} = {};
end

%%% You can specify your directory here, please, change the string below:
current_file_path = pwd;
path = fullfile(current_file_path, 'RealFaces', '\');
for i=1:M
    for j=1:C
        str=strcat(path,classes(j),int2str(i),'.jpg'); % concatenates strings that form the name of the image
        img=imread(str);
        Image_Sets{j}{i} = img;
    end
end
%%%%%%%%%%%%%%% STEP 2 - FIND THRESHOLD #1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Classes A and B are in the DB, and we want to 9-fold train each of those sets:
step2 = true;
if(step2)
    min_distances = [];
    max_distances = [];

    for j=1:2
        for i=1:M
            % Select the set of images for training and testing:
            db = Image_Sets{j};
            idx = i;
            test_img = {db{idx}};
            db(idx) = []; % This deletes the image we're testing with from the db.
            [distances] = FacialRecognition(db, test_img);
            max_distance = max(distances{1}); % maximum eucledian distance
            min_distance = min(distances{1}); % minimum eucledian distance
            min_distances = [min_distances, min_distance];
            max_distances = [max_distances, max_distance];
        end
    end
    % Transpose for easy reading
    min_distances = min_distances';
    max_distances = max_distances';

    mean_min = mean(min_distances);
    std_min = std(min_distances);
    
    % Find the mean and std of the max distances:
    mean_max = mean(max_distances);
    std_max = std(max_distances);
    threshold1 = mean_min + norminv(0.975) * std_min / sqrt(2*M); % If you *add* std_max, it ends up being way too high...
else
    threshold1 = 4.330041409267599e+04; % Same value as above
end
%%%%%%%%%%%%%%% STEP 3 - FIND THRESHOLD #2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

step3 = true;
if(step3)
    % Classes A and B are BOTH in the db at the same time.
    db = [Image_Sets{1} Image_Sets{2}];
    test_imgs = Image_Sets{3};
    [imposter_distances] = FacialRecognition(db, test_imgs);
    imposter_max_distances = [];
    imposter_min_distances = [];

    for i=1:size(imposter_distances, 2)
        imposter_max_distances = [imposter_max_distances; max(imposter_distances{i})]; % maximum eucledian distance
        imposter_min_distances = [imposter_min_distances; min(imposter_distances{i})]; % minimum eucledian distance
    end

    % Find the mean and std of the min distances:
    mean_min = mean(imposter_min_distances);
    std_min = std(imposter_min_distances);
    
    % Find the mean and std of the max distances:
    mean_max = mean(imposter_max_distances);
    std_max = std(imposter_max_distances);
    threshold2 = mean_min + norminv(0.975) * std_min / sqrt(size(imposter_distances, 2));
else
    threshold2 = 4.345588067296708e+04;
end

%%%%%%%%%%%%%%% STEP 4 - EVALUATE PERFORMANCE OF THRESHOLDS %%%%%%%%%%%%%%%%%

% Perform testing with the two classes that belong to the database.
in_db_distances = {};
for j=1:2
    for i=1:M
        % Select the set of images for training and testing:
        db = [Image_Sets{1} Image_Sets{2}];
        test_idx = M*(j-1) + i;
        test_img = {db{test_idx}};
        db(test_idx) = []; % This deletes the image we're testing with from the db.
        [distances] = FacialRecognition(db, test_img);
        in_db_distances{M*(j-1) + i} = distances{1};
    end
end

disp('For faces in the database:');
rank1_distances = []
for i=1:size(in_db_distances, 2)
    [rank1_distance, rank1_index] = min(in_db_distances{i});
    rank1_distances = [rank1_distances, rank1_distance];
    
    class = classes(floor((rank1_index - 1) / 9) + 1);
    
    if (rank1_distance <= threshold1)
    disp(strcat('Image is in the database, it belongs to class ', " " ,class));
    elseif (rank1_distance > threshold1 && rank1_distance <= threshold2)
    disp('Image is a face but not in the database');
    elseif (rank1_distance > threshold2)
    disp('Image is not a face');
    end
end

disp('For faces NOT in the database:');
% note that we can still use imposter_distances here.
for i=1:size(imposter_min_distances, 1)
    rank1_distance = imposter_min_distances(i);
    if (rank1_distance <= threshold1)
    disp('Image is in the database');
    elseif (rank1_distance > threshold1 && rank1_distance <= threshold2)
    disp('Image is a face but not in the database');
    elseif (rank1_distance > threshold2)
    disp('Image is not a face');
    end
end

%RANK-3 Approach, we already have all the scores we need: in_db_distances and imposter_distances
%for this.
ranks = 3;
disp('For faces in the database, using a rank-3 approach:');
for i=1:size(in_db_distances, 2)
    distances = in_db_distances{i};
    
    winner = RankNMatch(distances, ranks, threshold1, threshold2);
    
    if (winner == 1)
        disp('Image is in the database');
    elseif (winner == 2)
        disp('Image is a face but not in the database');
    elseif (winner == 3)
        disp('Image is not a face');
    end
end

disp('For faces not in the database, using a rank-3 approach:');
for i=1:size(imposter_distances, 2)
    distances = imposter_distances{i};
    
    winner = RankNMatch(distances, ranks, threshold1, threshold2);
    
    if (winner == 1)
        disp('Image is in the database');
    elseif (winner == 2)
        disp('Image is a face but not in the database');
    elseif (winner == 3)
        disp('Image is not a face');
    end
end

function [winner] = RankNMatch(distances, N, threshold1, threshold2)
    distances = sort(distances);
    
    votes = zeros(3, 1);
    
    for j = 1:N
        if j > size(distances)
            break;
        end
        
        distance = distances(j);
        
        if (distance <= threshold1)
            votes(1) = votes(1) + 1;
        elseif (distance <= threshold2)
            votes(2) = votes(2) + 1;
        else
            votes(3) = votes(3) + 1;
        end
    end
    
    %now to analyze the votes
    %find all the possible winners
    top_votes = max(votes);
    top_indexes = [];
    for j = 1: 3
        if top_votes == votes(j)
            top_indexes = [top_indexes, j];
        end
    end
    
    %now find the mean index of categories that scores the maximum votes
    mean_index = mean(top_indexes);
    
    %now find the index that is closest to the mean that also scored the
    %max score
    winner = 0;
    winner_dist = 1e100;
    for j = 1: 3
        if top_votes == votes(j) && abs(j - mean_index) < winner_dist
            winner = j;
            winner_dist = abs(j - mean_index);
        end
    end
end

%%% Since the test database has to compute it's mean image and eigenvector every time,
%%% We'll just run the whole program over when we want to change the db we're wanting to use.
%%% image_db and test_images are cell arrays of rgb images.
function [distances] = FacialRecognition(image_db, test_images, thres1, thres2)

    distances = {};

    image_means = [];
    image_stds = [];

    plot_stuff = false;

    M = size(image_db,2);
    S = [];
    for i=1:M
        img = image_db{i};
        img = rgb2gray(img); %%% this version works with gray, not rgb images
        if(plot_stuff)
            figure(1);
            subplot(ceil(sqrt(M)),ceil(sqrt(M)),i)
            imshow(img)
            drawnow;
            if i==3
                title('Training data','fontsize',18)
            end
        end
        image_means = [image_means mean2(img)];
        image_stds = [image_stds std2(img)];
        [irow, icol]=size(img); % get the number of rows (N1) and columns (N2)
        temp=reshape(img',irow*icol,1); % creates a (N1*N2)x1 vector
        S=[S temp]; % The image set is a N1*N2xM matrix after finishing the sequence
    end

    % Standard deviation and mean:
    % can be any number that  is close to the std and mean of most of the images.
    um=mean(image_means);
    ustd=mean(image_stds);

    % Here we change the mean and std of all images. We normalize all images.
    % This is done to reduce the error due to lighting conditions and background.
    for i=1:size(S,2)
        temp=double(S(:,i));
        m=mean(temp);
        st=std(temp);
        S(:,i)=(temp-m)*ustd/st+um;
    end

    % show normalized images
    % figure(2);
    % for i=1:M
    %     str=strcat(path,'normalized',classes(j),int2str(i),'.jpg');
    %     img=reshape(Image_Sets{j}(:,i),icol,irow);
    %     img=img';
    %     eval('imwrite(img,str)');
    %     subplot(ceil(sqrt(M)),ceil(sqrt(M)),i
    %     imshow(img)
    %     drawnow;
    % end


    % mean image
    m=mean(S,2); % calculates the mean of each row instead of each column
    tmimg=uint8(m); % converts to unsigned 8-bit integer. Values range from 0 to 255
    img=reshape(tmimg,icol,irow); % takes the N1*N2x1 vector and creates a N1xN2 matrix
    img=img';
    if(plot_stuff)
        figure(3);
        imshow(img)
        title('Mean Image','fontsize',18)
        drawnow;
    end


    % Change image for manipulation
    dbx=[]; % A matrix
    for i=1:M
        temp=double(S(:,i));
        dbx=[dbx temp];
    end

    %Creating covariance matrix  L
    A=dbx';
    L=A*A';
    % vv is the eigenvector for L
    % dd is the eigenvalue for  L=dbx'*dbx;
    [vv dd]=eig(L);
    % Sort and eliminate ones with zero eigenvalue
    v=[];
    d=[];
    for i=1:size(vv,2)
        if(dd(i,i)>1e-4)
            v=[v vv(:,i)];
            d=[d dd(i,i)];
        end
    end

    %sort d in ascending order
    [B index]=sort(d);
    ind=zeros(size(index));
    dtemp=zeros(size(index));
    vtemp=zeros(size(v));
    len=length(index);
    for i=1:len
        dtemp(i)=B(len+1-i);
        ind(i)=len+1-index(i);
        vtemp(:,ind(i))=v(:,i);
    end
    d=dtemp;
    v=vtemp;


    %Normalization of eigenvectors
    for i=1:size(v,2) %access each column
        kk=v(:,i);
        temp=sqrt(sum(kk.^2));
        v(:,i)=v(:,i)./temp;
    end

    %Eigenvectors of C matrix
    u=[];
    for i=1:size(v,2)
        temp=sqrt(d(i));
        u=[u (dbx*v(:,i))./temp];
    end

    %Normalization of eigenvectors
    for i=1:size(u,2)
    kk=u(:,i);
    temp=sqrt(sum(kk.^2));
    u(:,i)=u(:,i)./temp;
    end


    % show eigenfaces
    if(plot_stuff)
        figure(4);
        for i=1:size(u,2)
            img=reshape(u(:,i),icol,irow);
            img=img';
            img=histeq(img,255);
            subplot(ceil(sqrt(M)),ceil(sqrt(M)),i)
            imshow(img)
            drawnow;
            if i==3
                title('Eigenfaces','fontsize',18)
            end
        end
    end


    % Find the weight of each face in the training set
    omega = [];
    for h=1:size(dbx,2)
        WW=[];
        for i=1:size(u,2)
            t = u(:,i)';
            WeightOfImage = dot(t,dbx(:,h)');
            WW = [WW; WeightOfImage];
        end
        omega = [omega WW];
    end

    % Test input images
    for test_idx = 1:size(test_images,2)
        InputImage = test_images{test_idx};
        InputImage=rgb2gray(InputImage);
        figure(5)
        subplot(1,2,1)
        imshow(InputImage); colormap('gray');title('Input image','fontsize',18)
        InImage=reshape(double(InputImage)',irow*icol,1);
        %Normalization
        temp=InImage;
        me=mean(temp);
        st=std(temp);
        temp=(temp-me)*ustd/st+um;
        NormImage = temp;
        %Finding difference
        Difference = temp-m;

        p = [];
        aa=size(u,2);
        for i = 1:aa
            pare = dot(NormImage,u(:,i)); %dot returns scalar vector product
            p = [p; pare];
        end
        ReshapedImage = m + u(:,1:aa)*p; %m is the mean image, u is the eigenvector
        ReshapedImage = reshape(ReshapedImage,icol,irow);
        ReshapedImage = ReshapedImage';
        %show the reconstructed image.
        subplot(1,2,2)
        imagesc(ReshapedImage); colormap('gray');
        title('Reconstructed image','fontsize',14)

        InImWeight = [];
        for i=1:size(u,2)
            t = u(:,i)';
            WeightOfInputImage = dot(t,Difference'); %scalar vector product of vectors t and Difference
            InImWeight = [InImWeight; WeightOfInputImage];
        end

        % Find Euclidean distance
        e=[];
        for i=1:size(omega,2)
            q = omega(:,i);
            DiffWeight = InImWeight-q;
            mag = norm(DiffWeight);
            e = [e mag];
        end

        kk = 1:size(e,2);
        subplot(1,2,2)
        stem(kk,e)
        title('Eucledian distance of input image','fontsize',14)

        distances{test_idx} = e;
    end
end