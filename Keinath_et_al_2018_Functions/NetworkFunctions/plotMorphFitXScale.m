function plotMorphFitXScale(m,mods,xMorph,yMorph,binSize,folder)
    best = repmat({[]},([size(m) mods 2]));
    scale = nan(30,mods);
    cellsPerMod =(length(m{1,1}(1,1,:))./mods);
    for mi = 1:mods
        refs = m{yMorph==1,xMorph==1}(:,:,(mi-1).*cellsPerMod+1:(mi).*cellsPerMod);
        for i = 1:length(m(:,1))
            for j = 1:length(m(1,:))
                fprintf(['Fitting Module ' num2str(mi) ' mx: ' num2str(xMorph(j)) '  my: ' num2str(yMorph(i)) ' ...'])
                tic
                [vals ] = bestFitMorph2(refs,m{i,j}(:,:,(mi-1).*cellsPerMod+1:(mi).*cellsPerMod),xMorph,yMorph);
                toc
                best{i,j,mi,1} = vals(:,1);
                best{i,j,mi,2} = vals(:,2);
            end
        end
        for k = 1:length(refs(1,1,:))
            ac = pvxcorr(refs(:,:,k),refs(:,:,k),[],20);
            [patches d2c] = getPatches(ac,0,.3);
            scale(k,mi) = mean(d2c(2:7)).*binSize;
        end
    end
    
    tmp = transcm;
    groupColor = tmp(round(linspace(1,length(tmp),mods)),:);
    
    reference = find(xMorph==1);
    for xm = xMorph
        figure(1)
        set(gcf,'position',[50 50 175 200])
        for mi = 1:mods
            vals = cat(1,best{yMorph==1,xMorph==xm,mi,1});
            vals = vals./100;
            if xm<1
                vals = (-(vals-1))./(1-xm);
            else
                vals = (vals-1)./(xm-1);
            end
            plot(vals,scale(mi),'linestyle','none','marker','o','markersize',10,...
                'color','k','markerfacecolor',groupColor(mi,:),'linewidth',1.5)
            hold on
        end
        set(gca,'xlim',[-.5 1.5],'xtick',[0 1],'xticklabel',[{'0%'} {'100%'}],...
            'ylim',[20 130]);
        plot([0 0],get(gca,'ylim'),'linewidth',1.5,'linestyle','--','color',[0.6 0.6 0.6])
        plot([1 1],get(gca,'ylim'),'linewidth',1.5,'linestyle','--','color',[0.6 0.6 0.6])
        set(gca,'children',flipud(get(gca,'children')))
        set(gca,'position',[get(gca,'position').*[1 1 1 0.95]])
        
        if xm<1
            title(['Compression:  ' num2str(round(abs(1-xm).*100)) '%'],'interpreter','none')
        else
            title(['Expansion:  ' num2str(round(abs(xm-1).*100)) '%'],'interpreter','none')
        end
        
        outP = ['Plots/' folder '/IndividualMorphFigures_' num2str(round(xm.*100))];
        saveFig(gcf,outP,'tiff'); saveFig(gcf,outP,'eps');
        close all
    end
    
    reference = find(xMorph==1);
    for xm = xMorph
        figure(1)
        set(gcf,'position',[50 50 175 200])
        for mi = 1:mods
            vals = cat(1,best{yMorph==1,xMorph==xm,mi,2});
            vals = vals./100;
            if xm<1
                vals = (-(vals-1))./(1-xm);
            else
                vals = (vals-1)./(xm-1);
            end
            plot(vals,scale(mi),'linestyle','none','marker','o','markersize',10,...
                'color','k','markerfacecolor',groupColor(mi,:),'linewidth',1.5)
            hold on
        end
        set(gca,'xlim',[-.5 1.5],'xtick',[0 1],'xticklabel',[{'0%'} {'100%'}],...
            'ylim',[20 130]);
        plot([0 0],get(gca,'ylim'),'linewidth',1.5,'linestyle','--','color',[0.6 0.6 0.6])
        plot([1 1],get(gca,'ylim'),'linewidth',1.5,'linestyle','--','color',[0.6 0.6 0.6])
        set(gca,'children',flipud(get(gca,'children')))
        set(gca,'position',[get(gca,'position').*[1 1 1 0.95]])
        
        if xm<1
            title(['Compression:  ' num2str(round(abs(1-xm).*100)) '%'],'interpreter','none')
        else
            title(['Expansion:  ' num2str(round(abs(xm-1).*100)) '%'],'interpreter','none')
        end
        
        outP = ['Plots/' folder '/IndividualMorphFigures_' num2str(round(xm.*100)) '_AlternateDimension'];
        saveFig(gcf,outP,'tiff'); saveFig(gcf,outP,'eps');
        close all
    end
end