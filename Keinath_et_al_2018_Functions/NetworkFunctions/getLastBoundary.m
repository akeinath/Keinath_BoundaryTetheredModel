function [act borderSpikes lastBorder] = getLastBoundary(net,path)
    b = [net.p.path.boundingBox(1:2); net.p.path.boundingBox(3:4)];
    
    width = net.p.specific.borderSD;
    
    if isempty(b)
        act = zeros(numel(net.act{1}),length(path(1,:)));
        return
    end
    
    theta = [0 pi/2 pi 3*pi/2]; % Possible Piece Allocentric Directional Tunings
    projPath = bsxfun(@plus,path,permute([sin(theta); cos(theta)],[1 3 2]).*width); % Path projected WIDTH distance along THETA angles
    isDir = nan(length(projPath(1,1,:)),length(path(1,:)));
    for k = 1:length(projPath(1,1,:))
        parfor loc = 1:length(path(1,:))
            isDir(k,loc) = wouldCrossBound(path(:,loc),projPath(:,loc,k),net); % is near to border in allocentric direction THETA
        end
    end
    
    lastBorder = nan(1,length(act(1,:)));
    isBAct = nan(4,length(act(1,:)));
    for i = 1:4
        isBAct(i,:) = any(pieceAct((i-1).*piecesPerSide+1:(i).*piecesPerSide,:),1);
    end
    
    isBAct([2 4],any(isBAct([1 3],:),1)) = 0;
    isBAct(3,any(isBAct(1,:),1)) = 0;
    
    while any(all(~isBAct))
        noB = all(~isBAct);
        start = find(noB,1,'first');
        stop = find(~noB(start:end),1,'first');
        if isempty(stop)
            stop = (length(noB)-start)+2;
        end
        
        if start==1
            isBAct(1,start:start+stop-2) = 1;
        else
            isBAct(logical(isBAct(:,start-1)),start:start+stop-2) = 1;
        end
    end
    [x y] = find(isBAct);
    lastBorder = x';
end