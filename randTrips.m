function [ rand_triplets ] = randTrips( DD, numTrips, n, mode)
%RANDTRIPS makes random triplets
%   DD: n*n matrix of distances
%   numTrips: number of output triplets
%   n: number of elements
%   mode: the setting mode for random triplet generation
if mode==1 % uniformly random setting
    [~, sortInd] = sort(DD, 2, 'ascend');
        extra = floor(numTrips*.5);

    max_away = round(n / 2);
    rand_triplets = zeros(numTrips+extra, 3);
    for i=1:numTrips+extra
        ind1 = randi(n);
        ind2 = randi(max_away);
        ind3 = mod(ind2 + randi(max_away),n)+1;
        ind2 = sortInd(ind1, ind2);
        ind3 = sortInd(ind1, ind3);
        rand_triplets(i,:) = [ind1 ind2 ind3];
    end
    rand_triplets(rand_triplets(:,1)==rand_triplets(:,2),:)=[];
    
    extraNum = size(rand_triplets,1)-numTrips;
    
    if (extraNum>0)
        rand_triplets(randperm(extraNum),:)=[];
    end
    
elseif mode==2 % landmark setting
    rand_triplets = [];
    numPivots = floor(sqrt(2*numTrips/n) + .5)+1;
    pivots = randperm(n,numPivots);
%     DD(pivots,pivots)/sum(sum(DD))*100
%     pause;
    for i=1:numPivots
        p1 = pivots(i);
        for j=i+1:numPivots
            p2 = pivots(j);
            
            ind1 = double(DD(p1,:) < DD(p2,:))';
            ind2 = double(DD(p1,:) >= DD(p2,:))';
            
            
            trips = [(1:n)' ind1*p1+ind2*p2 ind1*p2+ind2*p1];
            rand_triplets = [rand_triplets;trips];
        end
    end
    
    rand_triplets(rand_triplets(:,1)==rand_triplets(:,2),:)=[];
    
    extraNum = size(rand_triplets,1)-numTrips;
    if (extraNum>0)
        rand_triplets(randperm(extraNum),:)=[];
    end
    length(rand_triplets)/(numTrips)
    
elseif mode==3 % easy triplet setting
    k = 10;
    
    rand_triplets = zeros(numTrips,3);
    perItem = floor(numTrips/n)+1;
    [~, sortInd] = sort(DD, 2, 'ascend');
    for i=1:n
        ind1=i;
        for j=1:perItem
            ind2 = sortInd(i,randi(k-1)+1);
            ind3 = sortInd(i,floor(n/2) + randi(floor(n/2)));
            rand_triplets((i-1)*perItem + j,:)=[ind1;ind2;ind3];
            
        end
        
    end
    rand_triplets(rand_triplets(:,1)==rand_triplets(:,2),:)=[];
    extraNum = size(rand_triplets,1)-numTrips;
    if (extraNum>0)
        rand_triplets(randperm(extraNum),:)=[];
    end
    
    
    elseif mode==4 % kmeans++ initial landmark setting
rand_triplets = [];
    numPivots = floor(sqrt(2*numTrips/n) + .5)+1;
    
    pivots = [];
    while length(pivots) < numPivots
       possible = setdiff(1:n,pivots);
       dists = DD(pivots,possible);
       distn = (sum(dists,1)/sum(sum(dists,1)))*10*n;
       
       pv = 1./exp(-distn);        
       pv= pv/sum(pv);
       newP = discreternd(pv,1);
       pivots = [pivots,possible(newP)];
    end
%     plot(data(:,1),data(:,2),'b*');
%     hold on
%     plot(data(pivots,1),data(pivots,2),'r*');
%     pause;
%     pivots = randperm(n,numPivots);
    for i=1:numPivots
        p1 = pivots(i);
        for j=i+1:numPivots
            p2 = pivots(j);
            
            ind1 = double(DD(p1,:) < DD(p2,:))';
            ind2 = double(DD(p1,:) >= DD(p2,:))';
            
            
            trips = [(1:n)' ind1*p1+ind2*p2 ind1*p2+ind2*p1];
            rand_triplets = [rand_triplets;trips];
        end
    end
    
    rand_triplets(rand_triplets(:,1)==rand_triplets(:,2),:)=[];
    
    extraNum = size(rand_triplets,1)-numTrips;
    if (extraNum>0)
        rand_triplets(randperm(extraNum),:)=[];
    end
    length(rand_triplets)/(numTrips)
        

end


end


