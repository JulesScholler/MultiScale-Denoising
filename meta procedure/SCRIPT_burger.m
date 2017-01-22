% SCRIPT for denoising based on Improving Denoising Algorithms via a Multi-scale Meta-procedure
% Harold Christopher Burger and Stefan Harmeling
%
% Jules Scholler - Nov. 2016

% reset matlab
clear; close all;
addpath('/Users/jules/Desktop/MVA/Introduction imagerie numerique/Projet/Matlab/im')

% set the different parameters
im    = 'simpson.png';     % filepath image to be loaded
sigma = 0.55;               % std for the gaussian noise
% Parameters for single-scale NL-means
w     = 10;                  % patch width
R     = 15;                 % research zone width
h2    = 40;                % similarity parameter
% Parameters for multi-scale NL-means
ns    = 3;                  % Number of scales
if ns>=2
    wms   = 5; %2
    Rms   = 10; %6
    h2ms  = 20; %15
elseif ns==1
    wms   = 7;
    Rms   = 10;
    h2ms  = 20;
end
method =3;
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
x=subsample_burger(imgauss,ns,'off',interp_method);
NLy=NLMeans_integralimages(x{1},w,R,h2);

switch method
    case 1 % method presented in the paper
        % denoise image for each scale
        for i=1:ns+1
            for RGB=1:1
                y{i}(:,:,RGB)=NLMeans_integralimages(x{i}(:,:,RGB),wms,Rms,h2ms);
            end
        end
        % Denoise through scales
        for i=ns:-1:1
            l{i}=imresize(y{i},1/2,interp_method);
            h{i}=y{i}-imresize(l{i},size(y{i}),interp_method);
            z{i}=h{i}+imresize(y{i+1},size(h{i}),interp_method);
            figure(3)
            subplot(1*(ns+1),3,1+3*(i-1)),imagesc(l{i}),colormap gray, axis image
            subplot(1*(ns+1),3,2+3*(i-1)),imagesc(h{i}),colormap gray, axis image
            subplot(1*(ns+1),3,3+3*(i-1)),imagesc(z{i}),colormap gray, axis image
        end
        % display result
        figure(1) % details
        for i=1:ns+1
            subplot(3,ns+1,i),imshow(x{i},[]),title(sprintf('Noisy image, scale %d',i-1))
            subplot(3,ns+1,i+ns+1),imshow(uint8(y{i}),[]),title(sprintf('NL-means, scale %d',i-1))
            subplot(3,ns+1,i+2*(ns+1)),imshow(double(x{i})-y{i},[]),title(sprintf('Differences, scale %d',i-1))
        end
        figure(2) % results
        subplot(2,2,1),imshow(imgray,[]),title('Original image')
        subplot(2,2,2),imshow(imgauss,[]),title(sprintf('Noisy image - %0.3f dB',snr(imgray,imgauss)))
        subplot(2,2,3),imshow(NLy,[]),title(sprintf('NL-Denoised image - %0.3f dB',snr(imgray,rescale(NLy,min(min(imgray)),max(max(imgray))))))
        subplot(2,2,4),imshow(z{1},[]),title(sprintf('MS-NL-Denoised image - %0.3f dB',snr(imgray,rescale(round(z{1}),min(min(imgray)),max(max(imgray))))))
    case 2 % Modified method with J. Delon comments
        z{ns+1}=x{ns+1};
        y{1}=NLMeans_integralimages(x{1},wms,Rms,h2ms);
        for i=ns:-1:1
            y{i+1}=NLMeans_integralimages(z{i+1},w,R,h2);
            z{i}=0.5*double(x{i})+0.5*imresize(y{i+1},size(x{i}),'lanczos3');
        end
        % display result
        figure(1)
        for i=1:ns+1
            subplot(3,ns+1,i),imshow(x{i},[]),title(sprintf('Noisy image, scale %d',i-1))
            subplot(3,ns+1,i+ns+1),imshow(uint8(z{i}),[]),title(sprintf('MS-NL-means, scale %d',i-1))
            subplot(3,ns+1,i+2*(ns+1)),imshow(double(x{i})-double(z{i}),[]),title(sprintf('Differences, scale %d',i-1))
        end
        figure(2)
        subplot(2,2,1),imshow(imgray,[]),title('Original image')
        subplot(2,2,2),imshow(imgauss,[]),title(sprintf('Noisy image - %0.3f dB',snr(imgray,imgauss)))
        subplot(2,2,3),imshow(y{1},[]),title(sprintf('NL-Denoised image - %0.3f dB',snr(imgray,y{1})))
        subplot(2,2,4),imshow(z{1},[]),title(sprintf('MS-ML-Denoised image - %0.3f dB',snr(imgray,z{1})))
    case 3 % Hard thresholding added on method 1
        % denoise image for each scale
        for i=1:ns+1
            for RGB=1:1
                y{i}(:,:,RGB)=NLMeans_integralimages(x{i}(:,:,RGB),wms,Rms,h2ms);
            end
        end
        % Denoise through scales
        for i=ns:-1:1
            l{i}=imresize(y{i},1/2,interp_method);
            h{i}=y{i}-imresize(l{i},size(y{i}),interp_method);
            h{i}=abs(h{i});
            tmp=sort(h{i}(:));
            lambda_min=tmp(round(length(tmp)*0.90));
            h{i}(abs(h{i})<lambda_min)=0;
            z{i}=h{i}+imresize(y{i+1},size(h{i}),interp_method);
            figure(3)
            subplot(1*(ns+1),3,1+3*(i-1)),imagesc(h{i}),colormap gray, axis image,title(sprintf('h_{%d}',i)),set(gca,'XTickLabel','','YTickLabel','')
            subplot(1*(ns+1),3,2+3*(i-1)),imagesc(imresize(y{i+1},size(h{i}),interp_method)),colormap gray, axis image,title(sprintf('u(y_{%d})',i+1)),set(gca,'XTickLabel','','YTickLabel','')
            subplot(1*(ns+1),3,3+3*(i-1)),imagesc(y{i}),colormap gray, axis image,title(sprintf('z_{%d}',i)),set(gca,'XTickLabel','','YTickLabel','')
        end
        tightfig;
        % display result
        figure(1) % details
        for i=1:ns+1
            subplot(3,ns+1,i),imshow(x{i},[]),title(sprintf('Noisy image, scale %d',i-1))
            subplot(3,ns+1,i+ns+1),imshow(uint8(y{i}),[]),title(sprintf('NL-means, scale %d',i-1))
            subplot(3,ns+1,i+2*(ns+1)),imshow(double(x{i})-y{i},[]),title(sprintf('Differences, scale %d',i-1))
        end
        figure(2) % results
        subplot(2,2,1),imshow(imgray,[]),title('Original image')
        subplot(2,2,2),imshow(imgauss,[]),title(sprintf('Noisy image'))
        subplot(2,2,3),imshow(NLy,[]),title(sprintf('NL-Denoised image'))
        subplot(2,2,4),imshow(y{1},[]),title(sprintf('MS-NL-Denoised image'))
end