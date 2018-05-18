function plotShift(dm,m,mods,xMorph,yMorph,folder)
%     nc = length(dm{1}(1,1,:,1))./mods;
%     allMaps = repmat({[]},[mods length(dm)]);
%     for mi = 1:mods
%         for i = 1:length(dm)
%             m1 = dm{i}(:,:,nc.*(mi-1)+1:mi.*nc,2);
%             m2 = dm{i}(:,:,nc.*(mi-1)+1:mi.*nc,4);
%             allMaps{mi,i} = pvxcorr(m1,m2);
%         end
%     end

    allMaps = repmat({[]},([size(m) mods 2]));
    cellsPerMod =(length(dm{1,1}(1,1,:,1))./mods);
    for mi = 1:mods
        refs = m{yMorph==1,xMorph==1}(:,:,(mi-1).*cellsPerMod+1:(mi).*cellsPerMod);
        for i = 1:length(dm(:,1))
            for j = 1:length(dm(1,:))
                for bi = 1:2
                    allMaps{i,j,mi,bi} = pvxcorr(refs,dm{i,j}(:,:,(mi-1).*cellsPerMod+1:(mi).*cellsPerMod,bi*2));
                    imagesc(allMaps{1})
                    drawnow
                end
            end
        end
    end
    
    permute(diff(best(:,:,:,:,1),[],4),[3 2 1])

%     figure(1);
%     set(gcf,'position',[50 50 150.*length(dm) 150*mods])
%     for mi = 1:mods
%         for i = 1:length(dm)
%             subplot(mods,length(dm),length(dm).*(mi-1)+i)
%             imagesc(allMaps{mi,i})
%             set(gca,'ydir','normal')
%             axis off
%             axis equal
%             hold on
%             plot((length(allMaps{mi,i}(1,:))./2)+1,(length(allMaps{mi,i}(:,1))./2)+1,...
%                 'color','w','marker','o','markersize',3,'markerfacecolor','w')
%             plot(.5,.5,...
%                 'color','w','marker','o','markersize',3,'markerfacecolor','w')
%         end
%     end
%     
%     outP = ['Plots/' folder '/BorderMapCrosscorrelation'];
%     saveFig(gcf,outP,'tiff'); saveFig(gcf,outP,'eps');
%     close all
%     
%     colors = transcm;
%     colors = colors(min([1:length(colors)./mods:length(colors)],length(colors)),:);
%     
%     figure(2)
%     set(gcf,'position',[50 50 100.*length(dm) 400])
%     allShift = repmat({[]},size(allMaps));
%     for i = 1:length(dm)
%         for mi = 1:mods
%             a = getPatches(allMaps{mi,i},0,0.1);
% %             figure(3)
% %             imagesc(a)
% %             drawnow
% %             pause
%             
%             [x y] = find(a==1);
%             tmp = allMaps{mi,i};
%             tmp(a~=1) = 0;
%             tmp = tmp./sum(tmp(:));
%             centroid = [sum(x.*tmp(a==1)) sum(y.*tmp(a==1))];
%             
%             
%             shift = centroid - round([(length(allMaps{mi,i}(:,1))./2) (length(allMaps{mi,i}(1,:))./2)]);
% %             h(mi) = plot([shift(2)],[shift(1)],'color',colors(mi,:),'marker','o',...
% %                 'markerfacecolor',colors(mi,:),'markersize',7);
% %             hold on
% % %             plot([0 shift(2)],[0 shift(1)],'color',colors(mi,:),'linestyle','-',...
% % %                 'linewidth',2)
% %             val = 6;
% %             set(gca,'xlim',[-val val],'ylim',[-val val])
% %             axis square
%             allShift{mi,i} = shift(2);
% 
%         end
% %         plot(get(gca,'xlim'),[0 0],'color',[0.6 0.6 0.6],'linestyle','--','linewidth',2)
% %         plot([0 0],get(gca,'ylim'),'color',[0.6 0.6 0.6],'linestyle','--','linewidth',2)
%     end
%     h = mkGraph(allShift,1:length(dm));
%     set(gca,'ylim',[-12 12])
%     plot(get(gca,'xlim'),[0 0],'linewidth',2,'color','k')
%     h = legend(h(:,1),num2str([1:mods]'),'orientation','horizontal','location','northoutside');
%     set(get(h,'title'),'string','Module:','fontname','arial','fontweight','bold','fontsize',12)
% %     set(gca,'ylim',[-max(get(gca,'ylim')) max(get(gca,'ylim'))])
end










