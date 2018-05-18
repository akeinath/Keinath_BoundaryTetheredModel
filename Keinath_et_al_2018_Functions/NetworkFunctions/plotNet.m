function plotNet(net,plotAct,plotWeights)
    if plotAct
        figure(1)
        maxMods = max(cat(2,net.p.pop(:).mods));
        set(gcf,'position',[50 50 220.*maxMods 240*length(net.act)])
        for pi = 1:length(net.act)
            for pj = 1:net.p.pop(pi).mods
                h = subplot(length(net.act),maxMods,(pi-1).*maxMods+(pj));
                a = net.act{pi}(:,:,pj);
%                 colormap('hot')
                if length(a(1,:))>1
                    imagesc(a)
                    axis square
%                     axis equal
                    caxis([0 max(caxis)])
                    colorbar
                    axis off
                else
                    stem(1:length(a),a,':diamondk','filled','markersize',5)
                    set(h,'ylim',[0 max(max(a(:)).*1.1,0.5)],'xlim',[0 length(a)])
                end
            end
        end
    end
    
    if plotWeights
        figure(2)
        set(gcf,'position',[800 50 240*length(net.act) 255*length(net.act)])
        for pi = 1:length(net.w(:,1))
            for pj = 1:length(net.w(1,:))
                if ~isempty(net.w{pi,pj})
                    subplot(length(net.act),length(net.act),(pi-1).*length(net.act)+pj)                      
                    imagesc(net.w{pi,pj})
                    caxis([0 max(caxis)])
                    axis square
                    colorbar
                end
            end
        end
    end
    
    drawnow;
end