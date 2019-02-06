function [XTr,YTr] = validateTrain(XTr,YTr)

n = size(XTr,1);
TX = [];
TY = [];
idenInds = [];

for i=1:n
    if ismember(i,idenInds)
        continue;
    end
    dists = pdist2(XTr(i,:),XTr(i+1:end,:));
    sameInd = find(dists ==0);
    idenInds = [idenInds;i+sameInd];
    TX = [TX;XTr(i,:)];
    TY = [TY;mean(YTr([i,sameInd],1))];
        
end

XTr = TX;
YTr = TY;