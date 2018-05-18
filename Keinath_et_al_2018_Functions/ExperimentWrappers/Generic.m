function Generic(isSpiking,withBorderInput)
    if nargin<1
        isSpiking=true;
    end
    if nargin<2
        withBorderInput=true;
    end
    clc
    
    folderPath = ['Generic'];
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
    p.ts = 0.003; % timestep in seconds
    p.doPlot = true; % Generate Plots During Simulation
    p.forCluster = false; % Cease all plot generation and final plots if true.
    p.overwrite = true; % If you want to overwrite any previously-run simulations
    p.useBVCs = false;

    % Path Parameters 
    p.path.type = 'open'; % Define type of environment (linear or open). If linear, make x the long dimensions

    % Border Cell Network Parameters
    p.pop(1) = params('bvc');
    p.pop(2) = params('grid');
    p.pop(3) = params('place');
    p.specific = params('specific');

    % Connectivity
    
    if withBorderInput
        p.link(1,2) = params('b2g');
    end
    p.link(2,2) = params('g2g');
    % 
%     p.link(1,3) = params('bvc2p');
    p.link(2,3) = params('g2p');
%     p.link(3,3) = params('p2p');

    % p.link(3,2) = params('p2g');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%% Simulations %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %     %%%%%% Morph Training
    p.folder = [folderPath '/Training'];
    p.sims = 1;
    p.path.length = 600; % Length in Seconds of each path
    p.path.boundary.line = bsxfun(@minus,[0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1],[0.5 0.5 0.5 0.5]).*100;
    p.path.boundary.ellipse = [];
    p.path.init = [0 0.01];
    precompute(p); % Precompute Paths and Border Activations for the sims
    trainedNet = runSims(p,[],true);

    plotNetMaps(trainedNet,'Generic/',1)
end



































