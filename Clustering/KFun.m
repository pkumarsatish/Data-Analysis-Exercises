% Kernal Functions
function [KFval] = KFun(X, h)
% %Kernal Function - Uniform
% if(norm(X) > h)
%     KFval = 0;
% else
%     KFval = 1;
% end

%Normal
KFval = exp(-1/2 * (norm(X/h)^2));

% %Epanechnikov
% a = norm(X);
% if(a < h)
%     KFval = 1 - (a/h)^2;
% else 
%     KFval = 0;
% end