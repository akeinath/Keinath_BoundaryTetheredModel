function plotMorphFits(m,mods,xMorph,yMorph,folder)
    best = repmat({[]},([size(m) mods 2]));
    cellsPerMod =(length(m{1,1}(1,1,:))./mods);
    for mi = 1:mods
        refs = m{yMorph==1,xMorph==1}(:,:,(mi-1).*cellsPerMod+1:(mi).*cellsPerMod);
        for i = 1:length(m(:,1))
            for j = 1:length(m(1,:))
                fprintf(['Fitting Module ' num2str(mi) ' mx: ' num2str(xMorph(j)) '  my: ' num2str(yMorph(i)) ' ...'])
                tic
                [cellVals] = bestFitMorph2(refs,m{i,j}(:,:,(mi-1).*cellsPerMod+1:(mi).*cellsPerMod),xMorph,yMorph);
                toc
%                 best{i,j,mi,1} = vals(:,1);
%                 best{i,j,mi,2} = vals(:,2);
                
                best{i,j,mi,1} = cellVals(:,1);
                best{i,j,mi,2} = cellVals(:,2);
            end
        end
    end

%     load('Fits');

    xl = num2cell(round(xMorph.*100));
    for i = 1:length(xl)
        xl{i} =[ num2str(xl{i}) '%'];
    end
    
    figure
    set(gcf,'position',[50 50 900 400])
    tmp = permute(best(:,:,:,1),[3 2 1]);
%     mkDot(tmp,xl);
    mkGraph(cellfun(@minus,tmp,repmat({100},size(tmp)),'uniformoutput',false),xl)
    for i = xMorph.*100
        if i~=100;
            plot([(find(i==xMorph.*100))-.5 (find(i==xMorph.*100))+.5],...
                [i i]-100,'color',[.4 .8 .4],'linestyle','--','linewidth',2);
        end
    end
    outP = ['Plots/' folder '/BestFitMorphs_Bar'];
    saveFig(gcf,outP,'tiff'); saveFig(gcf,outP,'eps');
    close all
    
%     figure
%     set(gcf,'position',[50 50 600 400])
%     h = mkGraph(permute(best(:,:,:,1),[3 2 1]),xl);
%     % Make Module Legend
%     h = legend(h(:,1),num2str([1:mods]'),'orientation','horizontal','location','northoutside');
%     set(get(h,'title'),'string','Module:','fontname','arial','fontweight','bold','fontsize',12)
%     plot(get(gca,'xlim'),[100 100],'color','k','linestyle','--','linewidth',1.5);
%     % Plot full Morph Lines
%     for i = xMorph.*100
%         if i~=100;
%             plot([(find(i==xMorph.*100))-.5 (find(i==xMorph.*100))+.5],...
%                 [i i],'color',[.4 .8 .4],'linestyle','--','linewidth',2);
%         end
%     end
%     scale = (max(xMorph)-min(xMorph))/8;
%     set(gca,'ylim',[min(xMorph)-scale max(xMorph)+scale].*100)
%     pYL = [get(gca,'yticklabel') repmat('%',[length(get(gca,'yticklabel')) 1])];
%     set(gca,'yticklabel',pYL,'linewidth',1.5)
%     ylabel('Best Fit Morph')
%     xlabel('Morphed Environment Size')
%     
%     outP = ['Plots/' folder '/BestFitMorphs'];
%     saveFig(gcf,outP,'tiff'); saveFig(gcf,outP,'eps');
%     close all
    
    % Alt Dimension Scaling
    figure
    set(gcf,'position',[50 50 600 400])
    mkGraph(permute(best(:,:,:,2),[3 2 1]),xl);
    % Make Module Legend
    h = legend(h(:,1),num2str([1:mods]'),'orientation','horizontal','location','northoutside');
    set(get(h,'title'),'string','Module:','fontname','arial','fontweight','bold','fontsize',12)
    plot(get(gca,'xlim'),[100 100],'color','k','linestyle','--','linewidth',1.5);
    % Plot full Morph Lines
    for i = xMorph.*100
        if i~=100;
            plot([(find(i==xMorph.*100))-.5 (find(i==xMorph.*100))+.5],...
                [i i],'color',[.4 .8 .4],'linestyle','--','linewidth',2);
        end
    end
    scale = (max(xMorph)-min(xMorph))/8;
    set(gca,'ylim',[min(xMorph)-scale max(xMorph)+scale].*100)
    pYL = [get(gca,'yticklabel') repmat('%',[length(get(gca,'yticklabel')) 1])];
    set(gca,'yticklabel',pYL,'linewidth',1.5)
    ylabel('Best Fit Morph')
    xlabel('Morphed Environment Size')
    
    outP = ['Plots/' folder '/BestFitMorphs_OtherDim'];
    saveFig(gcf,outP,'tiff'); saveFig(gcf,outP,'eps');
    close all
    
%     tmp = permute(best(:,:,:,2),[3 2 1]);    
end























