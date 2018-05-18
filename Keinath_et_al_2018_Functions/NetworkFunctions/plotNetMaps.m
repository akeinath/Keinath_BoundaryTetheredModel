function plotNetMaps(net,folder,sim)

    [maps] = getMaps(net); % directionMaps borderMaps
    
    %% Plot Grid Cells
    for i = 1:net.p.pop(2).mods
        for k = (length(net.p.pop(2).store)./net.p.pop(2).mods).*(i-1)+1:(length(net.p.pop(2).store)./net.p.pop(2).mods).*i

            %% Rate Map, Autocorr, HD Tuning
            figure(1)
            colormap('jet')
            set(gcf,'position',[50 50 1000 400])
            subplot(2,5,1)
            imagesc(maps{2}(:,:,k))
            set(gca,'ydir','normal')
            axis square
            axis off
            axis equal
            text(0,-1,num2str(round(max(max(maps{2}(:,:,k))).*1000)./1000),'fontname','arial',...
                    'fontsize',11,'fontweight','bold','color','k')
%             colorbar
%             subplot(2,5,10)
%             imagesc(acorr(maps{2}(:,:,k)))
%             set(gca,'ydir','normal')
%             axis square
%             axis off
%             axis equal
            if net.p.spiking
                subplot(2,5,2)
                plot(net.pos(1,:),net.pos(2,:),'linewidth',1,'color',[0.6 0.6 0.6]);
                hold on
                plot(net.pos(1,net.spike_ts(2).units{k}),net.pos(2,net.spike_ts(2).units{k}),...
                    'color',[1 0.3 0.3],'linestyle','none','marker','o','markersize',1.5,'markerfacecolor',[1 0.3 0.3])
                axis square
                axis equal
                axis off
            end

%             subplot(2,5,3)
%             HDPlot = [cosd(net.p.specific.HDBinSize./2:net.p.specific.HDBinSize:360).*net.maps.HD{2}(k,:)./net.maps.HDsampling;...
%                 sind(net.p.specific.HDBinSize./2:net.p.specific.HDBinSize:360).*net.maps.HD{2}(k,:)./net.maps.HDsampling]';
%             hold on
%             plot([0 0],[-max(abs(HDPlot(:))) max(abs(HDPlot(:)))],'linewidth',1.5,'color',[0.6 0.6 0.6])
%             plot([-max(abs(HDPlot(:))) max(abs(HDPlot(:)))],[0 0],'linewidth',1.5,'color',[0.6 0.6 0.6])
%             plot(HDPlot(:,1),HDPlot(:,2),'linewidth',2,'color','k')
%             axis off
% 
%             %% Direction Maps
%             for q = 1:2
%                 subplot(2,5,3+q)
%                 imagesc(directionMaps{2}(:,:,k,q))
%                 if q == 1
%                     text(length(directionMaps{2}(1,:,k,q))./2,...
%                         -length(directionMaps{2}(:,1,k,q)).*0.2,'<----',...
%                         'fontname','arial','fontweight','bold','fontsize',13,'horizontalalignment','center');
%                 elseif q == 2
%                     text(length(directionMaps{2}(1,:,k,q))./2,...
%                         -length(directionMaps{2}(:,1,k,q)).*0.2,'---->',...
%                         'fontname','arial','fontweight','bold','fontsize',13,'horizontalalignment','center');
%                 end
%                 set(gca,'ydir','normal')
%                 axis square
%                 axis off
%                 axis equal
%             end
% 
%             %% Border Maps
%             for q = 1:4
%                 subplot(2,5,5+q)
%                 imagesc(borderMaps{2}(:,:,k,q))
%                 set(gca,'ydir','normal')
%                 axis square
%                 axis off
%                 axis equal
%             end
% 
            outP = ['Plots/' folder '/Grid/Maps/Sim_' num2str(sim) '/Mod_ ' num2str(i) '/Cell_' num2str(k)];
            saveFig(gcf,outP,'tiff');
            outP = ['Plots/' folder '/Grid/Maps/Sim_' num2str(sim) '/Mod_ ' num2str(i) '/EPS/Cell_' num2str(k)];
            saveFig(gcf,outP,'eps');
            close all
            drawnow

        end
    end

    %% Plot Place Cells
    if length(maps)>2
        for k = 1:length(maps{3}(1,1,:))
            %% Maps
            figure(1)
            colormap('jet')
            set(gcf,'position',[50 50 600 300])
            subplot(2,5,1)
            imagesc(maps{3}(:,:,k))
            set(gca,'ydir','normal')
            axis square
            axis off
            axis equal
            text(-3,-3,num2str(round(max(max(maps{3}(:,:,k))).*1000)./1000),'fontname','arial',...
                    'fontsize',11,'fontweight','bold','color','k')
            
            if net.p.spiking
                subplot(2,5,2)
                plot(net.pos(1,:),net.pos(2,:),'linewidth',1,'color',[0.6 0.6 0.6]);
                hold on
                plot(net.pos(1,net.spike_ts(3).units{k}),net.pos(2,net.spike_ts(3).units{k}),...
                    'color',[1 0.3 0.3],'linestyle','none','marker','o','markersize',1.5,'markerfacecolor',[1 0.3 0.3])
                axis square
                axis equal
                axis off
            end
                
%             %% Direction Maps
%             for q = 1:2
%                 subplot(2,5,q+3)
%                 imagesc(directionMaps{3}(:,:,k,q))
%                 if q == 1
%                     text(length(directionMaps{3}(1,:,k,q))./2,...
%                         -length(directionMaps{3}(:,1,k,q)).*0.2,'<----',...
%                         'fontname','arial','fontweight','bold','fontsize',13,'horizontalalignment','center');
%                 elseif q == 2
%                     text(length(directionMaps{3}(1,:,k,q))./2,...
%                         -length(directionMaps{3}(:,1,k,q)).*0.2,'---->',...
%                         'fontname','arial','fontweight','bold','fontsize',13,'horizontalalignment','center');
%                 end
%                 set(gca,'ydir','normal')
%                 axis square
%                 axis off
%                 axis equal
%             end
% 
%             %% Border Maps
%             for q = 1:4
%                 subplot(2,5,5+q)
%                 imagesc(borderMaps{3}(:,:,k,q))
%                 set(gca,'ydir','normal')
%                 axis square
%                 axis off
%                 axis equal
%             end
% 
            outP = ['Plots/' folder '/Place/Maps/Sim_' num2str(sim) '/Cell_' num2str(k)];
            saveFig(gcf,outP,'tiff')
            outP = ['Plots/' folder '/Place/Maps/Sim_' num2str(sim) '/EPS/Cell_' num2str(k)];
            saveFig(gcf,outP,'eps')
            close all
            drawnow
        end
    end
end