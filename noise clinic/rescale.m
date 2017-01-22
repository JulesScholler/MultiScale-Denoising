function y = rescale(x,a,b)
%   This function rescale image x in [a,b]
%   
%   Inputs:  x: images to be rescaled
%            a: lower boundary
%            b: upper boundary
%
%   Outputs: y: rescaled image
%
%   Jules Scholler - Nov. 2016

if nargin<2
    a = 0;
end
if nargin<3
    b = 1;
end

if iscell(x)
    for i=1:length(x)
        y{i} = rescale(x{i},a,b);
    end
    return;
end

m = min(x(:));
M = max(x(:));

if M-m<eps
    y = x;
else
    y = double(b-a) * double((x-m)/(M-m)) + double(a);
end


