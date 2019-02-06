function [graph,labels,data_title] = chooseGraph(datasetNum)
%CHOOSEDS Summary of this function goes here
%   Detailed explanation goes here
switch datasetNum
    
    case 1
        load('MUTAG.mat');
        data_title= 'MUTAG';
        graph = MUTAG;
        labels = lmutag;      
        
    case 2
        load('ENZYMES.mat');
        data_title= 'ENZYMES';
        graph = ENZYMES;
        labels = lenzymes;      
        
    case 3
        load('NCI1.mat');
        data_title= 'NCI1';
        graph = NCI1;
        labels = lnci1;
        
    case 4
        load('NCI109.mat');
        data_title= 'NCI109';
        graph = NCI109;
        labels = lnci109;
end
end

