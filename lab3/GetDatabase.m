
function [PatrickSigs,AndySigs,AndyPatrickSigs,PatrickAndySigs] = GetDatabase()
    PatrickSigs = LoadSignatureSet('PatrickSigs', 30);
    AndySigs = LoadSignatureSet('AndySigs', 30);
    AndyPatrickSigs = LoadSignatureSet('AndyPatrickSigs', 30);
    PatrickAndySigs = LoadSignatureSet('PatrickAndySigs', 30);
end

function [loadedSignatures] = LoadSignatureSet(prefix, count)
    loadedSignatures = struct('xy',[],'y',[],'p',[]);
    for i = 1 : count
        filename = strcat(prefix, '/', int2str(i), '.csv');
        Sig = csvread(filename,1,0);
        
        loadedSignatures(i).xy = double(Sig(:,1:2));
        loadedSignatures(i).t = double(Sig(:,4));
        loadedSignatures(i).p = round(double(Sig(:,3))*255);       
        loadedSignatures(i).xy(:,2) = max(loadedSignatures(i).xy(:,2)) - loadedSignatures(i).xy(:,2);
    end
end

