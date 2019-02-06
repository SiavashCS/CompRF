function [ YTe ] = CompTreeRF( XTr,YTr,XTe,n0,m,mode)
% Makes an ensemble of comparison trees for classification or regression.
% mode: defines if class/reg and sup/unsup ...
nTr = size(XTr,1);
nTe = size(XTe,1);
n = nTr + nTe;
switch mode
    case 1 % classification with -1,1 labels and unsupervised split
        Sets = cell(m,n);
        TestSetsInd = zeros(m,n);
        for tree=1:m
            [ SetsTemp , ~, ~,SetsTest] = makeMTreeTrTe_Trips( XTr,1:nTr, n0, 0,XTe,1+nTr:n);
            Sets(tree,1:length(SetsTemp))=SetsTemp;
            for i=1:length(SetsTest)
                TestSetsInd(tree,SetsTest{i})=i;
            end
        end
        YTe = zeros(nTe,1);
        parfor dataInd = 1:nTe
            trainInds = [];
            for set = 1:m
                trainInds = [trainInds,Sets{set,TestSetsInd(set,dataInd+nTr)}];
            end
            YTe(dataInd,1) = sign(sum(YTr(trainInds,1)));
        end
    case 2 % classification with -1,1 labels and supervised splits
        Sets = cell(m,n);
        TestSetsInd = zeros(m,n);
        for tree=1:m
            [ SetsTemp , ~, ~,SetsTest] = makeMTreeTrTeSup( XTr,YTr,1:nTr, n0, 0,XTe,1+nTr:n);
            Sets(tree,1:length(SetsTemp))=SetsTemp;
            for i=1:length(SetsTest)
                TestSetsInd(tree,SetsTest{i})=i;
            end
        end
        YTe = zeros(nTe,1);
        parfor dataInd = 1:nTe
            trainInds = [];
            for set = 1:m
                trainInds = [trainInds,Sets{set,TestSetsInd(set,dataInd+nTr)}];
            end
            YTe(dataInd,1) = sign(sum(YTr(trainInds,1)));
        end
    case 3 % regression with unsupervised split
        Sets = cell(m,n);
        TestSetsInd = zeros(m,n);
        for tree=1:m
            [ SetsTemp , ~, ~,SetsTest] = makeMTreeTrTe_Trips( XTr,1:nTr, n0, 0,XTe,1+nTr:n);
            Sets(tree,1:length(SetsTemp))=SetsTemp;
            for i=1:length(SetsTest)
                TestSetsInd(tree,SetsTest{i})=i;
            end
        end
        YTe = zeros(nTe,1);
        parfor dataInd = 1:nTe
            trainInds = [];
            for set = 1:m
                trainInds = [trainInds,Sets{set,TestSetsInd(set,dataInd+nTr)}];
            end
            YTe(dataInd,1) = mean(YTr(trainInds,1));
        end
    case 4 % regression with supervised split
        Sets = cell(m,n);
        TestSetsInd = zeros(m,n);
        for tree=1:m
            [ SetsTemp , ~, ~,SetsTest] = makeMTreeTrTeSupR( XTr,YTr,1:nTr, n0, 0,XTe,1+nTr:n);
            Sets(tree,1:length(SetsTemp))=SetsTemp;
            for i=1:length(SetsTest)
                TestSetsInd(tree,SetsTest{i})=i;
            end
        end
        YTe = zeros(nTe,1);
        parfor dataInd = 1:nTe
            trainInds = [];
            for set = 1:m
                trainInds = [trainInds,Sets{set,TestSetsInd(set,dataInd+nTr)}];
            end
            YTe(dataInd,1) = mean(YTr(trainInds,1));
        end
end
end

