function net = mkNet(p)
    net.act = [];
    net.thresh = [];
    net.filt = [];
    for i = 1:length(p.pop)
        if ismember({'sheet'},p.pop(i).topography)
            if i~=2
                net.act = [net.act {rand(sqrt(p.pop(i).nPerMod),sqrt(p.pop(i).nPerMod),p.pop(i).mods).*0.01}];
                net.thresh = [net.thresh {p.pop(i).thresh.*ones(sqrt(p.pop(i).nPerMod),sqrt(p.pop(i).nPerMod),p.pop(i).mods)}];
            else %%% if grid, make sure network activity is oriented left-right (0deg)
                lattice = zeros(sqrt(p.pop(i).nPerMod),sqrt(p.pop(i).nPerMod));
                space = 15;
                lattice(1:space.*2:end,1:space:end) = 20;
                lattice(space:space.*2:end,round(space./2):space:end) = 20;
                net.act = [net.act {repmat(lattice,[1 1 p.pop(i).mods])}];
                net.thresh = [net.thresh {p.pop(i).thresh.*ones(sqrt(p.pop(i).nPerMod),sqrt(p.pop(i).nPerMod),p.pop(i).mods)}];
            end
        elseif ismember({'line'},p.pop(i).topography)
            net.act = [net.act {rand(p.pop(i).nPerMod,1,p.pop(i).mods).*0.01}];
            net.thresh = [net.thresh {p.pop(i).thresh.*ones(p.pop(i).nPerMod,1,p.pop(i).mods)}];
        end
    end
    net.w = repmat({[]},length(net.act));
    
    %%% Wire up Connectivity
    for popI = 1:length(p.link(:,1))
        for popJ = 1:length(p.link(1,:))
            if ~isempty(p.link(popI,popJ).type)
                
                
                %%% Random Full Connectivity, ranging from 0 to init
                if ismember({'RandUniform'},(p.link(popI,popJ).type))
                    
                    if p.link(popI,popJ).sparseFrom>1
                        connectionsEach(1) = p.link(popI,popJ).sparseFrom;
                    else
                        connectionsEach(1) = round(numel(net.act{popI}).*p.link(popI,popJ).sparseFrom);
                    end
                    
                    if p.link(popI,popJ).sparseTo>1
                        connectionsEach(2) = p.link(popI,popJ).sparseTo;
                    else
                        connectionsEach(2) = round(numel(net.act{popJ}).*p.link(popI,popJ).sparseTo);
                    end
                    
                    net.w{popI,popJ} = rand(numel(net.act{popI}),numel(net.act{popJ})).*p.link(popI,popJ).init;
                    
                    goodFrom = false(numel(net.act{popI}),numel(net.act{popJ}));
                    for i = 1:numel(net.act{popJ})
                        good = randperm(numel(net.act{popI}));
                        goodFrom(good(1:connectionsEach(1)),i) = true;
                    end
                    
                    goodTo = false(numel(net.act{popI}),numel(net.act{popJ}));
                    good = randperm(numel(net.act{popJ}));
                    goodTo(:,good(1:connectionsEach(2))) = true;
                    
                    net.isLinked{popI,popJ} = goodFrom&goodTo;
                    [a b] = find(net.isLinked{popI,popJ});
                    net.linkedInds{popI,popJ} = [a b find(net.isLinked{popI,popJ})];
                    
                    net.w{popI,popJ} = reshape(net.w{popI,popJ}(net.isLinked{popI,popJ}),connectionsEach);
                    
                    p.link(popI,popJ).connectionsEach = connectionsEach;
                end
                
                if ismember({'Uniform'},(p.link(popI,popJ).type))
                    net.w{popI,popJ} = ones(numel(net.act{popI}),numel(net.act{popJ})).*p.link(popI,popJ).init;
                    net.isLinked{popI,popJ} = true(size(net.w{popI,popJ}));
                    [a b] = find(net.isLinked{popI,popJ});
                    net.linkedInds{popI,popJ} = [a b];
                    p.link(popI,popJ).connectionsEach = [size(net.w{popI,popJ})];
                end
                
                %%% Uniform Periodic Radial Connectivity 
                if ismember({'RadialUniform'},(p.link(popI,popJ).type))
                    if popI~=popJ
                        fprintf('Cannot wire across populations with radial uniformity')
                        continue
                    end
                    tmp = zeros(sqrt(p.pop(popI).nPerMod));
                    tmp2 = tmp;
                    tmp2(1,1) = p.link(popI,popJ).init;
                    for i = [-length(tmp)./2+1:length(tmp)./2]
                        for j = [-length(tmp)./2+1:length(tmp)./2]
                            if sqrt((i)^2+(j)^2)<=p.link(popI,popJ).radius
                                tmp = tmp+circshift(tmp2,[i j]);
                            end
                        end
                    end
