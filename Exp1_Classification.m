% This code is provided for the "Classification" (section 4.1.1)
% experiment of the paper "Comparison-based Random Forests" appeared in
% ICML2018. For more details please look at the paper:

% http://proceedings.mlr.press/v80/haghiri18a/haghiri18a.pdf

% In case of questions regarding the code or paper pls contact:
% haghiri@informatik.uni-tuebingen.de, siyavash.haghiri@gmail.com

clear ;
close all;
addpath('./Datasets');
addpath('./Tree+Forest/');
warning ('off','all');

iterations = 10; % We run each experiment 10 times to see the randomization effect of tree-constructions
n0 = 1; % number of points in the leaf nodes, set to 1 by the CV
m=100; % number of trees to make for each forest, set to 100 by the CV
k_range = [2:4:20]; % The range of K for the KNN classifier 

ClError = zeros(4,iterations,4); % contain the accuracies of 4 datasets, 4 methods
% datasets are MNIST, Gisette, UCIHAR, and Isolet respectively
% methods are CompRF unsupervised, CompRF supervised, CART RF, and KNN respectively

for datasetNum = 1:4
    
    [XTr,YTr,XTe,YTe,data_title] = chooseDS(datasetNum);
    
    %%%%%!! subsampling uncomment to run faster !!%%%%%%%
    permTr = randperm(size(XTr,1),1000);
    permTe = randperm(size(XTe,1),500);
    XTr = XTr(permTr,:);
    YTr = YTr(permTr,:);
    XTe = XTe(permTe,:);
    YTe = YTe(permTe,:);
%         
    parfor it=1:iterations
        warning ('off','all');
        disp([data_title,', CompRF unsupervised, it=',num2str(it)]);
        % running the CompRF, unsupervised!
        [ YCTRF ] = CTRF_CL( XTr,YTr,XTe,n0,m,0);
        ClError(datasetNum,it,1) = (1-sum((YCTRF)==YTe)/(length(YTe)))*100;
    end
    
    parfor it1=1:iterations
        warning ('off','all');
        disp([data_title,', CompRF supervised, it=',num2str(it1)]);
        % running the CompRF, supervised!
        [ YCTRF ] =  CTRF_CL( XTr,YTr,XTe,n0,m,1);
        ClError(datasetNum,it1,2) = (1-sum((YCTRF)==YTe)/(length(YTe)))*100;
    end
    
    parfor it2=1:iterations
        warning ('off','all');
        % performing CART RF for classification
        disp([data_title,', CART, it=',num2str(it2)]);
        st = statset('UseParallel',true);
        RFmodel = TreeBagger(m,XTr,YTr,'Options',st,'MinLeafSize',n0) ;
        Yfit = predict(RFmodel,XTe);
        YRF = zeros(length(Yfit),1);
        for i=1:length(Yfit)
            YRF(i,1)=str2double(Yfit{i});
        end
        ClError(datasetNum,it2,3) = (1-sum(YRF==YTe)/(length(YTe)))*100;
    end
    % running KNN, the CV is included
    disp([data_title,', KNN']);
    [kInd,~] = knnCrossVal(XTr,YTr,k_range,10);
    k = k_range(kInd);
    Model = fitcknn(XTr,YTr,'NumNeighbors',k);
    YKNN = predict(Model,XTe);
    ClError(datasetNum,:,4) = (sum(YKNN~=YTe)/size(YTe,1))*100;
    
end
%%
save('Exp1_Classification.mat');
T = array2table(squeeze(mean(ClError,2))');
T.Properties.RowNames = {'CompRF unsup','CompRF sup','CART RF','KNN'};
T.Properties.VariableNames = {'MNIST','Gisette','UCIHAR','Isolet'};
disp('Table of mean errors');
disp(T)


