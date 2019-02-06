% This code is provided for the "Comparison-based setting" (section 4.3)
% experiment of the paper "Comparison-based Random Forests" appeared in
% ICML2018. For more details please look at the paper:

% http://proceedings.mlr.press/v80/haghiri18a/haghiri18a.pdf

% In case of questions regarding the code or paper pls contact:
% haghiri@informatik.uni-tuebingen.de, siyavash.haghiri@gmail.com
clear;
close all;
addpath('./Datasets');
addpath('./Tree+Forest/');
addpath('./STE_Release/');

%%
M_range = [1,5,10,20];
for datasetNum = 1:4
    % loading a dataset among 4 in the experiment
    [Dt,labels,~,~,data_title] = chooseDS(datasetNum);
    labels(labels==0)=1;
    % keeping only two classes and 1000 items 
    if length(unique(labels))>2
        Dt = Dt(labels<3,:);
        labels = labels(labels<3,:);
    end
    if size(Dt,1)>1000
        perm = randperm(size(Dt,1),1000);
        Dt = Dt(perm,:);
        labels = labels(perm,:);
    end
    labels(labels==2)=-1;
    n=size(Dt,1);
    dim_range = 10:10:50;
    k_range = 2:4:20;
    dists = pdist2(Dt,Dt);
    TrInds = 1:n/2;
    TeInds = 1+n/2:n;
    n0 = 1;
    
    for MInd = 1:length(M_range)
        M = M_range(MInd);
        %%%% Running CompRF (supervised) and saving the triplets used
        [ YTe, triplets] = CTRFTrips( Dt(TrInds,:),labels(TrInds,1),Dt(TeInds,:),n0,M);
        numTrips(MInd) = size(triplets,1);
        outLabels = sign(YTe);
        outLabels(outLabels==0)=1;
        ClErr(datasetNum,1,MInd)  = 1 - sum(outLabels==labels(TeInds))/(n/2);
        %%%% Using embedding methods with the same triplets + KNN
         TrTrTrips = triplets(sum(ismember(triplets,TrInds),2)==3,:);
        [ dInd,kInd,cartdimInd,errST ] = embKnnCV( TrTrTrips, labels(TrInds,1), dim_range,k_range,2 );
        k = k_range(kInd(1,1));
        dim = dim_range(dInd(1,1));
        embData = tste(triplets, dim);
        Model = fitcknn(embData(TrInds,:),labels(TrInds,:),'NumNeighbors',k);
        PrTSTE = predict(Model,embData(TeInds,:));
        ClErr(datasetNum,2,MInd) = 1-sum(PrTSTE==labels(TeInds,:))/(size(TeInds,2));
        %%%% Using embedding methods with the same triplets + CART RF
        embData = tste(triplets, dim_range(cartdimInd(1,1)));    st = statset('UseParallel',true);
        RFmodel = TreeBagger(200,embData(TrInds,:),labels(TrInds,:),'Options',st,'MinLeafSize',n0) ;
        Yfit = predict(RFmodel,embData(TeInds,:));
        YRF = zeros(length(Yfit),1);
        for i=1:length(Yfit)
            YRF(i,1)=str2double(Yfit{i});
        end
        ClErr(datasetNum,3,MInd) = 1-sum(YRF==labels(TeInds,:))/(length(labels(TeInds,:)));
        %%%% Using embedding methods with the same number of random triplets + KNN
        numTrips(MInd) = size(triplets,1);
        rTrips = randTrips(dists,numTrips(MInd), n, 1);
        TrTrTrips = rTrips(sum(ismember(rTrips,TrInds),2)==3,:);
        [ dInd,kInd,cartdimInd, errRand] = embKnnCV( TrTrTrips, labels(TrInds,1), dim_range,k_range,2 );
        k = k_range(kInd(1,1));
        dim = dim_range(dInd(1,1));
        embData = tste(rTrips, dim);
        Model = fitcknn(embData(TrInds,:),labels(TrInds,:),'NumNeighbors',k);
        PrTSTE = predict(Model,embData(TeInds,:));
        ClErr(datasetNum,4,MInd) = 1-sum(PrTSTE==labels(TeInds,:))/(size(TeInds,2))
        %%%% Using embedding methods with the same number of random triplets + CART RF
        embData = tste(triplets, dim_range(cartdimInd(1,1)));
        st = statset('UseParallel',true);
        RFmodel = TreeBagger(200,embData(TrInds,:),labels(TrInds,:),'Options',st,'MinLeafSize',n0) ;
        Yfit = predict(RFmodel,embData(TeInds,:));
        YRF = zeros(length(Yfit),1);
        for i=1:length(Yfit)
            YRF(i,1)=str2double(Yfit{i});
        end
        ClErr(datasetNum,5,MInd) = 1-sum(YRF==labels(TeInds,:))/(length(labels(TeInds,:)));
    end
end
save('Exp4_Embeddings.mat');


%%


figure('Position',[400 400 1800 450]);
set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultTextFontSize', 14);
set(0, 'DefaultUIControlFontSize', 16);
set(0,'DefaultLineMarkerSize',13);

for datasetNum = 1:4
    
    [Dt,labels,~,~,data_title] = chooseDS(datasetNum);
    labels(labels==0)=1;
    if length(unique(labels))>2
        Dt = Dt(labels<3,:);
        labels = labels(labels<3,:);
    end
    if size(Dt,1)>1000
        perm = randperm(size(Dt,1),1000);
        Dt = Dt(perm,:);
        labels = labels(perm,:);
    end
    n=size(Dt,1);
    subplot(1,4,datasetNum);
    errs = squeeze(ClErr(datasetNum,:,:));
    bar(100*errs')
    xTickl = {['   M=1\newline T=',num2str(numTrips(1))],...
        ['   M=5\newline T=',num2str(numTrips(2))],...
        ['   M=10\newline T=',num2str(numTrips(3))],...
        ['   M=20\newline T=',num2str(numTrips(4))]};
    xticklabels(xTickl)
    if datasetNum==4
        legend({'CompRF','EmbKNN-Same','EmbCART-Same','EmbKNN-Rand','EmbCART-Rand'},'location','northeast');
    end
    xlim([0.4 4.6])
    grid on
    axis square
    title([data_title,', n=',num2str(n)]);
    xlabel('M: Number of trees, T: Number of triplets');
    ylabel('Avergae classification error');
 end
