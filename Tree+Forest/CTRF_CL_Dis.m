function [ YTe ] = CTRF_CL_Dis( KTr,YTr,KTe,n0,m,isSup)
% Comparison-based forest for multilcass classification based on the
% dissimilarity KTr
% KTr: dissimilarity matrix of training data*training data
% YTr: training labels 
% KTe: dissimilarity matrix of training data*test data
% n0: the maximum number of points in leaves
% m: number of trees
% isSup: supervised/unsupervised
% YTe: estimated labels for the test data
% n0: the maximum number of points in leaves
% m: number of trees

nTr = size(KTr,1);
nTe = size(KTe,1);
labelsu = sort(unique(YTr));
c = length(labelsu);
Ys = zeros(c,c,nTe);

for l1Ind = 1:c
    l1 = labelsu(l1Ind);
    for l2Ind = l1Ind+1:c
        warning ('off','all');

        l2=labelsu(l2Ind);
        indsTr1 = find(YTr==l1);
        indsTr2 = find(YTr==l2);
        YTrn = [ones(length(indsTr1),1)*-1;ones(length(indsTr2),1)];
        KTrn = KTr([indsTr1;indsTr2],[indsTr1;indsTr2]);
        KTen = KTe(:,[indsTr1;indsTr2]);
        [ YTen ] = CTRF_Dis( KTrn,YTrn,KTen,n0,m,isSup);% runs a binary CompRF classification
        Ys(l1Ind,l2Ind,:) = YTen;
    end
end

Ys = Ys - permute(Ys,[2, 1, 3]);
avgYs = squeeze(sum(Ys,2));
[~,indYTe] = min(avgYs);
YTe = labelsu(indYTe);






