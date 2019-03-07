%% Q3, BoW 
clear all;
clc;
close all;

%% Read Image data in SHIFT vectores
cd III.CompactRepresentation
RawData = load('features.mat');
NumImg = 274;
NumSHIFT = zeros(NumImg,1);

RawLabels = load('labels.mat');
class = RawLabels.labels;

RawQLabels = load('query_ind.mat');
QIdx = RawQLabels.query_ind;

X = RawData.features{1,1};
[dummy, NumSHIFT(1)] = size(X);

for i = 2:NumImg
    Xi = RawData.features{i,1};
    [dummy, NumSHIFT(i)] = size(Xi);
    X = [X Xi];
end
% dim1 = 128, dim2 = Total no. of NumSHIFT
[FVDim, TotNumSHIFT] = size(X);

cd ..

%% BoW
% codebook of size 10000
K1 = 64; % code size
X1 = zeros(NumImg,K1);  % BoW Representation for each Given Image

%[cidx1, ctrs1] = kmeans(X', K1);
ctrs2 = load('q3_64_ctrs.mat');
ctrs1 = ctrs2.ctrs2;

cidx2 = load('q3_64_cidx.mat');
cidx1 = cidx2.cidx2;

% ctrs1 = fvecs_read ('clust_flickr60_k10000.fvecs');
% cidx1 = zeros(TotNumSHIFT,1);
% for i = 1 : TotNumSHIFT
%     for j = 1 : K1
%         temp(j) = norm((X(:,i))' - ctrs1(j,:));
%     end
%     [dummy, cidx1(i)] = min(temp);
% end


count1 = zeros(K1,1);
for i = 1:K1
    count1(i) = sum(cidx1(:) == i);
end

Xpos = 0;
% Traverse each Image and each patch to form BoW's Histogram 
for i1 = 1:NumImg
    for i2 = 1:NumSHIFT(i1)
        Xpos = Xpos + 1;    % Position of (i1,i2) in X
        i3 = cidx1(Xpos);   % Cluster it belongs to!
        X1(i1,i3) = X1(i1,i3) + 1;
    end
end

% For quary image k
mAP = 0;
for NumQr = 1 : 100;   % Quairies 100
    k = QIdx(NumQr);   % Index of image in Quairy
    Q = X1(k,:);  % Image compressed
    Er = zeros(NumImg, 1);
    for i1 = 1:NumImg
        Er(i1) = norm(Q - X1(i1,:));
    end
 
[Er, ErI] = sort(Er);

%% mAP Accuracy;
MyClass = class(k); % Class of the image quairy
if (NumQr==100)
    MyNumStud = 275 - QIdx(MyClass);
else
    MyNumStud = QIdx(MyClass+1) - QIdx(MyClass);
end

match = zeros(NumImg, 1);
for i = 1 : NumImg
    if(class(ErI(i)) == MyClass)
        match(i) = 1;
    end
end

AveP = 0;
for k = 1:NumImg
    NumMatch = sum(match(1:k));
    P = NumMatch / k;
    r = NumMatch / MyNumStud;
    AveP = AveP + P*match(k);
end

AveP = AveP / MyNumStud;
mAP = mAP + AveP;
end
mAP = mAP/100