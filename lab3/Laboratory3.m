% Get the raw signature data
[PatrickSigs,AndySigs,AndyPatrickSigs,PatrickAndySigs] = GetDatabase();

% Filter out samples that occur at the same time
count = size(AndySigs);
count = count(2);
AndySigsFiltered = struct('coord', {}, 'prs', {}, 'time', {});
for i = 1:count
    AndySigsFiltered(i) = FilterTime(AndySigs(i));
end

% Save all the signature data to single file
for i=1:count
    s(i) = AndySigsFiltered(i);
    sAll_authentic{i} = double(struct2array(s(i))'); % transpose
end
save authSig sAll_authentic;

count = size(PatrickAndySigs);
count = count(2);
PatrickAndySigsFiltered = struct('coord', {}, 'prs', {}, 'time', {});
for i = 1:count
    PatrickAndySigsFiltered(i) = FilterTime(PatrickAndySigs(i));
end

% Save all the signature data to single file
for i=1:count
    s(i) = PatrickAndySigsFiltered(i);
    sAll_forged{i} = double(struct2array(s(i))'); % transpose
end
save forgSig sAll_forged;

% Filter out samples that occur at the same time
count = size(PatrickSigs);
count = count(2);
PatrickSigsFiltered = struct('coord', {}, 'prs', {}, 'time', {});
for i = 1:count
    PatrickSigsFiltered(i) = FilterTime(PatrickSigs(i));
end

% Save all the signature data to single file
for i=1:count
    s(i) = PatrickSigsFiltered(i);
    sAll_imposter{i} = double(struct2array(s(i))'); % transpose
end
save imposSig sAll_imposter;



function [res] = FilterTime(sig)
    %initialze a buffer for filtered time, coordinate and pressure values
    j = 1;
    t = zeros(size(sig.t,1)-1, 1);
    xy = zeros(size(sig.t,1)-1, 2);
    p = zeros(size(sig.t,1)-1, 1);
    for i = 1:size(sig.t,1)-1
        %skip any measurements made less than 1ms apart
        if(sig.t(i+1) - sig.t(i) <= 1.0)
            continue;
        end

        t(j) = sig.t(i);
        xy(j, 1) = sig.xy(i, 1);
        xy(j, 2) = sig.xy(i, 2);
        p(j) = sig.p(i);
        j = j + 1;
    end

    t = t(1:j,:);
    xy = xy(1:j,:);
    p = p(1:j,:);

    res = struct('coord', {}, 'prs', {}, 'time', {});
    res(1).time = t;
    res(1).coord = xy;
    res(1).prs = p;
    res = res(1);
end
