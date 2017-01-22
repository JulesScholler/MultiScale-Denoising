% reset matlab
clear; close all;
addpath('/Users/jules/Desktop/MVA/Introduction imagerie numerique/Projet/Matlab/im')

% set the different parameters
im    = 'simpson.png';     % filepath image to be loaded
sigma = 0.55;               % std for the gaussian noise
w     = 10;                  % patch width
R     = 15;                 % research zone width
h2    = 40;                % similarity parameter
ns    = 3;
if ns>=2
    wms   = 5; %2
    Rms   = 10; %6
    h2ms  = 20; %15
elseif ns==1
    wms   = 7;
    Rms   = 10;
    h2ms  = 20;
end
interp_method='lanczos3';

% load the image
imrgb = imread(im);
if ndims(imrgb)==3
    imgray = rgb2gray(imrgb);
elseif ismatrix(imrgb)
    imgray=imrgb;
end

% gaussian noise
imgauss   = imnoise(imgray,'gaussian',0,sqrt(sigma));

% compute re-scaled images
x=subsample_burger(imgauss,ns,'off');
NLy=NLMeans_integralimages(x{1},w,R,h2);


% Denoising with pyramid fashion
for i=1:ns+1
    y{i}=NLMeans_integralimages(x{i},wms,Rms,h2ms);
    l{i}=imresize(y{i},1/2,interp_method);
end
for i=ns:-1:1
    h{i}=y{i}-imresize(l{i},2,interp_method);
    z{i}=h{i}+imresize(y{i+1},2,interp_method);
end

% Plot results
subplot(2,2,1),imshow(imgray,[]),title('Original image')
subplot(2,2,2),imshow(imgauss,[]),title(sprintf('Noisy image'))
subplot(2,2,3),imshow(NLy,[]),title(sprintf('NL-Denoised image'))
subplot(2,2,4),imshow(z{1},[]),title(sprintf('MS-NL-Denoised image'))