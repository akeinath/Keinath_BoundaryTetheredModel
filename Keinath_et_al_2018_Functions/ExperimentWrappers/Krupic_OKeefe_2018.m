function Krupic_OKeefe_2018(isSpiking,withBorderInput)
    if nargin<1
        isSpiking=true;
    end
    if nargin<2
        withBorderInput=true;
    end
    clc
    
    folderPath = ['Krupic_OKeefe_2018'];
    if isSpiking
        folderPath = [folderPath '/Spiking' ];
    else
        folderPath = [folderPath '/Rate' ];
    end
    
    if withBorderInput
        folderPath = [folderPath '/WithBorders' ];
    else
        folderPath = [folderPath '/WithoutBorders' ];
    end
    
    
    % Overall Simulation Parameters
    p.spiking = isSpiking;
    p.sims = 1; % How many consecutive sims of exploration (each N seconds defined by path length)
    p.ts = 0.003; % timestep in seconds 0.0005 1ms?
    p.doPlot = false; % Generate Plots During Simulation
    p.forCluster = true; % Cease all plot generation and final plots if true.
    p.overwrite = true; % 
    p.useBVCs = false;

    % Path Parameters 
    p.path.type = 'open'; % Define type of environment (linear or open). If linear, make x the long dimensions

    % Border Cell Network Parameters
    p.pop(1) = params('border');
    p.pop(2) = params('grid');
%     p.pop(3) = params('place');
    p.specific = params('specific');

    % Connectivity
    
    if withBorderInput
        p.link(1,2) = params('b2g');
    end
    p.link(2,2) = params('g2g');
    % 
    % p.link(1,3) = params('b2p');
%     p.link(2,3) = params('g2p');
%     p.link(3,3) = params('p2p');

    % p.link(3,2) = params('p2g');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Simulations %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %     %%%%%% Morph Training
    p.folder = [folderPath '/Training'];
    p.sims = 4;
    p.path.length = 900; % Length in Seconds of each path
    p.path.boundary.line = bsxfun(@minus,[0 0 1.8 0; 0 0 0 1; 1.8 0 1.8 1; 0 1 1.8 1],[0.9 0.5 0.9 0.5]).*100;
    p.path.boundary.ellipse = [];
    p.path.init = [0 0];
    precompute(p); % Precompute Paths and Border Activations for the sims
    runSims(p,[],true);

    %%%%%% Morph Experiments
    pointShift = fliplr([0:(1./3):1]);
    trainedNet = load(['MatlabData/Nets/' folderPath '/Training/Net']);
    for ps = pointShift
        p.path.boundary.line = bsxfun(@minus,[0 0 1.8 0; 0 0 0 1; 1.8 0 1.8 1; 0 1 1.8 1; 0.45 0 0 ps;],[0.9 0.5 0.9 0.5]).*100;
        p.folder = [folderPath '/Test/mx_100_my_' num2str(round(100*ps))];
        p.sims = 1;
        p.path.length = 1800;
        trainedNet.act{2} = trainedNet.init.act{2};
        precompute(p);
        runSims(p,trainedNet,false);
    end

    if ~p.forCluster
        outP = ['MatlabData/Nets/' folderPath '/Test'];
        all = getMapsFromNets(outP);

        plotMorphedMaps(all.maps.complete.grid,[1 1 1 1 1],[1 1 1 1 1],[folderPath '/Summary/Grid']);
        plotPartialShift(all.maps.complete.grid,[folderPath '/Summary/Grid'])
    end
end



































