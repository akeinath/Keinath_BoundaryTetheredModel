function Barry_2006(isSpiking,withBorderInput)
    if nargin<1
        isSpiking=true;
    end
    if nargin<2
        withBorderInput=true;
    end
    clc

    folderPath = ['Barry_2006'];
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters

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
    p.pop(3) = params('place');
    p.specific = params('specific');

    % Connectivity
    
    if withBorderInput
        p.link(1,2) = params('b2g');
    end
    p.link(2,2) = params('g2g');
    % 
    % p.link(1,3) = params('b2p');
    p.link(2,3) = params('g2p');
    p.link(3,3) = params('p2p');

    % p.link(3,2) = params('p2g');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Simulations %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%    Boundary Insertions   %%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%% Boundary Insertion Training
    p.folder = [folderPath '/Training'];
    p.sims = 4;
    p.path.length = 900; % Length in Seconds of each path
    p.path.boundary.line = ([0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1]-0.5).*65;
    p.path.boundary.ellipse = [];
    p.path.init = [0 0];
    precompute(p); % Precompute Paths and Border Activations for the sims
    trainedNet = runSims(p,[],true);
    
    %%%%%% Boundary Insertion Training
    p.folder = [folderPath '/Test_WithoutBoundary'];
    p.sims = 1;
    p.path.length = 1800; % Length in Seconds of each path
    p.path.boundary.line = ([0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1]-0.5).*65;
    p.path.boundary.ellipse = [];
    p.path.init = [1 0];
    precompute(p); % Precompute Paths and Border Activations for the sims
    runSims(p,trainedNet,false);

    %%%%%% Boundary Insertion
    p.folder = [folderPath '/Test_WithBoundary'];
    p.sims = 1;
    p.path.length = 1800; % Length in Seconds of each path
    p.path.boundary.line = ([0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1; 0.5 1-(40/65) 0.5 1]-0.5).*65;
    p.path.boundary.ellipse = [];
    p.path.init = [1 0];
    precompute(p); % Precompute Paths and Border Activations for the sims
    runSims(p,trainedNet,false);

    if ~p.forCluster
        a = load(['MatlabData/Nets/' folderPath '/Test_WithoutBoundary/Net']);
        b = load(['MatlabData/Nets/' folderPath '/Test_WithBoundary/Net']);
        aM = getMaps(a);
        bM = getMaps(b);
        plotMorphedMaps([aM(2) bM(2)],[1 1],1,[folderPath  '/Summary/Grid']);
        plotMorphedMaps([aM(3) bM(3)],[1 1],1,[folderPath  '/Summary/Place']);
    end
end
