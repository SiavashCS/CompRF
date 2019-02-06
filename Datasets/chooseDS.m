function [XTr,YTr,XTe,YTe,data_title,n0] = chooseDS(datasetNum)
%CHOOSEDS Summary of this function goes here
%   Detailed explanation goes here
switch datasetNum
    
    case 1
        load('MNIST.mat');
        data_title= 'MNIST';
        XTr = fea(1:60000,:);
        YTr = gnd(1:60000,:);
        XTe = fea(60001:end,:);
        YTe = gnd(60001:end,:);
        
        
    case 2
        load('gisTrainValid.mat');
        data_title= 'Gisette';
        XTr = gisTrainData;
        YTr = gisTrainLabel;
        XTe = gisValidData;
        YTe = gisValidLabel;
        
    case 3
        load('UCIHAR.mat');
        data_title= 'UCIHAR';
        XTr = Xtrain;
        YTr = ytrain;
        XTe = Xtest;
        YTe = ytest;
        
    case 4
        load('ISOLET.mat');
        data_title= 'Isolet';
        XTr = TrainDt;
        YTr = TrainLabel;
        XTe = TestDt;
        YTe = TestLabel;
        
    case 5
        load('ONPdata.mat');
        data_title= 'ONP';
        XTr = Dt;
        YTr = label;
        XTe = [];
        YTe = [];
        n0 = 256;

    case 6
        load('boston.mat');
        data_title= 'Boston';
        XTr = boston(:,1:13);
        YTr = boston(:,14);
        XTe = [];
        YTe = [];
        n0 = 4;
    case 7
        load('forestfire.mat');
        data_title= 'ForestFire';
        XTr = ffData;
        YTr = labels;
        XTe = [];
        YTe = [];
        n0 = 256;
    case 8
        load('wine.mat');
        data_title= 'Wine';
        XTr = winequalitywhite(:,1:end-1);
        YTr = winequalitywhite(:,end);
        XTe = [];
        YTe = [];
        n0 = 4;
end
end

