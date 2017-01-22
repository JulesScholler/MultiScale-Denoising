% SCRIPT for denoising based on THE NOISE CLINIC : A UNIVERSAL BLIND DENOISING ALGORITHM
% M. Lebrun, J.M. Morel and M. Colom
%
% Jules Scholler - Nov. 2016

% reset matlab
clear;
addpath('/Users/jules/Desktop/MVA/Introduction imagerie numerique/Projet/Matlab/im')

% Set the different parameters
im    = 'simpson.png';     % filepath image to be loaded
sigma = 0.55;               % std for the gaussian noise
% Parameters for single-scale NL-means
w     = 10;                  % patch width
R     = 15;                 % research zone width
h2    = 40;                % similarity parameter
% Parameters for multi-scale NL-means
ns    = 2;                  % Number of scales
if ns==2
    wms   = 3; 
    Rms   = 6; 
    h2ms  = 12;
elseif ns==1
    wms   = 7;
    Rms   = 10;
    h2ms  = 20;
end

% load the image
imrgb = imread(im);
if ndims(imrgb)==3
    imgray = rgb2gray(imrgb);
elseif ismatrix(imrgb)
    imgray=imrgb;
end

% gaussian noise
imgauss   = imnoise(imgray,'gaussian',0,sigma^2);

% compute re-scaled images
x=subsample_clinic(imgauss,'off');
if ns==1
    for i=1:4
        x{i}=NLMeans_integralimages(x{i},wms,Rms,h2ms);
    end
    z=upsample_clinic(x,'off');
elseif ns==2
    for i=1:4
        x{i}=NLMeans_integralimages(x{i},wms,Rms,h2ms);
        xx{i}=subsample_clinic(x{i},'off');
        for j=1:4
            xx{1,i}{j}=NLMeans_integralimages(xx{1,i}{j},wms,Rms,h2ms);
        end
        zz{i}=upsample_clinic(xx{1,i},'off');
    end
    z=upsample_clinic(zz,'off');
end
y=NLMeans_integralimages(imgauss,w,R,h2);
figure
subplot(2,2,1),imshow(imgray,[]),title(sprintf('Original image'))
subplot(2,2,2),imshow(imgauss,[]),title(sprintf('Noisy image- SNR = %0.2f',snr(rescale(imgray),rescale(imgauss))))
subplot(2,2,3),imshow(y,[]),title(sprintf('NL-Denoised image- SNR = %0.2f',snr(rescale(imgray),rescale(y))))
subplot(2,2,4),imshow(z,[]),title(sprintf('MS-NL-Denoised image- SNR = %0.2f',snr(rescale(imgray),rescale(z))))
