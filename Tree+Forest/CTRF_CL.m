function [ YTe ] = CTRF_CL( XTr,YTr,XTe,n0,m,isSup)
% Comparison-based forest for multilcass classification
% XTr, YTr: training data, training labels
% XTe: test data
% n0: the maximum number of points in leaves
% m: number of trees
% isSup: supervised/unsupervised
% YTe: estimated labels for the test data

nTr = size(XTr,1);
nTe = size(XTe,1);
labels = sort(unique(YTr));
c = length(labels);
Ys = zeros(c,c,nTe);
if isSup == 0
    for l1Ind = 1:c  % iterating on classes
        l1 = labels(l1Ind);
        parfor l2Ind = l1Ind+1:c
            warning ('off','all');
            l2=labels(l2Ind);
            indsTr1 = find(YTr==l1);
            indsTr2 = find(YTr==l2);
            YTrn = [ones(length(indsTr1),1)*-1;ones(length(indsTr2),1)];
            XTrn = XTr([indsTr1;indsTr2],:);
            [ YTen ] = CTRF(XTrn,YTrn,XTe,n0,m); % runs a binary CompRF classification
            Ys(l1Ind,l2Ind,:) = YTen;
        end
    end
    
else
    for l1Ind = 1:c  % iterating on classes
        l1 = labels(l1Ind);
        parfor l2Ind = l1Ind+1:c
            warning ('off','all');
            l2=labels(l2Ind);
            indsTr1 = find(YTr==l1);
            indsTr2 = find(YTr==l2);
            YTrn = [ones(length(indsTr1),1)*-1;ones(length(indsTr2),1)];
            XTrn = XTr([indsTr1;indsTr2],:);
            [ YTen ] = CTRFSup(XTrn,YTrn,XTe,n0,m); % runs a binary CompRF classification
            Ys(l1Ind,l2Ind,:) = YTen;
        end
    end
end




Ys = Ys - permute(Ys,[2, 1, 3]);
avgYs = squeeze(sum(Ys,2));
[~,indYTe] = min(avgYs);
YTe = labels(indYTe);






