function v = snr(x,y)
% snr - signal to noise ratio
%
%   v = snr(x,y);
%
% v = 20*log10( norm(x(:)) / norm(x(:)-y(:)) )
%
%   x is the original clean signal (reference).
%   y is the denoised signal.
%
% Jules Scholler - Nov. 2016

x=double(x);
y=double(y);
v = 20*log10(norm(x(:))/norm(x(:)-y(:)));