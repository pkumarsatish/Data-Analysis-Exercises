%% Q3, VLAD
clear all;
clc;
close all;


%% Read Image data in SHIFT vectores
NumImg = 274;

cd III.CompactRepresentation
RawData = load('features.mat');
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
%% VLAD
% codebook of size 64

K2 = 64; % code size
%[cidx2, ctrs2] = kmeans(X', K2);
ctrs2 = load('q3_64_ctrs.mat');
ctrs2 = ctrs2.ctrs2;

cidx2 = load('q3_64_cidx.mat');
cidx2 = cidx2.cidx2;

D = K2*FVDim;
X2 = zeros(K2, FVDim, NumImg);

Xpos = 0;
for i1 = 1:NumImg
    for i2 = 1:NumSHIFT(i1)
            Xpos = Xpos+1;
            i3 = cidx2(Xpos);
            X2(i3,:,i1) = X2(i3,:,i1) + (X(:,Xpos)')-(ctrs2(i3,:));     % i1 - image, i2 = d, i3 = k
    end
    X2(:,:,i1) = X2(:,:,i1) / norm(X2(:,:,i1));
end

% For quary image k
mAP = 0;
for NumQr = 1 : 100;   % Quairies 100
    k = QIdx(NumQr);   % Index of image in Quairy
    Q = X2(:,:,k);  % Image compressed
    Er = zeros(NumImg, 1);
    for i1 = 1:NumImg
        Er(i1) = norm(Q - X2(:,:,i1));
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
    %r = NumMatch / MyNumStud;
    AveP = AveP + P*match(k);
end

AveP = AveP / MyNumStud;
mAP = mAP + AveP;
end
mAP = mAP/100