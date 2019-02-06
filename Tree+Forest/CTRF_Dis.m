function [ YTe ] = CTRF_Dis( KTr,YTr,KTe,n0,m,isSup)
% Makes an ensemble of comparison trees for binary classification or regression
% based on the dissiilarity matrices KTr and KTe
% isSup: 1 means supervised classification
% KTr: The dissimiarity matrix of Training*Training
% KTe: The dissimiarity matrix of Training*Test
% KTr: The dissimiarity matrix of Training*Training
% n0: the maximum number of points in leaves
% m: number of trees
% YTe: estimated labels for the test data

nTr = size(KTr,1);
nTe = size(KTe,1);
n = nTr + nTe;

if isSup==1
    Sets = cell(m,n);
    TestSetsInd = zeros(m,n);
    for tree=1:m
        [ SetsTemp , ~, ~,SetsTest] = makeMTreeTrTeDis( KTr,1:nTr, n0, 0,KTe,1+nTr:n);
        Sets(tree,1:length(SetsTemp))=SetsTemp;
        for i=1:length(SetsTest)
            TestSetsInd(tree,SetsTest{i})=i;
        end
    end
    YTe = zeros(nTe,1);
    for dataInd = 1:nTe
        Ys = [];
        for tree = 1:m
            Ys = [Ys;YTr(Sets{tree,TestSetsInd(tree,dataInd+nTr)})];
        end
        YTe(dataInd,1) = (mean(Ys));
    end
else
    
    Sets = cell(m,n);
    TestSetsInd = zeros(m,n);
    for tree=1:m
        [ SetsTemp , ~, ~,SetsTest] = makeMTreeTrTeDisSup( KTr,YTr,1:nTr, n0, 0,KTe,1+nTr:n);
        Sets(tree,1:length(SetsTemp))=SetsTemp;
        for i=1:length(SetsTest)
            TestSetsInd(tree,SetsTest{i})=i;
        end
    end
    YTe = zeros(nTe,1);
    parfor dataInd = 1:nTe
        Ys = [];
        for tree = 1:m
            Ys = [Ys;YTr(Sets{tree,TestSetsInd(tree,dataInd+nTr)})];
        end
        YTe(dataInd,1) = (mean(Ys,1));
    end
end
end






