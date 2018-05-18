function Knierim_2008(isSpiking,withBorderInput,useBVCs)
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

    folderPath = ['Knierim_2008'];
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
    p.ts = 0.003; % timestep in seconds 0.0005 1ms?
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
    p.path.boundary.line = ([0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1]-0.5).*135;
    p.path.boundary.ellipse = [];
    p.path.init = [0 0];
    precompute(p); % Precompute Paths and Border Activations for the sims
    trainedNet = runSims(p,[],true);
    
    p.folder = [folderPath '/Test/SmallBox'];
    p.sims = 1;
    p.path.length = 1800; % Length in Seconds of each path
    p.path.boundary.line = ([0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1]-0.5).*58;
    p.path.boundary.ellipse = [];
    p.path.init = [0 0];
    precompute(p); % Precompute Paths and Border Activations for the sims
    runSims(p,trainedNet,false);
    
    p.folder = [folderPath '/Test/LargeBox'];
    p.sims = 1;
    p.path.length = 1800; % Length in Seconds of each path
    p.path.boundary.line = ([0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1]-0.5).*135;
    p.path.boundary.ellipse = [];
    p.path.init = [0 0];
    precompute(p); % Precompute Paths and Border Activations for the sims
    runSims(p,trainedNet,false);

    if ~p.forCluster 
        a = load(['MatlabData/Nets/' folderPath '/Test/SmallBox/Net']);
        b = load(['MatlabData/Nets/' folderPath '/Test/LargeBox/Net']);
        aM = getMaps(a);
        bM = getMaps(b);
        plotMorphedMaps([aM(2) bM(2)],[58./135 1],1,[folderPath  '/Summary/Grid']);
    end
end