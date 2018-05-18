function plotLinMorphs(m,folder)
    for dir = 1:2
        for k = 1:length(m{1}(1,1,:,1))
            peak = 0;
            lm = repmat({[]},[1 length(m)]);
            for xm = 1:length(m)
                peak = max(max(max(m{xm}(:,:,k,dir))),peak);
                lm{xm} = m{xm}(ceil(length(m{xm}(:,1,1,dir))./2),:,k,dir);
            end

            h = figure(1);
            set(gcf,'position',[50 50 300 300])
            for xm = 1:length(m)
                patch(bsxfun(@plus,repmat(max(cellfun(@length,lm))-length(lm{xm})+1:max(cellfun(@length,lm)),[4 1]),...
                    [-0.5 0.5 0.5 -0.5]'),...
                    [xm.*ones(1,length(lm{xm})); xm.*ones(1,length(lm{xm})); ...
                    xm+(lm{xm}./peak).*0.8;xm+(lm{xm}./peak).*0.8],[0.6 0.6 0.6 ],'edgecolor',[0.6 0.6 0.6 ])
                hold on
                plot(max(cellfun(@length,lm))-length(lm{xm})+1:max(cellfun(@length,lm)),...
                    [xm+(lm{xm}./peak).*0.8],'color','k','linewidth',3);
            end
            set(gca,'xlim',[-1 max(cellfun(@length,lm))+1],'ylim',[0.8 6])
            axis off

            outP = ['Plots/' folder '/MorphedLinearMaps/Dir_' num2str(dir) '/Cell_' num2str(k)];
            saveFig(h,outP,'tiff');
            outP = ['Plots/' folder '/MorphedLinearMaps/Dir_' num2str(dir) '/EPS/Cell_' num2str(k)];
            saveFig(h,outP,'eps'); close all; drawnow;
        end
    end
end