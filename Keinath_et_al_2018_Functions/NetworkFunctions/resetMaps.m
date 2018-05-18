function net = resetMaps(net,p)

    boundingBox = getBoundaryBoundingBox(p);
    
    if isfield(net.p.path.boundary,'max_radius')
        mapSize = ones(1,2).*floor(2.*net.p.path.boundary.max_radius./p.specific.mapBinSize)+1;
    else
        net.p.path.boundingBox = boundingBox;
        mapSize = floor([diff(boundingBox([1 3])) diff(boundingBox([2 4]))]./p.specific.mapBinSize)+1;
    end
    
    for i = 1:length(net.act)
        net.maps.act{i} = zeros([mapSize length(p.pop(i).store)]);
        net.maps.HD{i} = zeros([length(p.pop(i).store) round(360./p.specific.HDBinSize)]);
        net.maps.borderMaps{i} = zeros([mapSize length(p.pop(i).store) 4]);
        net.maps.directionMaps{i} = zeros([mapSize length(p.pop(i).store) 4]);
    end
    net.maps.sampling = zeros([mapSize]);
    net.maps.directionMapsSampling = zeros([mapSize 4]);
    net.maps.borderMapsSampling = zeros([mapSize 4]);
    net.maps.HDsampling = zeros(1,round(360./p.specific.HDBinSize));
    
    if net.p.spiking
        for i = 1:length(net.act)
            net.spike_ts(i).units = repmat({[]},[1 length(net.p.pop(i).store)]);
        end
    end
end