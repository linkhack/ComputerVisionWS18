function indicator = assignToCenter(data,centers)
%ASSIGNTOCENTER assigns each data point to the center which is nearest
%   Assigns datapoint to center with minimal distance
k = size(centers,1); %nr of clusters = nr of centers

%basis for replacing index = index of cluster to indicator vector
basis = eye(k);

%calculate distance squared from center
%for each center calculate norm(data-center)
for i=1:k
    distanceFromCenter = data-centers(i,:);
    normMatrix(:,i) = sum(distanceFromCenter.^2,2); %norm squared -> no sqrt
end

%I is the index of the minimal norm, i.e. index of cluster
[minValue, I] = min(normMatrix,[],2);
indicator = basis(I,:); %use basis to convert index to indicator

%if a cluster has 0 members, i.e. no data point gets assigned to a center,
%we cant calculate the mean of this cluster, there for we chose for each
%empty cluster a random data point.

memberNumber = sum(indicator); %data points in each clusters
emptyClusters = memberNumber==0; %indicator of empty clusters
if (sum(emptyClusters)>0)
    randomIndexes = randperm(size(data,1),sum(emptyClusters)); %index of random datapoint
    sum(emptyClusters) + " empty clusters found"
    %assign random datapoint to cluster 
    k=1;
    for j = find(emptyClusters)
        indicator(randomIndexes(k),:) = basis(j,:);
        k=k+1;
    end
end