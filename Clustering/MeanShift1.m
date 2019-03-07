% Mean-Shift function
function [Xc] = MeanShift1(X, KFun)
[n , p] = size(X);
h = 50;     % Window Size
Xc = zeros(n,p);

for guess = 1 : n
    Xc(guess,:) = X(guess,:);    
    sum1 = 0;
    sum2 = 0;
    
for itr = 1 : 10000
for i = 1 : n
    KFval = feval(KFun,(X(i,:)-Xc(guess,:)), h);
    if (KFval ~= 0)
        sum1 = sum1 + KFval.*X(i,:);
        sum2 = sum2 + KFval;
    end
end

MS = sum1 / sum2;
if(norm(Xc(guess,:)-MS) < 0.1)
    break;
end
Xc(guess,:) = MS;
end
end