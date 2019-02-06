function [ YTe, Triplets ] = CTRFTrips( XTr,YTr,XTe,n0,m)
% Makes an ensemble of comparison trees for classification or regression.
% mode: defines if class/reg and sup/unsup ...
nTr = size(XTr,1);
nTe = size(XTe,1);


n = nTr + nTe;

% if isSup==0 && isReg==1
%     Sets = cell(m,n);
%     TestSetsInd = zeros(m,n);
%     for tree=1:m
%         perm = randperm(nTr,nFrac);
%         XFrac = XTr(perm,:);
%         YFrac(:,tree) = YTr(perm,1);
%         [ SetsTemp , ~, Trips,SetsTest] = makeMTreeTrTeTrips( XFrac,1:nFrac, n0, 0,XTe,1+nFrac:n);
%         Sets(tree,1:length(SetsTemp))=SetsTemp;
%         for i=1:length(SetsTest)
%             TestSetsInd(tree,SetsTest{i})=i;
%         end
%     end
%     YTe = zeros(nTe,1);
%     parfor dataInd = 1:nTe
%         Ys = [];
%         for tree = 1:m
%             Ys = [Ys;YFrac(Sets{tree,TestSetsInd(tree,dataInd+nFrac)},tree)];
%         end
%         YTe(dataInd,1) = mean(Ys);
%     end
% end
%
% % 2nd case
% if isSup==1 && isReg==1
%     Sets = cell(m,n);
%     TestSetsInd = zeros(m,n);
%     for tree=1:m
%         perm = randperm(nTr,nFrac);
%         XFrac = XTr(perm,:);
%         YFrac(:,tree) = YTr(perm,1);
%         [ SetsTemp , ~, ~,SetsTest] = makeMTreeTrTeSupR( XFrac,YFrac(:,tree),1:nFrac, n0, 0,XTe,1+nFrac:n);
%         Sets(tree,1:length(SetsTemp))=SetsTemp;
%         for i=1:length(SetsTest)
%             TestSetsInd(tree,SetsTest{i})=i;
%         end
%     end
%     YTe = zeros(nTe,1);
%     parfor dataInd = 1:nTe
%         Ys = [];
%         for tree = 1:m
%             Ys = [Ys;YFrac(Sets{tree,TestSetsInd(tree,dataInd+nFrac)},tree)];
%         end
%         YTe(dataInd,1) = mean(Ys,1);
%     end
% end
Triplets = zeros(0,3);

    Sets = cell(m,n);
    TestSetsInd = zeros(m,n);
    for tree=1:m
        [ SetsTemp , ~, Trips,SetsTest] = makeMTreeTrTeSupTrips( XTr,YTr,1:nTr, n0, 0,XTe,1+nTr:n);
        Sets(tree,1:length(SetsTemp))=SetsTemp;
        for i=1:length(SetsTest)
            TestSetsInd(tree,SetsTest{i})=i;
        end
        Triplets = [Triplets;Trips];
    end
    YTe = zeros(nTe,1);
    parfor dataInd = 1:nTe
        Ys = [];
        for tree = 1:m
            Ys = [Ys;YTr(Sets{tree,TestSetsInd(tree,dataInd+nTr)},1)];
        end
        YTe(dataInd,1) = (mean(Ys));
    end

% if isSup==1 && isReg==0
%     Sets = cell(m,n);
%     TestSetsInd = zeros(m,n);
%     for tree=1:m
%         perm = randperm(nTr,nFrac);
%         XFrac = XTr(perm,:);
%         YFrac(:,tree) = YTr(perm,1);
%         [ SetsTemp , ~, Trips,SetsTest] = makeMTreeTrTeSup( XFrac,YFrac(:,tree),1:nFrac, n0, 0,XTe,1+nFrac:n);
%         Sets(tree,1:length(SetsTemp))=SetsTemp;
%         for i=1:length(SetsTest)
%             TestSetsInd(tree,SetsTest{i})=i;
%         end
%         Triplets = [Triplets;Trips];
%         
%     end
%     YTe = zeros(nTe,1);
%     parfor dataInd = 1:nTe
%         Ys = [];
%         for tree = 1:m
%             Ys = [Ys;YFrac(Sets{tree,TestSetsInd(tree,dataInd+nFrac)},tree)];
%         end
%         YTe(dataInd,1) = (mean(Ys,1));
%     end
% end
end






