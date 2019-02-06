function [ dimInd,kInd,cartdimInd,errKnn] = embKnnCV( trips, labels, dim_range,k_range,folds)
%EMBKNNCV Summary of this function goes here
%   Detailed explanation goes here

n = size(labels,1);

perm = randperm(n);
fs = floor(n/folds);
errKnn = zeros(length(dim_range),length(k_range),folds);
for dimInd = 1:length(dim_range)
    dim = dim_range(dimInd);
    disp(['CV, dim=',num2str(dim)]);
    embData = tste(trips, dim);
    
    parfor kInd=1:length(k_range)
        k = k_range(kInd);
        for f=1:folds
            warning ('off','all');
            teInds = perm(fs*(f-1)+1:fs*f);
            trInds = setdiff(1:n,teInds);
            Model = fitcknn(embData(trInds,:),labels(trInds,:),'NumNeighbors',k);
            PrTSTE = predict(Model,embData(teInds,:))
       
            errKnn(dimInd,kInd,f) = 1-sum(PrTSTE==labels(teInds,:))/(fs);
            
            
        end
    end
    parfor f=1:folds
        warning ('off','all');
        teInds = perm(fs*(f-1)+1:fs*f);
        trInds = setdiff(1:n,teInds);
        
        st = statset('UseParallel',true);
        RFmodel = TreeBagger(200,embData(trInds,:),labels(trInds,:),'Options',st,'MinLeafSize',1) ;
        Yfit = predict(RFmodel,embData(teInds,:));
        YRF = zeros(length(Yfit),1);
        for i=1:length(Yfit)
            YRF(i,1)=str2double(Yfit{i});
        end
        errCart(dimInd,f) = 1-sum(YRF==labels(teInds,:))/fs;
    end
end


mmse = mean(errKnn,3);
minMatrix = min(mmse(:));
[dimInd,kInd] = find(mmse==minMatrix);

[~, cartdimInd] = min(mean(errCart,2));
end

