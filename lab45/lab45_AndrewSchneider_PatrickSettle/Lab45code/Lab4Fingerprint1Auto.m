%=========== ENCM 509 ===============%
%=========== Lab 4: Fingerprint: Part II ===============%
%============ Fingerpint matching score =================%
% by S. Yanushkevich, February 04,2009
% updated October 1, 2014

function Lab4Fingerprint1Auto(img, folder)
    mkdir(folder);

    Fp.imOrig = img;
    figure(1), imagesc(Fp.imOrig),colormap gray, title('Original Image');
    saveas(figure(1),strcat(folder,"/",'original.jpg'));
    
    Fp = segmentimage(Fp);
        
    figure(2), 
    subplot(1,2,1), imagesc(Fp.imSegmented),colormap gray, title('fingerprint segmented');
    subplot(1,2,2), imagesc(Fp.imContour),colormap gray, title('fingerprint contour');
    saveas(figure(2),strcat(folder,"/",'hmm.jpg'));

    [x,y]= find(Fp.imContour); 
    figure(3), title('Contour'), hold on, imagesc(Fp.imOrig),colormap gray;
    plot(y,x,'.'), axis ij, axis([1 size(Fp.imOrig,1) 1 size(Fp.imOrig,2)]);
    hold off;
    saveas(figure(3),strcat(folder,"/",'contour.jpg'));
    
    
    Fp = computeorientationarray(Fp);
    figure(4), imagesc(Fp.orientationArray), title('Orientation field');
    showorientationfield(Fp);
    saveas(figure(4),strcat(folder,"/",'orientation.jpg'));
    
    Fp = findsingularitypoint(Fp);
    [x,y]= find(Fp.singularityArray);
    figure(5), hold on, imagesc(Fp.imOrig),colormap gray;
    plot(y,x,'.'), axis ij, title('Singularity Point');
    hold off;
    saveas(figure(5),strcat(folder,"/",'singularity.jpg'));
    
    Fp = computelocalfrequency(Fp, Fp.imOrig);
    figure(6), imagesc(Fp.frequencyArray), title('Local frequencies');
    saveas(figure(6),strcat(folder,"/",'localfreq.jpg'));
    
    Fp = GaborEnhanced(Fp);
    figure(7), imagesc(Fp.imBinary), colormap gray, title('Binarized image');
    saveas(figure(7),strcat(folder,"/",'binarized.jpg'));

    [x,y]= find(Fp.imSkeleton);
    figure(8), title('Skeleton');
    hold on, imagesc(Fp.imOrig), colormap gray;
    plot(y,x,'r.'), axis ij;
    hold off;
    saveas(figure(8),strcat(folder,"/",'skeleton.jpg'));
    
    Fp = cleanskeleton(Fp);
    Sk=ones(size(Fp.imSkeleton,1),size(Fp.imSkeleton,2));
    Sk(1:size(Fp.imSkeleton,1)-50,1:size(Fp.imSkeleton,2)-50)=Fp.imSkeleton(26:size(Fp.imSkeleton,1)-25,26:size(Fp.imSkeleton,2)-25);
    Sk = imcomplement(Sk);
    [x,y]= find(Sk);

    figure(9), title('Skeleton cleaning');
    hold on, imagesc(Fp.imOrig),colormap gray;
    plot(y,x,'r.'), axis ij;            
    hold off;
    saveas(figure(9),strcat(folder,"/",'slick_skeleton.jpg'));
    
    Fp = findminutia(Fp);

    [x1,y1]= find(Fp.minutiaArray==1);
    [x2,y2]= find(Fp.minutiaArray==2);
    figure(10),
    
    hold on, imagesc(Fp.imOrig),colormap gray, title('Minutiae')
    plot(y1,x1,'or','markersize',8);
    plot(y2,x2,'sb','markersize',8), axis ij;
    legend('End of ridge', 'Bifurcation');
    hold off;
    saveas(figure(10),strcat(folder,"/",'minutiae.jpg'));
    
    close all;
end