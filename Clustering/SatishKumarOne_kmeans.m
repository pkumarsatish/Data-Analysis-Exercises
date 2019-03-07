
%% Assignment 02, SE294
% Satish Kumar, MTech - 11052, SERC
% Script File - Kmeans Clustering
clear all;
close all;
clc;

disttype = 2; % Lp Norm

Xmat = load('features.mat');
X = Xmat.features;

% Ground Truth Labels
cidxTmat = load('ground_truth_labels.mat');
cidxT = cidxTmat.labels;
ctrsT(7,3) = zeros;

for i = 0 : 6
    ctrsT(i+1,1) = mean(X(cidxT==i,1));
    ctrsT(i+1,2) = mean(X(cidxT==i,2));
    ctrsT(i+1,3) = mean(X(cidxT==i,3));
end
figure
ctrsT
clr_mp = colormap(hsv(7));
for label = 1:7
scatter3(X(cidxT==label-1,1),X(cidxT==label-1,2),X(cidxT==label-1,3),5,clr_mp(label,:));
hold on
end

% kmeans
[cidx, ctrs] = kmeans1(X, 7, disttype);

% Centre Matching, rowI for ground truth
M(7,7) = zeros;
for i = 1:7
    for j = 1:7
        M(i,j) = norm(ctrsT(i,:)-ctrs(j,:),disttype);
    end
end

[Matching,Cost] = Hungarian(M)
[dummy,colI] = max(Matching);
ctrsM = zeros(7,3);
for i = 1:7
    ctrsM(colI(i),:) = ctrs(i,:); 
end
hold off
figure
ctrsM
clr_mp = colormap(hsv(7));
for label = 1:7
scatter3(X(cidx==label,1),X(cidx==label,2),X(cidx==label,3),5,clr_mp(label,:));
hold on
end

difference = norm(ctrsT-ctrsM,2)