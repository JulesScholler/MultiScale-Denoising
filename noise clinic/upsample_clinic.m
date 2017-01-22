function u=upsample_clinic(v,plot)
%
% This function computes the 4 subsampled version of the input image
%
% Input:    v: 4 images that will be upsampled in 1
%           plot: 'on' or 'off' to display result
% Output:   u:  upsampled image
%
% Jules Scholler - Nov. 2016

[h,w]=size(v{1});
u=zeros(2*h,2*w);

for i=0:2*h-1
    for j=0:2*w-1
        p1=floor(i/2);
        p2=floor((i-1)/2);
        q1=floor(j/2);
        q2=floor((j-1)/2);
        if i==0 && j==0
            u(i+1,j+1)=v{1}(p1+1,q1+1);
        elseif i==0
            u(i+1,j+1)=1/2*(v{1}(p1+1,q1+1)+v{2}(p1+1,q2+1));
        elseif j==0
            u(i+1,j+1)=1/2*(v{1}(p1+1,q1+1)+v{3}(p2+1,q1+1));
        else
            u(i+1,j+1)=1/4*(v{1}(p1+1,q1+1)+v{2}(p1+1,q2+1)+v{3}(p2+1,q1+1)+v{4}(p2+1,q2+1));
        end
    end
end

% Plot option
if nargin>1 && strcmp(plot,'on')
    figure
    imshow(uint8(u))
end

