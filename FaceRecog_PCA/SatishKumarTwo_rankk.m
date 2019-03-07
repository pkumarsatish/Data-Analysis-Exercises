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

%% Problem 02
M1 = M;
A = train;
cd ../../..
%EV = PCA1(A);

%% PCA Task
PHI = (1/M1).*sum(A);
for i = 1:M1
    A(i,:) = A(i,:)-PHI;
end

EA = A*A';  % M1 x M1
[V,D] = eig(EA);

correctI(M,6) = zeros; % 1 if matches, 0 else, for each test data
for MaxE = 5;
EV = A'*V(:,M1:-1:(M1-MaxE+1));
EV = EV';   % EigenSpace, k x N


%% Ploting
for k = 1:MaxE
for rowI = 1:112    %% Vector to matrix form
    temp1(rowI,:) = EV(k,(92*(rowI-1))+1 : (92*rowI));
end
%image(temp1/7)
%filename = strcat('EF',num2str(k),'.jpg');
%saveas(gcf,filename);
end

%% Normalize EV
for k = 1:MaxE
    EV(k,:) = EV(k,:)/norm(EV(k,:));
end


%% Face Recognition
%eps = ;% Threshold Value
Xr = A*EV'; % M1 x k
Er = zeros(M1,1);

for exp = 1:M

GammaO = test(exp,:);
PHIS = GammaO - PHI;
GammaR = PHIS*EV';

for i = 1:M1
    Er(i) = norm(GammaR - Xr(i,:));
end

[Val, Idx] = sort(Er);

%% Rank - k experiment
%data(6,1)=zeros;
for rk = 1:6
for k = 1:rk
if (map1(Idx(k),1) == map2(exp,1))
    correctI(exp,rk) = 1;
end
end
% %% plot compare data
% for rowI = 1:112    %% Vector to matrix form
%     temp1(rowI,:) = GammaO(1,(92*(rowI-1))+1 : (92*rowI));
% end
% image(temp1/5)
% 
% for rowI = 1:112    %% Vector to matrix form
%     temp1(rowI,:) = A(minI,(92*(rowI-1))+1 : (92*rowI));
% end
% image(temp1/5)
end
end
end
data = sum(correctI)/M;
plot(data)