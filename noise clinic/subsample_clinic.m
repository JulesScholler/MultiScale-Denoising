function v=subsample_clinic(u,plot)
%
% This function computes the 4 sub-sampled version of the input image
%
% Input:    u:  image that will be subsampled
%           plot: 'on' or 'off' to display result
% Output:   v:  structure containing the 4 subsampled version of the input
%               image
%
% Jules Scholler - Nov. 2016

u=double(u);
[h,w]=size(u);

% If size is odd then we add a column/row
if mod(w,2)==1
    u=[u(:,:);u(end,:)];
end
if mod(h,2)==1
    u=[u(:,:) u(:,end)];
end

% Sub-sampling loop
for i=0:h/2-1
    for j=0:w/2-1
        v{1}(i+1,j+1)=1/4*(u(2*i+1, 2*j+1) + u(2*i+1 + 1, 2*j+1) + u(2*i+1, 2*j+1 + 1) + u(2*i+1 + 1, 2*j+1 + 1));
        if j==w/2-1
            v{2}(i+1,j+1)=1/2*(u(2*i+1, 2*j+1 + 1) + u(2*i+1 + 1, 2*j+1 + 1));
        else
            v{2}(i+1,j+1)=1/4*(u(2*i+1, 2*j+1 + 1) + u(2*i+1 + 1, 2*j+1 + 1) + u(2*i+1, 2*j+1 + 2) + u(2*i+1 + 1, 2*j+1 + 2));
        end
        if i==h/2-1
            v{3}(i+1,j+1)=1/2*(u(2*i+1 + 1, 2*j+1) + u(2*i+1 + 1, 2*j+1 + 1));
        else
            v{3}(i+1,j+1)=1/4*(u(2*i+1 + 1, 2*j+1) + u(2*i+1 + 2, 2*j+1) + u(2*i+1 + 1, 2*j+1 + 1) + u(2*i+1 + 2, 2*j+1 + 1));
        end
        if i==h/2-1 && j==w/2-1
            v{4}(i+1,j+1)=u(2*i+1+1,2*j+1+1);
        elseif i==h/2-1
            v{4}(i+1,j+1)=1/2*(u(2*i+1 + 1, 2*j+1 + 1) + u(2*i+1 + 1, 2*j+1 + 2));
        elseif j==w/2-1
            v{4}(i+1,j+1)=1/2*(u(2*i+1 + 1, 2*j+1 + 1) + u(2*i+1 + 2, 2*j+1 + 1));
        else
            v{4}(i+1,j+1)=1/4*(u(2*i+1 + 1, 2*j+1 + 1) + u(2*i+1 + 2, 2*j+1 + 1) + u(2*i+1 + 1, 2*j+1 + 2) + u(2*i+1 + 2, 2*j+1 + 2));
        end
    end
end

% Plot option
if nargin>1 && strcmp(plot,'on')
    figure
    for i=1:4
        subplot(2,2,i),imshow(uint8(v{i})),colormap gray, axis image
    end
end

end