function [ kInd,err ] = knnCrossVal( Dt,label, k_range,folds )
%REGCROSSVAL Summary of this function goes here
%   Detailed explanation goes here

n = size(Dt,1);
perm = randperm(n);
fs = floor(n/folds);
err = zeros(length(k_range),folds);
for kInd = 1:length(k_range)
    k = k_range(kInd);
    parfor f=1:folds
        teInds = perm(fs*(f-1)+1:fs*f);
        trInds = setdiff(1:n,teInds);
        disp(['KNNCV, f=',num2str(f),'k=',num2str(k)]);
        
        XTr = Dt(trInds,:);
        YTr = label(trInds,1);
        XTe = Dt(teInds,:);
        YTe = label(teInds,1);
        Model = fitcknn(XTr,YTr,'NumNeighbors',k);
        YKNN = predict(Model,XTe)
        
        err(kInd,f) = sum(YKNN~=YTe)/size(YTe,1);
    end
end

mmse = mean(err,2);
[~,kInd] = min(mmse);
end

