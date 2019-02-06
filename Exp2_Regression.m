% This code is provided for the "Regresssion" (section 4.1.2)
% experiment of the paper "Comparison-based Random Forests" appeared in
% ICML2018. For more details please look at the paper:

% http://proceedings.mlr.press/v80/haghiri18a/haghiri18a.pdf

% In case of questions regarding the code or paper pls contact:

% haghiri@informatik.uni-tuebingen.de, siyavash.haghiri@gmail.com

clear ;
close all;
addpath('./Datasets');
addpath('./Tree+Forest/');

m = 100; % number of trees to make for each forest, set to 100 by the CV
folds = 10;
mse = zeros(4,folds,2); % The MSE of 4 datasets and 2 methods
% datasets are ONP, Boston, UCIHAR, and Isolet respectively
% methods are CompRF unsupervised,and CART RF

for datasetNum = 1:4
    [Dt,label,~,~,data_title,n0] = chooseDS(datasetNum+4);
    n = size(Dt,1);
    fs = floor(n/folds);
    perm = randperm(n);
    for f=1:folds
        teInds = perm(fs*(f-1)+1:fs*f);
        trInds = setdiff(1:n,teInds);
        XTr = Dt(trInds,:);
        YTr = label(trInds,1);
        XTe = Dt(teInds,:);
        YTe = label(teInds,1);
        % running the CART random forest for regression
        disp([data_title,', CART RF, fold = ',num2str(f)]);
        st = statset('UseParallel',true);
        RFmodel = TreeBagger(m,XTr,YTr,'Options',st,'Method','regression','InBagFraction',1) ;
        Yfit = predict(RFmodel,XTe);
        mse(datasetNum,f,1) = sqrt(mean((Yfit-YTe).^2));
        % running unsupervised CompRF for regression
        disp([data_title,', CompRF, fold = ',num2str(f)]);
        YCT  = CTRF( XTr,YTr,XTe,n0,m);
        mse(datasetNum,f,2) = sqrt(mean((YCT-YTe).^2));
    end
end
%%
save('Exp2_Regression.mat');
T = array2table(squeeze(mean(mse,2))');
T.Properties.RowNames = {'CART RF','CompRF unsup'};
T.Properties.VariableNames = {'Boston','ONP','ForestFire','Wine'};
disp('Table of mean errors');
disp(T)


