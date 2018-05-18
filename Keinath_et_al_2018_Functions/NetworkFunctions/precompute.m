function precompute(p)
    net = mkNet(p);

    fprintf('\n\n\n\t\t\t*************************************************\n')
    fprintf('\t\t\t***************** Precomputing ******************\n')
    fprintf('\t\t\t*************************************************\n')
    
    % Precompute Paths and Border Activity
    fprintf(['\n\nCreating ' num2str(net.p.sims) ' paths (' num2str(p.path.length) ...
        ' seconds each: ' p.path.type ') and precomputing border activation for:\n\t' p.folder ' Simulation: '])
    tic
    for sim = 1:net.p.sims
        fprintf([num2str(sim) '... '])
        if ismember((p.path.type),{'linear'})
            animalPath = mkLinearPath(net);
        elseif ismember((p.path.type),{'open'})
            animalPath = mkPath(net);
        elseif ismember((p.path.type),{'blah'})
            rot = 180;
            animalPath = [[(-25:0.01:0); zeros(1,length((-25:0.01:0)))]'*[cosd(rot) -sind(rot); sind(rot) cosd(rot)]]';
        end
    
%         if ~p.useBVCs
        [ba borderSpikes lastBorder] = borderAct(net,animalPath);
%         end
        if p.useBVCs
            [ba borderSpikes] = bvcAct(net,animalPath);
        end
        if ismember((p.path.type),{'linear'}) && p.useBVCs
            ba((net.p.pop(1).nPerMod./4)+1:(net.p.pop(1).nPerMod./4).*2,:) = 0;
            borderSpikes((net.p.pop(1).nPerMod./4)+1:(net.p.pop(1).nPerMod./4).*2,:) = 0;
            ba((net.p.pop(1).nPerMod./4).*3+1:(net.p.pop(1).nPerMod./4).*4,:) = 0;
            borderSpikes((net.p.pop(1).nPerMod./4).*3+1:(net.p.pop(1).nPerMod./4).*4,:) = 0;
        end
        
        outP = ['MatlabData/Precomputed/' p.folder '/SimPaths/Sim_' num2str(sim)];
        checkP(outP);
        save(outP,'animalPath','ba','lastBorder','-v7.3');
        net.p.path.init = animalPath(:,end)';

        if ~p.forCluster
            % Plot Border Cells
            if net.p.spiking == true
                maps = mkMap(animalPath,borderSpikes,net.p.specific.mapBinSize)./net.p.ts;
            else
                maps = mkMap(animalPath,ba,net.p.specific.mapBinSize);
            end
            
            for k = 1:length(ba(:,1))
                figure(1);
                colormap('jet')
                set(gcf,'position',[50 50 150 150])
                imagesc(maps(:,:,k));
                text(1,length(maps(:,1,k))+1,[num2str(round(nanmax(nanmax(maps(:,:,k))).*10)./10) ' Hz'],'fontname','arial',...
                    'fontsize',11,'fontweight','bold','color','k')
                set(gca,'ydir','normal')
                axis square
                axis equal
                axis off
                outP = ['Plots/' p.folder '/BorderCells/Sim_' num2str(sim) '/Cell_' num2str(k)];
                saveFig(gcf,outP,'tiff')
                saveFig(gcf,outP,'eps')
                close all
            end

            plotPathAndBounds(animalPath,net,lastBorder);
            outP = ['Plots/' p.folder '/Paths/Sim_' num2str(sim)];
            saveFig(gcf,outP,'tiff'); saveFig(gcf,outP,'eps');
            close all
            drawnow
        end
    end
    toc
    fprintf('\b')
end







































