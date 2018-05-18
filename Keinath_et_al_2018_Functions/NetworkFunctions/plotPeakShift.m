function plotPeakShift(d,b)
    dvals = nan(length(b(1,1,:,1)),2);
    for k = 1:length(b(1,1,:,1))
        tmp1 = d(:,:,k,1);
        tmp2 = d(:,:,k,2);
        tmp1(isnan(tmp1)|isnan(tmp2)) = nan;
        tmp2(isnan(tmp1)|isnan(tmp2)) = nan;
%         xc = pvxcorr(tmp1,tmp2,[20 20],20);
%         [a b c] = getPatches(xc,0,[],.3);
%         [a b] = find(xc == nanmax(xc(a==1)));
%         dvals(k,:) = [nanmedian(a)-21 nanmedian(b)-21]; 
        [a1 b1] = find(tmp1 == nanmax(tmp1(:)));
        [a2 b2] = find(tmp2 == nanmax(tmp2(:)));
        dvals(k,:) = [nanmedian(a1)-nanmedian(a2) nanmedian(b1)-nanmedian(b2)];
    end
    
    bvals = nan(length(b(1,1,:,1)),2);
    for k = 1:length(b(1,1,:,1))
        tmp1 = b(:,:,k,2);
        tmp2 = b(:,:,k,4);
        tmp1(isnan(tmp1)|isnan(tmp2)) = nan;
        tmp2(isnan(tmp1)|isnan(tmp2)) = nan;
%         xc = pvxcorr(tmp1,tmp2,[20 20],20);
%         [a b c] = getPatches(xc,0,[],.3);
%         [a b] = find(xc == nanmax(xc(a==1)));
%         dvals(k,:) = [nanmedian(a)-21 nanmedian(b)-21]; 
        
        [a1 b1] = find(tmp1 == nanmax(tmp1(:)));
        [a2 b2] = find(tmp2 == nanmax(tmp2(:)));
        bvals(k,:) = [nanmedian(a1)-nanmedian(a2) nanmedian(b1)-nanmedian(b2)];
    end
    
    forPlot = sort(dvals(:,2)).*2.5;
    figure(1)
    set(gcf,'position',[50 50 500 300])
    subplot(1,2,1)
    plot([ forPlot]',repmat([1:length(forPlot)]',[1 1])','color','k',...
        'marker','o','markersize',3,'markerfacecolor','none','linestyle','none')
    hold on
    plot([0 0],[0 length(forPlot)+1],'color',[.5 .5 .5],'linewidth',1.5,'linestyle','--')
%     plot([61 61],[0 length(forPlot)+1],'color',[.5 .5 .5],'linewidth',1.5,'linestyle','--')
    forPlot = sort(bvals(:,2).*2.5);
    set(gca,'xlim',[-120 120]);
    subplot(1,2,2)
    plot([forPlot]',repmat([1:length(forPlot)]',[1 1])','color','k',...
        'marker','o','markersize',3,'markerfacecolor','none','linestyle','none')
    hold on
    plot([0 0],[0 length(forPlot)+1],'color',[.5 .5 .5],'linewidth',1.5,'linestyle','--')
%     plot([61 61],[0 length(forPlot)+1],'color',[.5 .5 .5],'linewidth',1.5,'linestyle','--')
    set(gca,'xlim',[-120 120]);
end