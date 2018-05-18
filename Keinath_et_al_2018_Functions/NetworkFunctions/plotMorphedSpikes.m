function plotMorphedSpikes(all,folder)
    scaleMax = cellfun(@max,all.pos.path,repmat({[]},size(all.pos.path)),repmat({2},size(all.pos.path)),'uniformoutput',false);
    scaleMax = max(cat(3,scaleMax{:}),[],3);
    scaleMin = cellfun(@min,all.pos.path,repmat({[]},size(all.pos.path)),repmat({2},size(all.pos.path)),'uniformoutput',false);
    scaleMin = min(cat(3,scaleMin{:}),[],3);
    scaleMax = scaleMax-scaleMin;

    for k = 1:length(all.spikes.grid{1})
        h = figure(1);
        set(gcf,'position',[50 50 150.*length(all.spikes.grid(1,:)) 150.*length(all.spikes.grid(:,1))])
        for j = 1:length(all.spikes.grid(1,:))
            for i = 1:length(all.spikes.grid(:,1))
                subplot(length(all.spikes.grid(:,1)),length(all.spikes.grid(1,:)),(i-1).*length(all.spikes.grid(1,:))+j)
                plot(all.pos.path{i,j}(1,:),all.pos.path{i,j}(2,:),'color',[0.6 0.6 0.6],'linewidth',1);
                hold on
                plot(all.pos.path{i,j}(1,all.spikes.grid{i,j}{k}),all.pos.path{i,j}(2,all.spikes.grid{i,j}{k}),...
                    'marker','o','markersize',0.5,'color',[0.8 0.1 0.1],'markerfacecolor',[0.8 0.1 0.1],'linestyle','none')
                tmp = get(gca,'position');
                set(gca,'xlim',[min(all.pos.path{i,j}(1,:)) max(all.pos.path{i,j}(1,:))],...
                    'ylim',[min(all.pos.path{i,j}(2,:)) max(all.pos.path{i,j}(2,:))])
                scale = [(max(all.pos.path{i,j}(2,:))-min(all.pos.path{i,j}(2,:)))./scaleMax(2) ...
                    (max(all.pos.path{i,j}(1,:))-min(all.pos.path{i,j}(1,:)))./scaleMax(1)];
                    set(gca,'ydir','normal','position',[tmp(1)+0.5.*(1-scale(2)).*tmp(3) tmp(2)+0.5.*(1-scale(1)).*tmp(4) tmp(3).*scale(2) tmp(4).*scale(1)])
                axis equal
                axis off
            end
        end
        outP = ['Plots/' folder '/Grid/MorphedSpikes/Cell_' num2str(k)];
        saveFig(h,outP,'tiff');
        outP = ['Plots/' folder '/Grid/MorphedSpikes/EPS/Cell_' num2str(k)];
        saveFig(h,outP,'eps');
        close(h);
    end
    
    for k = 1:length(all.spikes.place{1})
        h = figure(1);
        set(gcf,'position',[50 50 150.*length(all.spikes.grid(1,:)) 150.*length(all.spikes.grid(:,1))])
        for j = 1:length(all.spikes.grid(1,:))
            for i = 1:length(all.spikes.grid(:,1))
                subplot(length(all.spikes.grid(:,1)),length(all.spikes.grid(1,:)),(i-1).*length(all.spikes.grid(1,:))+j)
                plot(all.pos.path{i,j}(1,:),all.pos.path{i,j}(2,:),'color',[0.6 0.6 0.6],'linewidth',1);
                hold on
                bs = all.pos.lastBorder{i,j}(all.spikes.place{i,j}{k});
                plot(all.pos.path{i,j}(1,all.spikes.place{i,j}{k}),all.pos.path{i,j}(2,all.spikes.place{i,j}{k}),...
                    'marker','o','markersize',1,'color',[0 0 0],'markerfacecolor',[0 0 0],'linestyle','none')
                tmp = get(gca,'position');
                set(gca,'xlim',[min(all.pos.path{i,j}(1,:)) max(all.pos.path{i,j}(1,:))],...
                    'ylim',[min(all.pos.path{i,j}(2,:)) max(all.pos.path{i,j}(2,:))])
                scale = [(max(all.pos.path{i,j}(2,:))-min(all.pos.path{i,j}(2,:)))./scaleMax(2) ...
                    (max(all.pos.path{i,j}(1,:))-min(all.pos.path{i,j}(1,:)))./scaleMax(1)];
                    set(gca,'ydir','normal','position',[tmp(1)+0.5.*(1-scale(2)).*tmp(3) tmp(2)+0.5.*(1-scale(1)).*tmp(4) tmp(3).*scale(2) tmp(4).*scale(1)])
                axis equal
                axis off
            end
        end
        outP = ['Plots/' folder '/Place/MorphedSpikes/Cell_' num2str(k)];
        saveFig(h,outP,'tiff');
        outP = ['Plots/' folder '/Place/MorphedSpikes/EPS/Cell_' num2str(k)];
        saveFig(h,outP,'eps');
        close(h);
    end
end