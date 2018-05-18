function allComp = plotBorderMapDriftComp(m,folder)
     % 1=right 2=up 3=left 4=down
    allComp = [];
%     chooseCells = randperm(60);
    for k = 1:length(m{1}(1,1,:,1))
        
        vals = nan(2,2,4);
        for j = 1:length(m(1,:))
            for i = 1:length(m(:,1))
                up_down = (pvxcorr(m{i,j}(:,:,k,2),m{i,j}(:,:,k,4),[20 20],20));
                left_right = (pvxcorr(m{i,j}(:,:,k,1),m{i,j}(:,:,k,3),[20 20],20));

                [udp q a] = getPatches(up_down,0,[],0.3);
                [lrp q b] = getPatches(left_right,0,[],0.3);

                
                if all(udp(:)==0) || all(lrp(:)==0)
                    continue
                end
                
                [a b] = find(up_down==nanmax(up_down(udp==1))&udp==1);
                [c d] = find(left_right==nanmax(left_right(lrp==1))&lrp==1);

  
                if isempty(a) || isempty(b) || isempty(c) || isempty(d)
                    continue
                end

                vals(i,j,:) = [nanmean(c) nanmean(b) nan nan]-round(length(up_down)./2);

            end
        end
        allComp = [allComp; permute(vals(1,2,1:2),[1 3 2]) permute(vals(1,1,1:2),[1 3 2]) ...
            permute(vals(2,2,1:2),[1 3 2]) permute(vals(2,1,1:2),[1 3 2])];

    end
    
    plotable = repmat({[]},[1 8]);
    for sim = 1:1
        chooseCells = randperm(150);
        
        for i = 1:length(allComp(1,:))
            plotable{i} = [plotable{i} nanmean(abs(allComp(chooseCells(1:23),i)).*2.5)];
    %             plotable = [plotable {abs(allComp(:,i))}];
        end
    end

    for i = 1:length(allComp(1,:))
        plotable{i}(isnan(plotable{i})) = [];
        
    end
    
    close all
    figure(1)
    set(gcf,'position',[50 50 500 250])
%             cumHist(plotable,[0:1:ceil(30)])
    mkGraph([[plotable(1:2:length(plotable)); plotable(2:2:length(plotable))] [{[]}; {[]}]],1:length(plotable),'sd');
    set(gca,'ylim',[0 23])
    drawnow
end