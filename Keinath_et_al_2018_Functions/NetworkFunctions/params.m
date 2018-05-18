function out = params(cue)
    tc = 0.03;
    contrastHebbLR = 1e-5; % 5e-5
    excitability = 500;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%    Population Parameters %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    bvc = genPop();
    border = genPop();
    grid = genPop();
    place = genPop();
    
    % BVC
    bvc.mods = 1;
    bvc.nPerMod = 120;
    bvc.topography = 'line';
    bvc.input = [];
    bvc.tc = tc;
    bvc.thresh = 0;
    bvc.properties = []; % doesn't do anything yet...
    bvc.store = 1;
    bvc.excitability = excitability;
    
    % Border
    border.mods = 1;
    border.nPerMod = 32;
    border.topography = 'line';
    border.input = [];
    border.tc = tc;
    border.thresh = 0;
    border.properties = []; % doesn't do anything yet...
    border.store = 1;
    border.excitability = excitability;
    
    % Grid
    grid.mods = 5; %5
    grid.nPerMod = 128^2; %90
    grid.topography = 'sheet';
    grid.input = 0.6.*ones(sqrt(grid.nPerMod),sqrt(grid.nPerMod),grid.mods); % Generic Excitatory Input
    grid.tc = tc;
    grid.thresh = 0.1;
    grid.properties = [];
    grid.excitability = excitability;
    grid.store = randperm(grid.nPerMod);
    tmp = [];
    for i = 1:(grid.mods)
        tmp = [tmp grid.store(1:30)+(i-1).*grid.nPerMod];
    end
    grid.store = tmp;
%     grid.store = 1;
    

    % Place
    place.mods = 1;
    place.nPerMod = 8^2; % 12^2
    place.topography = 'sheet';
    place.input = [];
    place.tc = tc;
    place.thresh = 0.05;
    place.properties = [];
    place.excitability = excitability;
    place.store = 1:place.nPerMod;

    %%%%%%%%%%%%% Specific Parameters
    specific.bvcScaleDistanceFactor = 1;
    specific.bvcIncrement = 10;
    specific.bvcInitSD = 3;
    specific.bvcScalar = 1;
    specific.borderSD = 12; %cm
    specific.borderShift = 0; %cm
    specific.borderScalar = 0.04; % Max Activation for Border Cells 0.01
    specific.borderPiecesPerSide = 8; % Divide each side border into N pieces
    specific.borderPiecesPerCell = 4; % Each border cell is composed of N neighboring pieces %%%%% CHANGED FOR KRUPIC WAS 1
    specific.borderAsymmetry = 0;
    specific.gridConnectivityShiftDistance = 2;
    specific.mapBinSize = 2.5; % in cm
    specific.HDBinSize = 6; % in deg
    specific.spikeScalar = 0.5;           %75
    specific.minFieldAct = 3;
    specific.minFieldSize = 0;             % 0.92
    specific.translationFactor = permute(0.45.*[(1./(sqrt(2))).^(([1:grid.mods]-1).*1)],[1 3 2]); % How quickly movement translates grid act 
    specific.translationFactor = repmat(specific.translationFactor,[sqrt(grid.nPerMod) sqrt(grid.nPerMod) 1]);    
%     specific.msinact_grid_input = 0.15.*ones(sqrt(grid.nPerMod),sqrt(grid.nPerMod),grid.mods); % Excitatory Input following septal inactivation
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%    Connection Parameters %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    b2g = genLink();
    b2p = genLink();
    bvc2p = genLink();
    g2g = genLink();
    g2p = genLink();
    p2p = genLink();
    p2g = genLink();
    
    % border to grid
%     b2g.type = 'RandUniform';
%     b2g.learning = {'ContrastiveHebb'};
%     b2g.learningRate = contrastHebbLR;
%     b2g.sumWeights = 0.4;
%     b2g.init = 2.*(b2g.sumWeights./border.nPerMod);
%     b2g.sparseTo = 1;
    
    b2g.type = 'RandUniform';
    b2g.learning = {'ContrastiveHebb'};
    b2g.learningRate = contrastHebbLR;
    b2g.sumWeights = 0.4;
    b2g.init = 2.*(b2g.sumWeights./border.nPerMod);
    b2g.sparseTo = 1;
    
    % grid to grid
    g2g.type = 'RadialUniform';
    g2g.init = -.02; %  0.035
    g2g.radius = 12; % 9
    
    weights2Place = 0.5;
    % grid to place
    g2p.type = 'RandUniform';
    g2p.init = 0.022;
    g2p.sparseFrom = 500;%-border.nPerMod;
    g2p.learning = {'ContrastiveHebb'};
    g2p.learningRate = contrastHebbLR;
    g2p.sumWeights = weights2Place;
    g2p.sumWeightNormingPops = []; %[2 3];
    
    % border to place
    b2p.type = 'RandUniform';
    b2p.learning = {'ContrastiveHebb'};
    b2p.learningRate = contrastHebbLR;
    b2p.sumWeights = g2p.sumWeights;
    b2p.init = g2p.init;
    b2p.sumWeightNormingPops = [];
    
    bvc2p.type = 'RandUniform';
    bvc2p.learning = {'ContrastiveHebb'};
    bvc2p.learningRate = 1e-3;
    bvc2p.sumWeights = 25;
    bvc2p.init = 3;
    bvc2p.sumWeightNormingPops = [];
    
    % place to place
    p2p.type = 'RadialUniform';
    p2p.init = -0.15; %
    p2p.radius = inf;
    
    % place to grid feedback
    p2g.type = 'RandUniform';
    p2g.learning = {'ContrastiveHebb'};
    p2g.learningRate = contrastHebbLR;
    p2g.sumWeights = 1;
    p2g.init = 0.05;
    p2g.sumWeightNormingPops = [];


    if ismember({'p2g'},cue)   
        out = p2g;
    end
    
    if ismember({'p2p'},cue)   
        out = p2p;
    end
    
    if ismember({'b2g'},cue)   
        out = b2g;
    end
    
    if ismember({'b2p'},cue)   
        out = b2p;
    end
    
    if ismember({'g2g'},cue)
        out = g2g;
    end
    
    if ismember({'g2p'},cue)
        out = g2p;
    end
    
    if ismember({'bvc2p'},cue)
        out = bvc2p;
    end
    
    
    if ismember({'bvc'},cue)
        out = bvc;
    end
    
    if ismember({'border'},cue)
        out = border;
    end
    
    if ismember({'grid'},cue)
        out = grid;
    end
    
    if ismember({'place'},cue)
        out = place;
    end

    
    if ismember({'specific'},cue)
        out = specific;
    end
end