%                     tmp(1,1) = 0;
                    
                    net.filt{popI,popJ} = fft2(circshift(tmp,[p.pop(popI).nPerMod/2 p.pop(popI).nPerMod/2]));                    
                end
                
            end
        end
    end
    
    net.p = p;
    net.wAct = weightActs(net);
    
    
    %%% Filters For Grid Network
    tmp = zeros(sqrt(p.pop(2).nPerMod));
    tmp2 = tmp;
    
    g2g = params('g2g');
    tmp2(1,1) = g2g.init;
    for i = [-length(tmp)./2+1:length(tmp)./2]
        for j = [-length(tmp)./2+1:length(tmp)./2]
            if sqrt((i)^2+(j)^2)<=g2g.radius
                tmp = tmp+circshift(tmp2,[i j]);
            end
        end
    end
%     tmp(1,1) = 0;
    
    left = fft2(circshift(tmp,[p.pop(2).nPerMod/2-p.specific.gridConnectivityShiftDistance p.pop(2).nPerMod/2]));
    up = fft2(circshift(tmp,[p.pop(2).nPerMod/2 p.pop(2).nPerMod/2+p.specific.gridConnectivityShiftDistance]));
    right = fft2(circshift(tmp,[p.pop(2).nPerMod/2+p.specific.gridConnectivityShiftDistance p.pop(2).nPerMod/2]));
    down = fft2(circshift(tmp,[p.pop(2).nPerMod/2 p.pop(2).nPerMod/2-p.specific.gridConnectivityShiftDistance]));
    
    net.p.movementFilters = [{repmat(left,[1 1 p.pop(2).mods])} {repmat(up,[1 1 p.pop(2).mods])} ...
        {repmat(right,[1 1 p.pop(2).mods])} {repmat(down,[1 1 p.pop(2).mods])}];
    
    goodLeft = zeros(size(left));
    goodLeft(1:2:end,1:2:end) = 1;
    goodUp = zeros(size(up));
    goodUp(1:2:end,2:2:end) = 1;
    goodRight = zeros(size(right));
    goodRight(2:2:end,1:2:end) = 1;
    goodDown = zeros(size(down));
    goodDown(2:2:end,2:2:end) = 1;
    net.p.movementTypes = [{repmat(goodLeft,[1 1 p.pop(2).mods])} {repmat(goodUp,[1 1 p.pop(2).mods])} ...
        {repmat(goodRight,[1 1 p.pop(2).mods])} {repmat(goodDown,[1 1 p.pop(2).mods])}];
    
    if p.spiking
        for i = 1:length(net.act)
            net.spikes{i} = zeros(size(net.act{i}));
        end
    end
    
    %%% Set up maps to store the rate maps of the cells set in params (not
    %%% super ideal to store these instead of the activity, but storing the
    %%% activity of many cells is super RAM expensive, with all the modules
    %%% of grids and whatnot in the full simulation
    
    % determine map boundaries
    net.p.path.boundingBox = getBoundaryBoundingBox(p);
    
    net = resetMaps(net,p);
end





























