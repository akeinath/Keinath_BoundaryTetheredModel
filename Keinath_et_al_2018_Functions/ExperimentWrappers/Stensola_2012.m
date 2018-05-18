function Stensola_2012(isSpiking,withBorderInput,useBVCs)
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

    folderPath = ['Stensola_2012'];
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
    p.useBVCs = useBVCs;
    
    % Path Parameters 
    p.path.type = 'open'; % Define type of environment (linear or open). If linear, make x the long dimensions

    % Border Cell Network Parameters
    if useBVCs
        p.pop(1) = params('bvc');
    else
        p.pop(1) = params('border');
    end
    p.pop(2) = params('grid');
    % p.pop(3) = params('place');
    p.specific = params('specific');

    % Connectivity
    
    if withBorderInput
        p.link(1,2) = params('b2g');
    end
    p.link(2,2) = params('g2g');
    % 
    % p.link(1,3) = params('b2p');
    % p.link(2,3) = params('g2p');
    % p.link(3,3) = params('p2p');

    % p.link(3,2) = params('p2g');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Simulations %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     %%%%%% Training
    p.folder = [folderPath '/Training'];
    p.sims = 4;
    p.path.length = 900; % Length in Seconds of each path
    p.path.boundary.line = ([0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1]-0.5).*150;
    p.path.boundary.ellipse = [];
    p.path.init = [0 0];
    precompute(p); % Precompute Paths and Border Activations for the sims
    trainedNet = runSims(p,[],true);

    %%%%%% Morph Experiments
    xMorphs = ([4/6 5/6  1 7/6 8/6]); % 3/6 4/6 5/6    4/6 5/6  1 7/6 8/6
    yMorphs = [1];
    trainedNet = load(['MatlabData/Nets/' folderPath '/Training/Net']);
    for mx = xMorphs
        for my = yMorphs
            p.path.boundary.line = bsxfun(@times,trainedNet.p.path.boundary.line,[mx my mx my]);
            p.folder = [folderPath '/Test/mx_' num2str(round(100*mx)) '_my_' num2str(round(100*my)) ];
            p.sims = 1;
            p.path.length = 1800;
            trainedNet.act{2} = trainedNet.init.act{2};
            precompute(p);
            runSims(p,trainedNet,false);
        end
    end

    if ~p.forCluster 
        xMorphs = ([4/6 5/6  1 7/6 8/6]);
        trainedNet = load(['MatlabData/Nets/' folderPath '/Training/Net']);
        outP = ['MatlabData/Nets/' folderPath '/Test'];
        all = getMapsFromNets(outP);
        
        getSummaryMorphParameters(all.maps.complete.grid([2 4]));

        plotMorphedMaps(all.maps.complete.grid,xMorphs,yMorphs,[folderPath '/Summary/Grid']);
        plotMorphedSpikes(all,[folderPath '/Summary'])
        plotMorphFits(all.maps.complete.grid,trainedNet.p.pop(2).mods,xMorphs,yMorphs,[folderPath '/Summary/Grid']);
    end
end