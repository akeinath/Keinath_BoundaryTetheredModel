function plotMorphedMaps(m,xMorph,yMorph,folder)
    for k = 1:length(m{1,1}(1,1,:))
        h = figure;
        colormap jet
        morphs = [size(m,1) size(m,2)];
        set(gcf,'position',[50 50 morphs(2).*150 morphs(1).*150])

        peak = 0;
        for i = 1:morphs(1)
            for j = 1:morphs(2)
                if isempty(max(m{i,j}))
                    continue
                end
                peak = max(peak,nanmax(nanmax(m{i,j}(:,:,k))));
            end
        end

        for i = morphs(1):-1:1
            for j = morphs(2):-1:1
                if isempty(m{i,j})
                    continue
                end
                subplot(morphs(1),morphs(2),(i-1).*morphs(2)+j)
%                 axis tight
                imagesc(m{i,j}(:,:,k))
                alpha(double(~isnan(m{i,j}(:,:,k))));
                tmp = get(gca,'position');
                scale = fliplr([xMorph(j)./max(xMorph(1:morphs(2))) yMorph(i)./max(yMorph(1:morphs(1)))]);
%                         set(gca,'position',[tmp(1)+(1-scale(2))/2 tmp(2)+(1-scale(1))/2 tmp(3).*scale(2) tmp(4).*scale(1)])
                set(gca,'ydir','normal','position',[tmp(1)+0.5.*(1-scale(2)).*tmp(3) tmp(2)+0.5.*(1-scale(1)).*tmp(4) tmp(3).*scale(2) tmp(4).*scale(1)])
                axis equal
%                 caxis([0 peak]);
                caxis([0 nanmax(nanmax(m{i,j}(:,:,k)))]);
                
                loc = get(gca,'position');
                text(1,length(m{i,j}(:,1,k))+4,[num2str(round(max(max(m{i,j}(:,:,k))).*10)./10) ' Hz'],'fontname','arial',...
                    'fontsize',11,'fontweight','bold','color','k')
                
                axis off
                hold on
            end
        end
        
        outP = ['Plots/' folder '/MorphedMaps_Unnormalized/Cell_' num2str(k)];
        saveFig(h,outP,'tiff');
        outP = ['Plots/' folder '/MorphedMaps_Unnormalized/EPS/Cell_' num2str(k)];
        saveFig(h,outP,'pdf');
%         allFrames(k) = getframe(gcf);
        close(h);
    end
end