function [maps directionMaps borderMaps] = getMaps(net) 
    %directionMaps borderMaps
       
    maps = net.maps.act;
    kern = fspecial('gauss',[9 9],1.5);
    for i = 2:length(net.act)
        maps{i} = maps{i}./repmat(net.maps.sampling,[1 1 length(maps{i}(1,1,:))]);
        notSampled = isnan(maps{i});
        maps{i}(notSampled) = 0;
        
        for j = 1:length(maps{i}(1,1,:))
            maps{i}(:,:,j) = imfilter(maps{i}(:,:,j),kern,'same');
        end
        
        maps{i}(notSampled) = nan;
        maps{i} = permute(maps{i},[2 1 3 4]);
    end
    
    % Direction Maps
    
    directionMaps = net.maps.directionMaps;
    for i = 2:length(net.act)
        directionMaps{i} = directionMaps{i}./repmat(permute(net.maps.directionMapsSampling,[1 2 4 3]),...
            [1 1 length(directionMaps{i}(1,1,:,1)) 1]);
        notSampled = isnan(directionMaps{i});
        directionMaps{i}(isnan(directionMaps{i})) = 0;
        
        for j = 1:length(directionMaps{i}(1,1,:,1))
            for k = 1:length(directionMaps{i}(1,1,1,:))
                directionMaps{i}(:,:,j,k) = imfilter(directionMaps{i}(:,:,j,k),kern,'same');
            end
        end
        
        directionMaps{i}(notSampled) = nan; % Eliminate Unsampled Pixels for Analysis
        directionMaps{i} = permute(directionMaps{i},[2 1 3 4]);
    end
    
    % Border Maps
    
    borderMaps = net.maps.borderMaps;
    for i = 2:length(net.act)
        borderMaps{i} = borderMaps{i}./repmat(permute(net.maps.borderMapsSampling,[1 2 4 3]),...
            [1 1 length(borderMaps{i}(1,1,:,1)) 1]);
        notSampled = isnan(borderMaps{i});
        borderMaps{i}(isnan(borderMaps{i})) = 0;
        
        for j = 1:length(borderMaps{i}(1,1,:,1))
            for k = 1:length(borderMaps{i}(1,1,1,:))
                borderMaps{i}(:,:,j,k) = imfilter(borderMaps{i}(:,:,j,k),kern,'same');
            end
        end
        
        borderMaps{i}(notSampled) = nan; % Eliminate Unsampled Pixels for Analysis
        borderMaps{i} = permute(borderMaps{i},[2 1 3 4]);
    end
end