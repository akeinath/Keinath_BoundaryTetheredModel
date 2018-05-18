function upnet = spikes2Maps(net)
    
    theta = diff(net.pos,[],2);
    theta = cart2pol(theta(1,:),theta(2,:));
    thetaBin = floor(((mod(theta,2*pi)./(2.*pi)).*360)./net.p.specific.HDBinSize)+1;
    dbsize = 180;
    dirBin = floor(mod((((mod(theta,2*pi)./(2.*pi)).*360)-dbsize/2),360)./dbsize)+1;
    
    upnet = net;
    
    if isfield(net.p.path.boundary,'max_radius')
        bP = floor(bsxfun(@minus,net.pos(:,2:end),[-net.p.path.boundary.max_radius; -net.p.path.boundary.max_radius])./net.p.specific.mapBinSize)+1;
    else
        bP = floor(bsxfun(@minus,net.pos(:,2:end),net.p.path.boundingBox(1:2)')./net.p.specific.mapBinSize)+1;
    end
    for i = 1:length(net.act)
        % Regular Map
        for j = unique(bP','rows')'
            for k = find(~cellfun(@isempty,net.spike_ts(i).units))
                upnet.maps.act{i}(j(1),j(2),k) = sum(ismember(bP(:,net.spike_ts(i).units{k})',j','rows'));
            end
            upnet.maps.sampling(j(1),j(2)) = sum(ismember(bP',j','rows')).*net.p.ts;
        end

        % Head Directions Tuning Curves
        for j = unique(thetaBin)
            for k = find(~cellfun(@isempty,net.spike_ts(i).units))
                upnet.maps.HD{i}(k,j) = sum(j==thetaBin(:,net.spike_ts(i).units{k}));
            end
            upnet.maps.HDsampling(j) = sum(j==thetaBin).*net.p.ts;
        end

        % NESW Maps
        for dir = unique(dirBin)
            for j = unique(bP(:,dirBin==dir)','rows')'
                for k = find(~cellfun(@isempty,net.spike_ts(i).units))
                    upnet.maps.directionMaps{i}(j(1),j(2),k,dir) = sum([dirBin(net.spike_ts(i).units{k})==dir]' & ...
                        ismember(bP(:,net.spike_ts(i).units{k})',j','rows'));
                end
                upnet.maps.directionMapsSampling(j(1),j(2),dir) = sum([dirBin==dir]' & ...
                        ismember(bP',j','rows')).*net.p.ts;
            end
        end

        % Border Maps
        for lb = unique(net.lastBorder)
            for j = unique(bP(:,net.lastBorder(2:end)==lb)','rows')'
                for k = find(~cellfun(@isempty,net.spike_ts(i).units))
                    upnet.maps.borderMaps{i}(j(1),j(2),k,lb) = sum([net.lastBorder(net.spike_ts(i).units{k})==lb]' & ...
                        ismember(bP(:,net.spike_ts(i).units{k})',j','rows'));
                end
                upnet.maps.borderMapsSampling(j(1),j(2),lb) = sum([net.lastBorder(2:end)==lb]' & ...
                        ismember(bP',j','rows')).*net.p.ts;
            end
        end
    end
end