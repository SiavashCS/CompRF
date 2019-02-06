function [ Sets , heights, triplets,SetsTest] = makeMTreeTrTeDisSup( Trdists,YTr,inds, n0, h,Tedists,indsTest)
%MAKETREE make a metric tree based on n*p "data" matrix, inds are the
%indexes of data opints to use (for recursion porpuse) and n0 is the
%maximum number of points allowed in each leaf
% output: Sets are cells containing the indices of points in each node of
% the tree, h is the height of the tree

n=size(Trdists,1);
if n<=n0  % checking if a leaf is reached
    Sets = {inds};
    SetsTest = {indsTest};
    heights=h+1;
    triplets=[];
    return;
end

flag = 0;
NodeTrips = zeros(0,3);
failCount = 0;
while(flag==0) % empty cells shouldn't happen
    failCount = failCount + 1;
    if length(YTr)==sum(YTr==YTr(1)) || failCount>5
%         failCount
        P = randperm(n,2);
    else
        L=[1,1];
        while(L(1)*L(2)>0)
            P = randperm(n,2);
            L = YTr(P);
        end
        
    end
    
    %% Choosing sets S1 and S2 based on the distance to P(1) and P(2)
    dists2 = Trdists(:,P);
    [~,minInd] = sort(dists2,2);
    S1 = find(minInd(:,1)==1);
    S2 = find(minInd(:,1)==2);
    if (length(S1)>0 && length(S2)>0 )
        NodeTrips = [NodeTrips;[inds(S1)',repmat(inds(P),length(S1),1)]];
        NodeTrips = [NodeTrips;[inds(S2)',repmat(inds([P(2),P(1)]),length(S2),1)]];
        flag=1;
        dists2Test = Tedists(:,P);
        [~,minInd] = sort(dists2Test,2);
        S1Test = find(minInd(:,1)==1);
        S2Test = find(minInd(:,1)==2);
        
        NodeTrips = [NodeTrips;[indsTest(S1Test)',repmat(inds(P),length(S1Test),1)]];
        NodeTrips = [NodeTrips;[indsTest(S2Test)',repmat(inds([P(2),P(1)]),length(S2Test),1)]];
        
    end
%     if count>20
%     S1 = randperm(n,floor(n/2));
%     S2 = setdiff(1:n,S1);
%         S1Test = find(sum(Tedists(:,S1),2)/length(S1) < sum(Tedists(:,S2),2)/length(S2));
%         S2Test = setdiff(1:size(Tedists,1),S1Test);
%         flag = 1;
%     end
end


[S1,h1,tr1,S1Test] = makeMTreeTrTeDisSup(Trdists(S1,S1),YTr(S1),inds(S1),n0,h+1,Tedists(S1Test,S1),indsTest(S1Test));
[S2,h2,tr2,S2Test] = makeMTreeTrTeDisSup(Trdists(S2,S2),YTr(S2),inds(S2),n0,h+1,Tedists(S2Test,S2),indsTest(S2Test));

Sets = [S1,S2];
heights = [h1,h2];
triplets = [NodeTrips ; tr1;tr2];

SetsTest = [S1Test,S2Test];
end

