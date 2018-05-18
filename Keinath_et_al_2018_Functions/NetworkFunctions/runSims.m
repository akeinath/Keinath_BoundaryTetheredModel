function net = runSims(p,net,doLearning)

    % whether to include hebbian learning
    if nargin<3
        doLearning = true;
    end


    fprintf('\n\n\n\t\t\t*************************************************\n')
    fprintf('\t\t\t****************** Simulations ******************\n')
    fprintf('\t\t\t*************************************************\n')
    
    outP = ['MatlabData/Nets/' p.folder '/IndividualSims'];
    startSim = 1;
    if isdir(outP)
        if p.overwrite
            rmdir(outP,'s');
            fprintf(['\n\tIGNORING Incomplete Simulations. First New Simulation:  ' num2str(startSim) '\n'])
        else
            f = dir([outP '/*.mat']);
            fn = cat(2,{f(:).name});
            si = zeros(1,length(fn));
            for i = 1:length(fn)
                si = str2num(fn{i}(find(fn{i}=='_',1,'last')+1:find(fn{i}=='.',1,'last')-1));
            end
            [a b] = max(si);
            net = load([outP '/' fn{b}]);
            startSim = a+1;
            
            fprintf(['\n\tLOADING Incomplete Simulations. First New Simulation:  ' num2str(startSim) '\n'])
        end    
    end
    
    % Initialize Network with the entered parameters
    if isempty(net)
        net = mkNet(p);
        net.filt{2,2} = [];
        
%         % If this is a medial septal inactivation simulation, replace the
%         % grid input with the msinact_grid_input before settling
%         if exist('varargin')==1 && ~isempty(varargin) && ismember({'msinact'},varargin)
%             net.p.pop(2).input = ones(size(net.p.pop(2).input)).*p.specific.msinact_grid_input;
%         else
%             net.p.pop(2).input = ones(size(net.p.pop(2).input)).*p.pop(2).input;
%         end

        
        % Run network for Xsec to stabilize grid network 
        % (no learning, location, or border input)
        settleTime = 2;
        fprintf(['\nSettling Grid Network for ' num2str(settleTime) ' seconds... '])
        tic
        delta = [0; 0.*net.p.ts];
        for t = 1:settleTime/net.p.ts
            
%             delta = randn(2,1).*200.*net.p.ts;
%             if t>0.5./net.p.ts
%                 delta = randn(2,1).*100.*net.p.ts;
% %                 delta = [0; 0.*net.p.ts];
%             end
%             if t>1./net.p.ts
%                 delta = randn(2,1).*25.*net.p.ts;
%             end
%             if t>1.5./net.p.ts
%                 delta = [0; 0.*net.p.ts];
%             end
    
            
            net = up(net,delta,false);

            if mod(t,0.25./net.p.ts)==0 && net.p.doPlot
                plotNet(net,true,true);
            end
        end
        toc
    end
    
    
%     % If this is a medial septal inactivation simulation, replace the
%     % grid input with the msinact_grid_input in case net is not
%     % newly-created
%     if exist('varargin')==1 && ~isempty(varargin) && ismember({'msinact'},varargin)
%         net.p.pop(2).input = ones(size(net.p.pop(2).input)).*p.specific.msinact_grid_input;
%         fprintf(['\n\tMEDIAL SEPTAL INACTIVATION SIMULATIONS\n']);
%     else
%         net.p.pop(2).input = ones(size(net.p.pop(2).input)).*p.pop(2).input;
%     end

    
    % Save initial grid act for ' p.folder ' sims
    net.init = net;
    net.p.path = p.path;
    %%%%%%%%%%%% Initial Learning (Training)%%%%%%%%%%%%%%%%
    fprintf('\nSimulations:')
    %%% Simulate a bounded path (Ripped from Burak & Fiete)
    outMaps = repmat({[]},[1 p.sims]);
    for sim = startSim:p.sims
        clearAmount = 0;
        
        fprintf(['\n\tRunning ' p.folder ' Simulation ' num2str(sim) ' of ' num2str(p.sims) ':  '])
        tic
        
        load(['MatlabData/Precomputed/' p.folder '/SimPaths/Sim_' num2str(sim)]);

        %%% Reset maps that store activity activity
        net = resetMaps(net,p);
        net.pos = animalPath;
        net.lastBorder = lastBorder;
        % Walk through path
        for loc = 2:length(animalPath)
            % set border activity
            net.act{1} = ba(:,loc);
            
            % update network with border input and the relevant movement info
            delta = animalPath(:,loc)-animalPath(:,loc-1);
            theta = cart2pol(delta(1),delta(2));
            
%             a = net.w{1,3};
            net = up(net,delta,doLearning);
            
            % store spike times for later analysis if is spiking network,
            % else update the rate maps (storing rate maps at every
            % timestep requires too much RAM).
            
            if net.p.spiking
                for i = 1:length(net.act)
                    isSpike = find(net.spikes{i}(net.p.pop(i).store)>0);
                    for k = isSpike
                        net.spike_ts(i).units{k} =  [net.spike_ts(i).units{k}; loc-1];
                    end
                end
            else
                net = upMaps(net,animalPath(:,loc),theta,lastBorder(loc));
            end
            
            % Plot network if requested and not on cluster
%             if mod(loc,2./net.p.ts)==0
%                 imagesc(net.w{1,3}-a)
%                 colorbar
%                 drawnow
%             end
            
            if mod(loc,2./net.p.ts)==0 && net.p.doPlot && ~net.p.forCluster
                plotNet(net,true,true);
                suptitle([num2str(floor(loc./length(animalPath).*100)) '%'])
            end

            % Indicate progress
            if mod(loc,floor(length(animalPath)./100))==0                
                fprintf(repmat('\b',[1 clearAmount]));
                tmp = fprintf([num2str(floor(loc./length(animalPath).*100)) '%%']);
                clearAmount = tmp;
            end
        end
        fprintf('\t');
        toc
        fprintf('\b');
        
        % If is a spiking network, assemble maps now
        if net.p.spiking
            fprintf(['\n\t\t Creating Maps From Spikes...'])
            tic
            net = spikes2Maps(net);
            toc
            fprintf('\b')
        end
        
        % If not for the cluster (where java doesn't play nice) plot some
        % maps now.
        if ~net.p.forCluster
            plotNetMaps(net,p.folder,sim);
        end
        
        %%%% Save net after run in case of crash
        outP = ['MatlabData/Nets/' p.folder '/IndividualSims/Net_Sim_' num2str(sim)];
        checkP(outP);
        save(outP,'-struct','net','-v7.3');
    end
    outP = ['MatlabData/Nets/' p.folder '/Net'];
    checkP(outP);
    save(outP,'-struct','net','-v7.3');
end