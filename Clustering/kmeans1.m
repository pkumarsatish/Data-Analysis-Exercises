function [cidx, ctrs] = kmeans1(X, k, disttype)
%kmeans1 Perform kmeans Clustering of data
%
% Input:
% X - Unlabled data (n x p), n features each of p dim
% k - No. of clusters
% 
% Output:
% cidx - Index of cluster for each data (n x 1)
% ctrs - Mean position of cluster (k x p)
% 
% Satish Kumar (-11052)
% MTech SERC IISc
% Last Modified: 19.03.2015

[n , p] = size(X);

cidx(n,1) = zeros;
minX = min(X);
maxX = max(X);

[s1,s2,s3,s4,s5] = RandStream.create('mrg32k3a','NumStreams',5);
miu0 = (maxX(1)-minX(1)).*rand(s5,k,p) + minX(1);
ctrs = miu0;

dist(n,k) = zeros;

for itr = 1
    for i = 1 : n
        for j = 1 : k
            %ctrs(j,:) = mean(X(cidx==j,:));
            dist(i,j) = norm(X(i,:) - ctrs(j,:), disttype);
        end
        [temp, cidx(i)] = min(dist(i,:));
    end
end

for itr = 2 : 20
    for i = 1 : n
        for j = 1 : k
            ctrs(j,:) = mean(X(cidx==j,:));
            dist(i,j) = norm(X(i,:) - ctrs(j,:), disttype);
        end
        [temp, cidx(i)] = min(dist(i,:));
    end
end
%total = sum(mean(dist'));