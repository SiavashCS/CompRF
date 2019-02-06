% This code is provided for the "Metric, non-Euclidean setting" (section 4.2)
% experiment of the paper "Comparison-based Random Forests" appeared in
% ICML2018. For more details please look at the paper:

% http://proceedings.mlr.press/v80/haghiri18a/haghiri18a.pdf

% In case of questions regarding the code or paper pls contact:

% haghiri@informatik.uni-tuebingen.de, siyavash.haghiri@gmail.com

clear ;
close all;
addpath('./Datasets');
addpath('./Tree+Forest/');
addpath(genpath('./graphkernels/'));

m = 100; % number of trees to make for each forest
folds = 10; % number of folds to make training and test sets
ClError = zeros(4,folds,4); % contain the accuracies of 4 datasets, 4 methods

% datasets are MNIST, Gisette, UCIHAR, and Isolet respectively
% method are SVM, CompRF unsup, CompRF sup and KNN respectively

%% the whole experiment on MUTAG
for datasetNum = 1:4
    
    [graph,labels,data_title] = chooseGraph(datasetNum);
    
    labels(labels==0) = -1;
    Kernels = WLedge(graph,3,1);
    K = Kernels{4};
    [resultSVM,~,~] = runIndependent(K,labels'); %running the svm 10-fold
    ClError(datasetNum,:,1) = 100 - resultSVM;
    
    K = makepos(K);
    m1 = repmat(diag(K),1,size(K,1));
    dists = m1+m1'-2*K;
    folds = 10;
    n = size(K,1);
    perm = randperm(n);
    fsize = floor(n/folds);
    n0 = 1;
    k_range = [2:4:20];
    for f = 1:folds
        warning ('off','all');
        
        disp(['n0=',num2str(n0),', fold=',num2str(f),', m=',num2str(m)]);
        TeInd = perm((f-1)*fsize+1:f*fsize);
        TrInd = setdiff(1:n,TeInd);
        distsTrTr = dists(TrInd,TrInd);
        distsTeTr = dists(TeInd,TrInd);
        YTr = labels(TrInd,:);
        if length(unique(labels))==2 % if it is binary classification
            [ YTe ] = CTRF_Dis( distsTrTr,YTr,distsTeTr,n0,m,0);
            ClError(datasetNum,f,2) = (1-sum(sign(YTe) == labels(TeInd))/size(YTe,1))*100;
            [ YTe ] = CTRF_Dis( distsTrTr,YTr,distsTeTr,n0,m,1);
            ClError(datasetNum,f,3) = (1-sum(sign(YTe) == labels(TeInd))/size(YTe,1))*100;
        else
            [ YTe ] = CTRF_CL_Dis( distsTrTr,YTr,distsTeTr,n0,m,0);
            ClError(datasetNum,f,2) = (1-sum((YTe) == labels(TeInd))/size(YTe,1))*100;
            [ YTe ] = CTRF_CL_Dis( distsTrTr,YTr,distsTeTr,n0,m,1);
            ClError(datasetNum,f,3) = (1 - sum((YTe) == labels(TeInd))/size(YTe,1))*100;
        end
        kInd = KnnDistCV(distsTrTr,YTr,k_range,10);
        k = k_range(kInd(1,1));
        YPr = knnClassifyDist(distsTeTr,YTr,k);
        ClError(datasetNum,f,4) = (1-sum(labels(TeInd)==YPr')/length(YPr))*100;
    end
    
    
end
save('Exp3_GraphKernels.mat');
%%

T = array2table(squeeze(mean(ClError,2))');
T.Properties.RowNames = {'KernelSVM','CompRF unsup','CompRF sup','KNN'};
T.Properties.VariableNames = {'MUTAG','ENZYMES','NCI1','NCI109'};
disp('Table of mean errors');
disp(T)



