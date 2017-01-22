function udenoised = NLMeans_integralimages(v,f,t,h)

v=double(v);
[nr,nc]      = size(v);
u            = zeros(nr,nc); 
Z            = u;

vpaddedf = padarray(v,[f,f],'symmetric','both');
vpaddedt = padarray(v,[t,t],'symmetric','both');

% Boucle
for dx = -t:t
    for dy = -t:t
        if dx ~= 0 || dy ~= 0
        sd = integralImgSqDiff(vpaddedf,dx,dy); 
        SqDist = sd(f+1:end-f,f+1:end-f)+sd(1:end-2*f,1:end-2*f)- sd(1:end-2*f,f+1:end-f)-sd(f+1:end-f,1:end-2*f);
        w  = exp(-SqDist/((2*f+1)^2*(h^2)));
        vs = vpaddedt((t+1+dx):(t+dx+nr),(t+1+dy):(t+dy+nc));
        u  = u+w.*vs;
        Z  = Z+w;
        end
    end
end
udenoised = u./Z;

function squarediff = integralImgSqDiff(v,dx,dy)
t = img2DShift(v,dx,dy);
diff = (v-t).^2;
squarediff = cumsum(cumsum(diff,1),2);

function vt = img2DShift(v,dx,dy)
vt = zeros(size(v));
type = (dx>0)*2+(dy>0);
switch type
    case 0  
        vt(-dx+1:end,-dy+1:end) = v(1:end+dx,1:end+dy);
    case 1 
        vt(-dx+1:end,1:end-dy) = v(1:end+dx,dy+1:end);
    case 2 
        vt(1:end-dx,-dy+1:end) = v(dx+1:end,1:end+dy);
    case 3 
        vt(1:end-dx,1:end-dy) = v(dx+1:end,dy+1:end);
end