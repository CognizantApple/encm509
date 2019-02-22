function GaborShow(img, xsize, ysize, std_dev_x, std_dev_y, angle, f)
    filter=GaborFilter(xsize,ysize,std_dev_x, std_dev_y, angle, f);
       
    imgFiltered=imfilter(img,filter);
    
    imgFilteredBlocked=blkproc( imgFiltered, [xsize/2 ysize/2], inline('abs(mean2(x)-std2(x))'));

    figure(1), plot(2), imagesc(img), colormap gray;
    saveas(figure(1),'img/Gabor/original.jpg');
    figure(2), plot(2), imagesc(filter), colormap gray;
    saveas(figure(2),'img/Gabor/filter.jpg');
    figure(3), plot(2), imagesc(imgFilteredBlocked), colormap gray;
    saveas(figure(3),'img/Gabor/filtered.jpg');
    
    close all;
end
