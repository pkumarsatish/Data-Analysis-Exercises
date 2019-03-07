clear all;
clc;
%Face Recognition
N = 112*92;
M = 40*5;
train(M,N) = zeros; % M = no. of faces, N = dim of feature vector
map1(M,2) = zeros;
test(M,N) = zeros;
map2(M,2) = zeros;
temp2 = zeros(1,N);
cd 'ORL\s10'

%% Loading the data
for i = 1:40    %Each 40 directory/subjects
    dir = strcat('../','s',num2str(i));
    cd(dir)
    i1 = randperm(10);   
    for j = 1:5 % Choose 5 random image as training
        temp1 = imread(strcat(num2str(i1(j)),'.pgm'));
        for rowI = 1:112
        temp2(1,(92*(rowI-1))+1 : (92*rowI)) = temp1(rowI,:);
        end
        train((5*(i-1)+j),:) = temp2;
        map1((5*(i-1)+j),1) = i;
        map1((5*(i-1)+j),2) = i1(j);
    end
    
    for j = 1:5 % Remaining 5 random image as test
        temp1 = imread(strcat(num2str(i1(5+j)),'.pgm'));
        for rowI = 1:112
        temp2(1,(92*(rowI-1))+1 : (92*rowI)) = temp1(rowI,:);
        end
        test((5*(i-1)+j),:) = temp2;
        map2((5*(i-1)+j),1) = i;
        map2((5*(i-1)+j),2) = i1(5+j);
    end
end

%% Problem 01
M1 = 80;
A = zeros(M1,N);
j = 1;
for i = 1:40
    A(j,:) = train(5*(i-1)+1,:);
    j=j+1;
    A(j,:) = train(5*(i-1)+2,:);
    j=j+1;
end
cd ../../..
%EV = PCA1(A);

%% PCA Task
PHI = (1/M1).*sum(A);
for i = 1:M1
    A(i,:) = A(i,:)-PHI;
end

EA = A*A';  % M1 x M1
[V,D] = eig(EA);

MaxE = 16;
EV = A'*V(:,M1:-1:(M1-MaxE+1));
EV = EV';   % EigenSpace, k x N


%% Ploting
figure
for k = 1:MaxE
for rowI = 1:112    %% Vector to matrix form
    temp1(rowI,:) = EV(k,(92*(rowI-1))+1 : (92*rowI));
end
subplot(4,4,k);
I = mat2gray(temp1);
imshow(I);
End