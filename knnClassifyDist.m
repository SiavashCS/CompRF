function [ TeLabels ] = knnClassifyDist( distTeTr, TrLabels,k)
%KNNCLASSIFYDIST Summary of this function goes here
%   Detailed explanation goes here


[~, sortInds] = sort(distTeTr');
TeLabels = mode(TrLabels(sortInds(1:k,:)));
end

