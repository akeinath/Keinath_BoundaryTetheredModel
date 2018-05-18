function plotDirMapComp(m,folder)
    for k = 1:length(m{1}(1,1,:,1))
        h = figure(1);
        colormap('jet')
        set(gcf,'position',[50 50 150.*length(m(1,:)) 2.*150.*length(m(:,1))])
        for j = 1:length(m(1,:))
            for i = 1:length(m(:,1))
                for d = [1 2]
                    subplot(length(m(:,1)).*2,length(m(1,:)),(d-1).*length(m(:,1)).*length(m(1,:))+(i-1).*length(m(1,:))+j)
                    imagesc(m{i,j}(:,:,k,d))
                    tmp = get(gca,'position');
                    scale = [length(m{i,j}(:,1,1,1))./max(max(cellfun(@size,m,repmat({1},[size(m)])))) ...
                        length(m{i,j}(1,:,1,1))./max(max(cellfun(@size,m,repmat({2},[size(m)]))))];
                    set(gca,'ydir','normal','position',[tmp(1)+0.5.*(1-scale(2)).*tmp(3) tmp(2)+0.5.*(1-scale(1)).*tmp(4) tmp(3).*scale(2) tmp(4).*scale(1)])
                    axis equal
                    
                    text(1,length(m{i,j}(:,1,k))+4,[num2str(round(max(max(m{i,j}(:,:,k))).*10)./10) ' Hz'],'fontname','arial',...
                        'fontsize',11,'fontweight','bold','color','k')
                    axis off
                end
            end
        end
        outP = ['Plots/' folder '/MorphedDirectionalMaps/Cell_' num2str(k)];
        saveFig(h,outP,'tiff');
        outP = ['Plots/' folder '/MorphedDirectionalMaps/EPS/Cell_' num2str(k)];
        saveFig(h,outP,'eps');
        close(h);
    end
end