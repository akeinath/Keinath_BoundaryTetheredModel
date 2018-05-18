function plotLinMorphedMaps(m,outP)
%     ms = [];
%     for i = 1:length(m(:,1))
%         ms{i} = permute(cat(3,m{i,:}),[1 3 4 2]);
%     end    
    
    for k = 1:2
        tmp = m{end}(:,:,k);
        [a b] = max(tmp);
        tmp = bsxfun(@rdivide,tmp,a);
        inactive = all(isnan(tmp));
        b(inactive) = max(b)+1;
        if k==1
            [blah inds] = sort(b,'descend');
        else
            [blah inds] = sort(b,'ascend');
        end
        peak = zeros(1,length(m{1}(1,:,1)));
        for i = 1:length(m(1,:))
            [m1 m2] = max(m{i}(:,:,k));
            peak = max(peak,m1);
        end
        
        for j = 1:length(m(1,:))
            tmp = m{j}(:,:,k);
%             a = max(tmp);
            tmp = bsxfun(@rdivide,tmp,peak);
            tmp(isnan(tmp)) = 0;
            m{j}(:,:,k) = tmp(:,inds);
        end
    end
    
    ms = m;
    ref = ms{end};
    
    tmp = cellfun(@size,ms,'uniformoutput',false);
    tmp = cat(1,tmp{:});
    scale = tmp(:,1)./length(ref(:,1,1));
    scale = scale.*(length(scale)./sum(scale));
    
    allCorrs = [];
    colormap('jet')
    
    figure(1)
    set(gcf,'position',[50 50 950 600])
    useNext = [];
    for i = length(m(1,:)):-1:1
        
%         subplot(2,length(m(:,1)),length(m(:,1))-i+1)
        axes('position',[.05 .55  1./(length(scale)+1) .40])
        
        tmp = (ms{i}(:,:,1));
%         imagesc(tmp')
        plot(bsxfun(@plus,tmp.*20,[1:64].*4),'color','k','linewidth',1)
        set(gca,'ydir','normal')
        
        useX = get(gca,'position');
        if isempty(useNext)
            useNext = useX(1);
        end
        set(gca,'position',[useNext useX(2) useX(3).*scale(i) useX(4)])        
        axis off
        
%         subplot(2,length(m(:,1)),length(m(:,1))+length(m(:,1))-i+1)
        axes('position',[.05 .05  0.8./(length(scale)) .40])
        tmp = fliplr(ms{i}(:,:,2));
%         imagesc(tmp')
        plot(bsxfun(@plus,tmp.*20,[1:64].*4),'color','k','linewidth',1)
        set(gca,'ydir','normal')
        useX = get(gca,'position');
        set(gca,'position',[useNext useX(2) useX(3).*scale(i) useX(4)])
        useX = get(gca,'position');
        useNext = useX(:,1)+useX(:,3)+0.025;
        axis off
    end
    saveFig(gcf,['Plots/' outP '/LinRateMaps_OrderedByField'],'tiff');
    saveFig(gcf,['Plots/' outP '/EPS/LinRateMaps_OrderedByField'],'eps');
end





















