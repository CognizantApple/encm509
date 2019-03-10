
function [AndyThumbs,PatrickThumbs] = GetDatabaseLab45()
    AndyThumbs    = LoadPrintSet('Data/AndyThumb', 30);
    PatrickThumbs = LoadPrintSet('Data/PatrickThumb', 30);
end

function [loadedPrints] = LoadPrintSet(prefix, count)
    loadedPrints = {1,30};
    for i = 1 : count
        filename = strcat(prefix, '/', int2str(i), '.bmp');
        img = imread(filename);
        
        loadedPrints{i} = rgb2gray(img);
    end
end