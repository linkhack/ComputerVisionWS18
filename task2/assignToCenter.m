function indicator = assignToCenter(data,centers)
%ASSIGNTOCENTER Summary of this function goes here
%   Detailed explanation goes here
k = size(centers,1);
basis = eye(k);
for i=1:k
    distanceFromCenter = data-centers(i,:);
    normMatrix(:,i) = sum(distanceFromCenter.^2,2);
end
[minValue, I] = min(normMatrix,[],2);
indicator = basis(I,:);
memberNumber = sum(indicator);
emptyClusters = memberNumber==0;
if (sum(emptyClusters)>0)
    randomIndexes = randperm(size(data,1),sum(emptyClusters));
    k=1;
    for j = find(emptyClusters)
        indicator(randomIndexes(k),:) = basis(j,:);
        k=k+1;
    end
end
%indicator = minValue == normMatrix;

