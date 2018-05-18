function [gc scale] = adaptive_gridness(ac,useScale)
    
    center = [size(ac)./2]+0.5;
%     count = 0;
%     for i = -0.0:0.1:0.9
%         count = count+1;
%         [lm(:,:,count) d2c pc] = getPatches(ac,0,[],i);
%     end
%     [lm d2c pc] = getPatches(ac,0,[],0.3);
%     peaks = pc(2:7,:)- repmat(center,[6 1]);
%     [a b] = min(sum(peaks.^2,2));
%     t = cart2pol(peaks(b,1),peaks(b,2));
% %     params = fit_ellipse(peaks(:,1),peaks(:,2));
%     ac = imrotate(ac,rad2deg(t),'crop');
%     [lm d2c pc] = getPatches(ac,0,[],0.2);
%     peaks = pc(2:7,:)- repmat(center,[6 1]);
%     a = nanmean(abs(peaks(1:2,1)));
%     b = nanmean(abs(peaks(3:end,2)));
%     ac = imresize(ac,[size(ac).*[1 b./a]]);
%     ac(ac==0) = nan;
%     ac = imresize(new_ac,[size(new_ac).*[1 params.long_axis./params.short_axis]]);
    
    if nargin <2
        [lm d2c pc] = getPatches(ac,0,[],0.3);
        ac(lm==1) = nan;
        scale = mean(d2c(2:min(7,length(d2c))));
    else
        scale = useScale;
    end
    center = [size(ac)./2]+0.5;
    [x y] = meshgrid(1:length(ac(:,1)),1:length(ac(1,:)));
    d2c = sqrt((x-center(1)).^2+(y-center(2)).^2);
%     count = 0;
%     for i = ceil(scale.*0.5)+1:min(size(ac))
%         count = count+1;
%         mask = d2c>(scale.*0.5)&d2c<i;
%         gc(count) = gridness(maskAndCrop(ac,mask));
%     end
%     gc = nanmax(gc);
    if isnan(scale)
        gc = gridness(ac);
    else
        mask = d2c>(scale.*0.5)&d2c<scale.*1.5;
        gc = gridness(maskAndCrop(ac,mask));
    end
end