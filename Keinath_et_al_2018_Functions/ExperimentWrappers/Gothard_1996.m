function Gothard_1996(isSpiking,withBorderInput,useBVCs)
    if nargin<1
        isSpiking=true;
    end
    if nargin<2
        withBorderInput=true;
    end
    if nargin<3
        useBVCs=false;
    end
    clc

    folderPath = ['Gothard_1996'];
    if isSpiking
        folderPath = [folderPath '/Spiking' ];
    else
        folderPath = [folderPath '/Rate' ];
    end
    
    if withBorderInput
        if useBVCs
            folderPath = [folderPath '/WithBVCs' ];
        else
            folderPath = [folderPath '/WithBorders' ];
        end
    else
        folderPath = [folderPath '/WithoutBorders' ];
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters

    % Overall Simulation Parameters
    p.spiking = isSpiking;
    p.sims = 1; % How many consecutive sims of exploration (each N seconds defined by path length)
    p.ts = 0.003; % timestep in seconds
    p.doPlot = false; % Generate Plots During Simulation
    p.forCluster = true; % Cease all plot generation and final plots if true.
    p.overwrite = true; % 
    p.useBVCs = false;

    % Path Parameters 
    p.path.type = 'linear'; % Define type of environment (linear or open). If linear, make x the long dimensions

    % Border Cell Network Parameters
    if useBVCs
        p.pop(1) = params('bvc');
    else
        p.pop(1) = params('border');
    end
    p.pop(2) = params('grid');
    p.pop(3) = params('place');
    p.specific = params('specific');

    % Connectivity
    if withBorderInput && useBVCs
        p.link(1,3) = params('bvc2p');
        p.link(3,3) = params('p2p');
    else
        if withBorderInput
            p.link(1,2) = params('b2g');
        end
        p.link(2,2) = params('g2g');
        % 
        % p.link(1,3) = params('b2p');
        p.link(2,3) = params('g2p');
        p.link(3,3) = params('p2p');
    end
        
    % p.link(3,2) = params('p2g');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Simulations %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%% Training
    p.folder = [folderPath '/Training'];
    p.sims = 4;
    p.path.length = 900; % Length in Seconds of each path
    p.path.boundary.line = bsxfun(@times,([0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1]-0.5),[134 35 134 35]);
    p.path.boundary.ellipse = [];
    p.path.velocity = 20; % (cm/sec) for linear track laps 
    p.path.init = [min(min(p.path.boundary.line(:,[1 3]))) 0];
    precompute(p); % Precompute Paths and Border Activations for the sims
    trainedNet = runSims(p,[],true);

    %%%%%% Morph Experiments
    xMorphs = fliplr(1-((1-(53./161))./4).*[0:4]);
    yMorphs = [1];
    for mx = xMorphs
        for my = yMorphs
            p.path.boundary.line = bsxfun(@times,trainedNet.p.path.boundary.line,[mx my mx my]);
            p.path.init = [min(min(p.path.boundary.line(:,[1 3]))) 0];
            p.folder = [folderPath '/Test/mx_' num2str(round(100*mx)) '_my_' num2str(round(100*my)) ];
            p.sims = 1;
            p.path.length = 1800;
            trainedNet.act{2} = trainedNet.init.act{2};
            precompute(p);
            runSims(p,trainedNet,false);
        end
    end

    if ~p.forCluster
        xMorphs = fliplr(1-((1-(53./161))./4).*[0:4]);
        yMorphs = [1];
        
        outP = ['MatlabData/Nets/' folderPath '/Test'];
        all = getMapsFromNets(outP);

        plottable = repmat({[]},[1 5]);
        for i = 1:length(all.maps.complete.place)
            nums = size(all.maps.complete.place{i});
            plottable{1,i} = permute(all.maps.directional.place{i}(...
                ceil(length(all.maps.directional.place{5}(:,1,1,1))./2),:,:,[2 1]),[2 3 4 1]);
        end
        pvLinCorr(plottable(1,:),[folderPath '/Summary/Place'])
        plotLinMorphedMaps(plottable(1,:),[folderPath '/Summary/Place'])
    end
end
