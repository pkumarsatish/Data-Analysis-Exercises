%% Assignment 02, SE294
% Satish Kumar, MTech - 11052, SERC
% Script File - Mean Shift Clustering
clear all;
close all;
clc;

disttype = 2;

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

% Mean Shift
Xc = MeanShift1(X, 'KFun');
[dim1, dim2] = size(Xc);

cidx = zeros(dim1,1);
C(1,:) = Xc(1,:);
label = 1;
cidx(1) = 1;
for i1 = 2:dim1
	for i2 = 1:label
        if (norm(Xc(i1,:) - C(i2,:)) < 15)  % Thresold
            C(i2,:) = (Xc(i1,:) + C(i2, :))/2;
            Xc(i1,1) = label;
            cidx(i1) = label;
            break;
        end            
    end
    if (Xc(i1,1) ~= label)
        label = label + 1;
        C(label, :) = Xc(i1,:);
        cidx(i1) = label;
    end
end
C

%Centre Matching, rowI for ground truth
M(7,7) = zeros;
for i = 1:7
    for j = 1:7
        M(i,j) = norm(ctrsT(i,:)-C(j,:),2);
    end
end
[Matching,Cost] = Hungarian(M);
[dummy,colI] = max(Matching);
ctrsM = zeros(7,3);
for i = 1:7
    ctrsM(colI(i),:) = C(i,:); 
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