function all = getMapsFromNets(folder)
    fnames = dir(folder);
    fnames = cat(1,{fnames(:).name});
    fnames(ismember(fnames,[{'.'} {'..'}])) = [];
    
    sizes = nan(2,length(fnames));
    for i = 1:length(fnames)
        inds = find(fnames{i}=='_');
        sizes(:,i) = [str2num(fnames{i}(inds(1)+1:inds(2)-1)) str2num(fnames{i}(inds(3)+1:end))]';
    end
    
    sizeLabels = nan(size(sizes));
    xl = unique(sizes(1,:));
    yl = unique(sizes(2,:));
    for i = 1:length(fnames)
        sizeLabels(:,i) = [find(sizes(1,i)==xl); find(sizes(2,i)==yl)];
    end
    
    
    all.maps.complete.grid = repmat({[]},[length(yl) length(xl)]);
    all.maps.complete.place = repmat({[]},[length(yl) length(xl)]);
    all.maps.directional.grid = repmat({[]},[length(yl) length(xl)]);
    all.maps.directional.place = repmat({[]},[length(yl) length(xl)]);
    all.maps.border.grid = repmat({[]},[length(yl) length(xl)]);
    all.maps.border.place = repmat({[]},[length(yl) length(xl)]);
    all.pos.path = repmat({[]},[length(yl) length(xl)]);
    all.pos.lastBorder = repmat({[]},[length(yl) length(xl)]);
    all.spikes.grid = repmat({[]},[length(yl) length(xl)]);
    all.spikes.place = repmat({[]},[length(yl) length(xl)]);
    for i = 1:length(fnames)
        net = load([folder '/' fnames{i} '/Net']);
        
        % Compile Maps
        [maps dMaps bMaps] = getMaps(net); % dMaps bMaps
        all.maps.complete.grid{sizeLabels(2,i),sizeLabels(1,i)} = maps{2};
        all.maps.directional.grid{sizeLabels(2,i),sizeLabels(1,i)} = dMaps{2};
        all.maps.border.grid{sizeLabels(2,i),sizeLabels(1,i)} = bMaps{2};
        if length(maps)>2
            all.maps.complete.place{sizeLabels(2,i),sizeLabels(1,i)} = maps{3};
            all.maps.directional.place{sizeLabels(2,i),sizeLabels(1,i)} = dMaps{3};
            all.maps.border.place{sizeLabels(2,i),sizeLabels(1,i)} = bMaps{3};
        end
        
        % Compile Position Info
%         all.pos.path{sizeLabels(2,i),sizeLabels(1,i)} = net.pos;
%         all.pos.lastBorder{sizeLabels(2,i),sizeLabels(1,i)} = net.lastBorder;
%         all.spikes.grid{sizeLabels(2,i),sizeLabels(1,i)} = net.spike_ts(2).units;
%         if length(maps)>2
%             all.spikes.place{sizeLabels(2,i),sizeLabels(1,i)} = net.spike_ts(3).units;
%         end
    end
end
