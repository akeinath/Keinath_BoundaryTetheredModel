function net = bg2pConnect(net,nBorderCells)
    popI = 1;
    popJ = 2;
    
    if net.p.link(popI,popJ).sparsity>1
        connectionsEach = net.p.link(popI,popJ).sparsity;
    else
        connectionsEach = round((length(net.w{popI,popJ}(:,1))-nBorderCells).*net.p.link(popI,popJ).sparsity);
    end
    
    net.isLinked{popI,popJ} = false(size(net.w{popI,popJ}));
    for i = 1:length(net.w{popI,popJ}(1,:))
        good = randperm(length(net.w{popI,popJ}(:,1))-nBorderCells)+nBorderCells;
        net.isLinked{popI,popJ}(good(1:connectionsEach),i) = true;
    end
    net.w{popI,popJ}(~net.isLinked{popI,popJ}) = 0;
    
    net.w{1,2}(1:nBorderCells,:) = rand(nBorderCells,numel(net.act{2})).*net.p.link(1,2).init;
    net.isLinked{1,2}(1:nBorderCells,:) = true;
end