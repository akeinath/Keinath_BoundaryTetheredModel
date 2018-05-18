function pvLinCorr(m,outP)
%     ms = [];
%     for i = 1:length(m(:,1))
%         ms{i} = permute(cat(3,m{i,:}),[1 3 4 2]);
%     end
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
        
        tmp = ms{i}(:,:,1);
        imagesc(corr(tmp',ref(:,:,1)')')
        set(gca,'ydir','normal')
        blah = corr(tmp',ref(:,:,1)')';
        allCorrs{i}(:,:,1) = blah;
        [a b] = max(blah);
        hold on
        plot(1:length(b),b,'color','w','linewidth',3)
        
        useX = get(gca,'position');
        if isempty(useNext)
            useNext = useX(1);
        end
        set(gca,'position',[useNext useX(2) useX(3).*scale(i) useX(4)])        
        axis off
        
%         subplot(2,length(m(:,1)),length(m(:,1))+length(m(:,1))-i+1)
        axes('position',[.05 .05  0.8./(length(scale)) .40])
        tmp = (ms{i}(:,:,2));
        imagesc(corr(tmp',(ref(:,:,2))')')
        set(gca,'ydir','normal')
        blah = corr(tmp',ref(:,:,2)')';
        allCorrs{i}(:,:,2) = blah;
        [a b] = max(blah);
        hold on
        plot(1:length(b),b,'color','w','linewidth',3)
        
        
        useX = get(gca,'position');
        set(gca,'position',[useNext useX(2) useX(3).*scale(i) useX(4)])
        useX = get(gca,'position');
        useNext = useX(:,1)+useX(:,3)+0.025;
        axis off
    end
    saveFig(gcf,['Plots/' outP '/pvLinearTrackCrosscorrelation'],'tiff');
    saveFig(gcf,['Plots/' outP '/EPS/pvLinearTrackCrosscorrelation'],'eps');
end





















