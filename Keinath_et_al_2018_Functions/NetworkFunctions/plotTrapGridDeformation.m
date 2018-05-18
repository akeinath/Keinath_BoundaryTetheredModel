function plotTrapGridDeformation(m,folder)
    for k = 1:length(m{1}(1,1,:))
        
        figure
        set(gcf,'position',[50 50 600 length(m(:,1)).*150])
        for mi = 1:length(m(:,1))
            cM = m{mi}(:,:,k);
            
            % Draw those cool curvy lines
            [a b c] = getPatches(cM,0,[],.3);            
            
            xd = bsxfun(@minus,c(:,1),c(:,1)');
            yd = bsxfun(@minus,c(:,2),c(:,2)');
            x = xd(triu(true(size(xd)),1));
            y = yd(triu(true(size(xd)),1));
            tmp = sort(sqrt((x.^2)+(y.^2)),'ascend');
            scale = nanmax(tmp(1:length(c(:,1))));            
            neighbors = [];
            for ai = 1:max(a(:))
                distances =bsxfun(@minus,c(ai,:),c([1:ai-1 ai+1:end],:));
                isNeighbor = abs(distances(:,2))<scale.*0.5 & abs(distances(:,1))<1.5.*scale;
                isNeighbor = [isNeighbor(1:ai-1); false; isNeighbor(ai:end)];
                neighbors = [neighbors; repmat(c(ai,:),[sum(isNeighbor) 1]) c(isNeighbor,:)];
            end          
            
            subplot(length(m(:,1)),2,((mi-1).*2)+1)
            imagesc(cM)
            axis equal
            axis off
            hold on
            plot([neighbors(:,[1 3])]',[neighbors(:,[2 4])]','color','w','linewidth',3,'linestyle','-')
            
            subplot(length(m(:,1)),2,((mi-1).*2)+2)
            imagesc(pvxcorr(cM,cM,[20 40]))
            axis equal
            axis off
        end
        
        outP = ['Plots/' folder '/TrapazoidalGridDeformation/Cell_' num2str(k)];
        saveFig(gcf,outP,'tiff');
        outP = ['Plots/' folder '/TrapazoidalGridDeformation/EPS/Cell_' num2str(k)];
        saveFig(gcf,outP,'eps');
        close all; drawnow;
    end
end