function [ YTe ] = CTRFSup( XTr,YTr,XTe,n0,m)
% Comparison-based forest for regression.
% XTr, YTr: training data, training labels (for classification -1,1)
% XTe: test data
% n0: the maximum number of points in leaves
% m: number of trees
% isReg, isSup: sets the mode of forest (regression/classsification,
% supervised/unsupervised)
% frac: the fraction of training triplets to be used (between 0-1)
% YTe: estimated labels for the test data

nTr = size(XTr,1);
nTe = size(XTe,1);
n = nTr + nTe;
Ytemp = zeros(nTr,m);


Sets = cell(m,n);
TestSetsInd = zeros(m,n);
for tree=1:m
    perm = randperm(nTr);
    Xtemp = XTr(perm,:);
    Ytemp(:,tree) = YTr(perm,1);
    [ SetsTemp ,SetsTest] = makeMTreeTrTeSup( Xtemp,Ytemp(:,tree),1:nTr, n0,XTe,1+nTr:n);
    Sets(tree,1:length(SetsTemp))=SetsTemp;
    for i=1:length(SetsTest)
        TestSetsInd(tree,SetsTest{i})=i;
    end
end
YTe = zeros(nTe,1);
parfor dataInd = 1:nTe
    Ys = [];
    for tree = 1:m
        Ys = [Ys;Ytemp(Sets{tree,TestSetsInd(tree,dataInd+nTr)},tree)];
    end
    YTe(dataInd,1) = (mean(Ys,1));
end