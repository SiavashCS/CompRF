function [ kInd,err] = KnnDistCV( dists , labels, k_range,folds)
%EMBKNNCV Summary of this function goes here
%   Detailed explanation goes here

n = size(labels,1);

perm = randperm(n);
fs = floor(n/folds);
err = zeros(length(k_range),folds);


for kInd=1:length(k_range)
    k = k_range(kInd);
    for f=1:folds
        warning ('off','all');
        teInds = perm(fs*(f-1)+1:fs*f);
        trInds = setdiff(1:n,teInds);
        PrTSTE = knnClassifyDist(dists(teInds,trInds),labels(trInds,:),k);
        err(kInd,f) = 1-sum(PrTSTE==labels(teInds,:)')/(fs);
    end
end


mmse = mean(err,2);
[~,kInd] = min(mmse);

end

