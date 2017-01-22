function [v]=subsample_burger(u,ns,plot,interp_method)

v{1}=u;
for i=1:ns
    v{i+1}=imresize(v{i},1/2,interp_method);
end

if nargin>2 && strcmp(plot,'on')
    figure
    for i=1:ns+1
        subplot(1,ns+1,i),imshow(v{i})
    end
end