%Grab the prepared data
clear all
close all
[AndyThumbs,PatrickThumbs] = GetDatabaseLab45();

% Lab4Fingerprint1Auto(PatrickThumbs{22}, "img/22_Default/skeleton_1");
% Lab4Fingerprint1Auto(PatrickThumbs{27}, "img/27_Default/skeleton_1");

%----------------------------------------------------------------------
%----------------------- MATCHING EXERCISE 1 --------------------------
%----------------------------------------------------------------------
Exercise_1 = false;
if(Exercise_1)
    %----------------------------------------------------------------------
    %-------- Select fingerprint 1
    %----------------------------------------------------------------------
    % Let's use Andy's 16th print as the probe.
    img = AndyThumbs{16};
    disp('Processing Matching Exercise 1...');
    Fp1 = PreProcess(img);
    GaborScores = {9,1};
    MinutiaScores = {9,1};

    starting_idx = 17;
    for i = 1:9
        j = i + starting_idx - 1;
        %----------------------------------------------------------------------
        %-------- Select fingerprint 2
        %----------------------------------------------------------------------
        img = AndyThumbs{j};
        Fp2 = PreProcess(img);

        %----------------------------------------------------------------------
        %---- Fingerprint comparison using two methods: Gabor and local matching
        %
        %----------------------------------------------------------------------
        Score1 = MatchGaborFeat(Fp1,Fp2);
        fprintf('Score 1 for print %d using Gabor features: %1.2g\n', i, Score1);

        threshold2=12; % Using 12, as it was arbitrarily suggested in Lab5Fingerprint2.m

        Fp2=align2(Fp1,Fp2);
        Score2=match(Fp1.minutiaArray, Fp2.minutiaArrayAlign, Fp1.imSkeleton, Fp2.imSkeletonAlign,threshold2);
        fprintf('Score 2 for print %d for minutiae : %1.2g\n', i, Score2);
        GaborScores{i} = Score1;
        MinutiaScores{i} = Score2;
    end
    % Lazy way to print the scores and get them in a column
    GaborScores = GaborScores'
    MinutiaScores = MinutiaScores'
end

%----------------------------------------------------------------------
%----------------------- MATCHING EXERCISE 2 --------------------------
%----------------------------------------------------------------------
Exercise_2 = true;
if(Exercise_2)
    %----------------------------------------------------------------------
    %-------- Select fingerprint 1
    %----------------------------------------------------------------------
    % Let's use Andy's 16th print as the probe.
    probe = PreProcess(AndyThumbs{16});

    % Set up our little database, with one of Andy's prints at the start
    database_images{1} = PreProcess(AndyThumbs{18});
    database_images{1} = align2(probe, database_images{1});

    j = 2
    for i = 1:30
        % Grab some of Patrick's thumbs
        fprintf('Processing and aligning print number %d\n', i);
        img2 = PreProcess(PatrickThumbs{i});
        % Try and align the image, I suppose
        try
            img2 = align2(probe,img2);
            database_images{j} = img2;
            j = j + 1;
            if(j == 12)
                break;
            end
        catch ME
            fprintf('Could not align print number %d\n', i);
        end
    end

    MinutiaScores = {11,1};

    for i = 1:11
        %----------------------------------------------------------------------
        %---- Fingerprint comparison using... local matching.
        %----------------------------------------------------------------------

        threshold2=12; % Using 12, as it was arbitrarily suggested in Lab5Fingerprint2.m

        img2=align2(probe,database_images{i});
        Score_m=match(probe.minutiaArray, img2.minutiaArrayAlign, probe.imSkeleton, img2.imSkeletonAlign,threshold2);
        fprintf('Score for print %d for minutiae : %1.2g\n', i, Score_m);
        MinutiaScores{i} = Score_m;
    end
    % Lazy way to print the scores and get them in a column
    MinutiaScores = MinutiaScores'
end


function [output_image] = PreProcess(input_image)
    %%% this function pre-processes an image before being scored for matching,
    %%% based on the pre-processing procedure done in Lab5Fingerprint2.m.
    output_image.imOrig = input_image;
    %%%disp('Segmentation');
    output_image = segmentimage(output_image);
    %%%disp('Orientation array');
    output_image = computeorientationarray(output_image);
    %%%disp('Finding the singularity point');
    output_image = findsingularitypoint(output_image);
    %%%disp('Local frequencies');
    output_image = computelocalfrequency(output_image, output_image.imOrig);
    %%%disp('Filtering');
    output_image = enhance2ridgevalley(output_image);
    %%%disp('Skeleton cleaning');
    output_image = cleanskeleton(output_image);
    %%%disp('Finding minutiae');
    output_image = findminutia(output_image);
end


