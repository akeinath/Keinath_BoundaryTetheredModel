function plotRateMaps(map,directionMap,borderMap)
        %% Rate Map, Autocorr, HD Tuning, Direction Maps, Border Maps
        figure(1)
        set(gcf,'position',[50 50 600 300])
        subplot(2,4,1)
        imagesc(map)
        set(gca,'ydir','normal')
        axis square
        axis off
        axis equal
        text(0,-1,num2str(round(max(max(maps{2}(:,:,k))).*1000)./1000),'fontname','arial',...
                'fontsize',11,'fontweight','bold','color','k')
%         colorbar
%         subplot(2,4,2)
%         imagesc(acorr(maps{2}(:,:,k)))
%         set(gca,'ydir','normal')
%         axis square
%         axis off
%         axis equal
        subplot(2,4,2)
        HDPlot = [cosd(net.p.specific.HDBinSize./2:net.p.specific.HDBinSize:360).*net.maps.HD{2}(k,:)./net.maps.HDsampling;...
            sind(net.p.specific.HDBinSize./2:net.p.specific.HDBinSize:360).*net.maps.HD{2}(k,:)./net.maps.HDsampling]';
        hold on
        plot([0 0],[-max(abs(HDPlot(:))) max(abs(HDPlot(:)))],'linewidth',1.5,'color',[0.6 0.6 0.6])
        plot([-max(abs(HDPlot(:))) max(abs(HDPlot(:)))],[0 0],'linewidth',1.5,'color',[0.6 0.6 0.6])
        plot(HDPlot(:,1),HDPlot(:,2),'linewidth',2,'color','k')
        axis off

        %% Direction Maps
        for q = 1:2
            subplot(2,4,2+q)
            imagesc(directionMaps{2}(:,:,k,q))
            if q == 1
                text(length(directionMaps{2}(1,:,k,q))./2,...
                    -length(directionMaps{2}(:,1,k,q)).*0.2,'<----',...
                    'fontname','arial','fontweight','bold','fontsize',13,'horizontalalignment','center');
            elseif q == 2
                text(length(directionMaps{2}(1,:,k,q))./2,...
                    -length(directionMaps{2}(:,1,k,q)).*0.2,'---->',...
                    'fontname','arial','fontweight','bold','fontsize',13,'horizontalalignment','center');
            end
            set(gca,'ydir','normal')
            axis square
            axis off
            axis equal
        end

        %% Border Maps
        for q = 1:4
            subplot(2,4,4+q)
            imagesc(borderMaps{2}(:,:,k,q))
            set(gca,'ydir','normal')
            axis square
            axis off
            axis equal
        end
end