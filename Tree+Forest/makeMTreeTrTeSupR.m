function [ Sets , heights, triplets,SetsTest] = makeMTreeTrTeSupR( data,labels,inds, n0, h,dataTest,indsTest)
%MAKETREE make a metric tree based on n*p "data" matrix, inds are the
%indexes of data opints to use (for recursion porpuse) and n0 is the
%maximum number of points allowed in each leaf
% output: Sets are cells containing the indices of points in each node of
% the tree, h is the height of the tree

n=size(data,1);
if n<=n0  % checking if a leaf is reached
    Sets = {inds};
    SetsTest = {indsTest};
    heights=h+1;
    triplets=[];
    return;
end

flag = 0;
failCount = 0;
NodeTrips = zeros(0,3);
while(flag==0) % empty cells shouldn't happen
    failCount = failCount + 1;
    if length(labels)==sum(labels==labels(1)) || failCount>5
        
        P = randperm(n,2);
    else
        P(1) = randperm(n,1);
%         [~,P(1)] = max(labels);
        [~,P(2)] = max(labels-labels(P(1)));
        
    end
    
    %% Choosing sets S1 and S2 based on the distance to P(1) and P(2)
    
    dists2 = pdist2(data,data(P,:));
    [~,minInd] = sort(dists2,2);
    S1 = find(minInd(:,1)==1);
    S2 = find(minInd(:,1)==2);
    if length(S1)>0 && length(S2)>0
        NodeTrips = [NodeTrips;[inds(S1)',repmat(inds(P),length(S1),1)]];
        NodeTrips = [NodeTrips;[inds(S2)',repmat(inds([P(2),P(1)]),length(S2),1)]];
        flag=1;
        dists2Test = pdist2(dataTest,data(P,:));
        [~,minInd] = sort(dists2Test,2);
        S1Test = find(minInd(:,1)==1);
        S2Test = find(minInd(:,1)==2);
        
        NodeTrips = [NodeTrips;[indsTest(S1Test)',repmat(inds(P),length(S1Test),1)]];
        NodeTrips = [NodeTrips;[indsTest(S2Test)',repmat(inds([P(2),P(1)]),length(S2Test),1)]];
        
    end
    
end


[S1,h1,tr1,S1Test] = makeMTreeTrTeSupR(data(S1,:),labels(S1),inds(S1),n0,h+1,dataTest(S1Test,:),indsTest(S1Test));
[S2,h2,tr2,S2Test] = makeMTreeTrTeSupR(data(S2,:),labels(S2),inds(S2),n0,h+1,dataTest(S2Test,:),indsTest(S2Test));

Sets = [S1,S2];
heights = [h1,h2];
triplets = [NodeTrips ; tr1;tr2];

SetsTest = [S1Test,S2Test];
end

