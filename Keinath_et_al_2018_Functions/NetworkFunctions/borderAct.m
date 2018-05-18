function [act borderSpikes lastBorder] = borderAct(net,path)
    b = [net.p.path.boundingBox(1:2); net.p.path.boundingBox(3:4)];
    
    width = net.p.specific.borderSD;
    
    if isempty(b)
        act = zeros(numel(net.act{1}),length(path(1,:)));
        return
    end
    
    piecesPerSide = net.p.specific.borderPiecesPerSide;
    piecesPerCell = net.p.specific.borderPiecesPerCell;
    
%     theta = [ones(1,piecesPerSide).*0 ...
%         ones(1,piecesPerSide).*(pi/2) ...
%         ones(1,piecesPerSide).*(pi) ...
%         ones(1,piecesPerSide).*(3*pi/2)]; % Allocentric Directional Tuning of each Boundary Piece

    theta = [0 pi/2 pi 3*pi/2]; % Possible Piece Allocentric Directional Tunings
    projPath = bsxfun(@plus,path,permute([sin(theta); cos(theta)],[1 3 2]).*width); % Path projected WIDTH distance along THETA angles
    isDir = nan(length(projPath(1,1,:)),length(path(1,:)));
    for k = 1:length(projPath(1,1,:))
        parfor loc = 1:length(path(1,:))
            isDir(k,loc) = wouldCrossBound(path(:,loc),projPath(:,loc,k),net); % is near to border in allocentric direction THETA
        end
    end
    
    
    pieceSize = [max(b)-min(b)]./piecesPerSide;
    cPath = floor(bsxfun(@rdivide,bsxfun(@minus,path,min(b)'),pieceSize'))+1; % path divided into chuncks
    
    thetaChunk = cPath([(mod(theta-pi,pi)+pi/4)>(pi/2)]+1,:); %chunk in x or y relavent for theta
    pieceAct = nan([length(theta).*piecesPerSide],length(path(1,:)));
    pieceOrder = piecesPerSide:-1:1;
    for i = 1:length(theta)
        if any(i == [1 2 4])
            pieceOrder = fliplr(pieceOrder);
        end
        for j = 1:piecesPerSide
            pieceAct((i-1).*piecesPerSide+j,:) = thetaChunk(i,:)==pieceOrder(j) & isDir(i,:);
        end
    end

    map = [];
    for i = 1:net.p.pop(1).nPerMod
        map = [map; mod((i-1):i+piecesPerCell-2,length(pieceAct(:,1)))+1];
    end
    
%     asym = min(1:piecesPerSide,piecesPerSide-[0:piecesPerSide-1])-1;
%     if sign(net.p.specific.borderAsymmetry)==-1
%         asym = abs(asym-max(asym));
%     end
%     asym = [asym./max(asym)].*-abs(net.p.specific.borderAsymmetry);
%     asym = 1+repmat(asym,[1 4]);
    
    
    act = nan(net.p.pop(1).nPerMod,length(path(1,:)));
    for i = 1:length(act(:,1))
        isGood = pieceAct(map(i,:),:);
%         ta = bsxfun(@times,isGood,asym(map(i,:))');
        act(i,:) = max(isGood,[],1).*net.p.specific.borderScalar;
    end
    
    borderSpikes = nan;
    if net.p.spiking
        spikes = zeros(length(act(:,1)),1);
        borderSpikes = zeros(size(act));
        for i = 1:length(act(1,:))
            spike = (act(:,i)- net.thresh{1}).*(net.p.ts).*net.p.pop(1).excitability > rand(size(spikes));
            borderSpikes(:,i) = spike;
            spike = spike.*net.p.specific.spikeScalar;
            spikes = spikes + (net.p.ts/net.p.pop(1).tc)*(-spikes +(net.p.pop(1).tc/net.p.ts)*spike);
            act(:,i) = spikes;
            if (act(:,i)- net.thresh{1}).*(net.p.ts).*net.p.pop(1).excitability > 1
                fprintf('fail')
            end
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