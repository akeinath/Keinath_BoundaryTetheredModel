function vals = simGridRescaling(scale,orientation,ENVIRONMENT_SIZE, rescaling)
    numCells = 15;
    BIN_SIZE = 1; % cm 2 pixel conversion bin size
%     ENVIRONMENT_SIZE = [150 150]; % Familiar environment size in cm
    phase = nan(2,numCells);
    familiar_map = nan([ceil(ENVIRONMENT_SIZE./BIN_SIZE)+1 numCells]);
    for k = 1:numCells
        phase(:,k) = rand(2,1).*scale;
        familiar_map(:,:,k) = mkGrid(scale./BIN_SIZE,deg2rad(orientation),phase(1,k)./BIN_SIZE,phase(2,k)./BIN_SIZE,ceil(ENVIRONMENT_SIZE./BIN_SIZE));
    end
    
%     rescaling = [-50 0]; % amount of rescaling in cm
    
    
    side_maps = nan([fliplr(1+ceil((ENVIRONMENT_SIZE+rescaling)./BIN_SIZE)) abs(rescaling(1))+1 abs(rescaling(2))+1 numCells]);
    for k = 1:numCells
        for i = 0:BIN_SIZE:abs(rescaling(1))
            for j = 0:BIN_SIZE:abs(rescaling(2))
                side_maps(:,:,i+1,j+1,k) = mkGrid(scale./BIN_SIZE,deg2rad(orientation),(phase(1,k)+sign(rescaling(1)).*i)./BIN_SIZE,...
                    (phase(2,k)+sign(rescaling(2)).*j)./BIN_SIZE,ceil((ENVIRONMENT_SIZE+rescaling)./BIN_SIZE));
            end
        end
    end
%     
%     %%% Convolve maps with distance!!!
%     for k = 1:numCells
% 
%         mapsXsamp = nan([size(maps(:,:,1,1)) ENVIRONMENT_SIZE+rescaling+1]);
%         for i = 0:BIN_SIZE:ENVIRONMENT_SIZE(1)+rescaling(1)
%             for j = [0 ENVIRONMENT_SIZE(2)+rescaling(2)]
%                 
%                 
%                 mapsXsamp(:,:,i,j) = 1;
%             end        
%         end
%     end
    
    
    
% %     tmp = cat(3,repmat(maps(:,:,1,:,:),[1 1 abs(rescaling)+1 1 1]),repmat(maps(:,:,end,:,:),[1 1 abs(rescaling)+1 1 1]),...
% %         maps,maps,maps,maps,maps,maps,maps,maps);
% %     
% %     rescaled_map = permute(nanmean(tmp,3),[1 2 5 3 4]);
%     
% %     
% 
%     rescaled_map = permute(nanmean(nanmean(maps,3),4),[1 2 5 3 4]);

    bmaps = nan([fliplr(1+ceil((ENVIRONMENT_SIZE+rescaling)./BIN_SIZE)) 2 k]);
    for k = 1:numCells
        count = 0;
        for i = [0 abs(rescaling(1))]
            count = count+1;
            bmaps(:,:,count,k) = mkGrid(scale./BIN_SIZE,deg2rad(orientation),(phase(1,k)+sign(rescaling(1)).*i)./BIN_SIZE,...
                 (phase(2,k)+sign(rescaling(2)).*0)./BIN_SIZE,ceil((ENVIRONMENT_SIZE+rescaling)./BIN_SIZE));
        end
    end
    
    weighting = [length(bmaps(:,1,1,1,1)) length(bmaps(1,:,1,1,1))]./(max(size(bmaps(:,:,1,1,1))));
    d2b = fliplr(repmat(0:BIN_SIZE:length(bmaps(1,:,1,1,1))-1,[length(bmaps(:,1,1)) 1,1,1]));
    d2b = weighting(1).*d2b./sum(d2b(:));
    bmaps = permute(bmaps,[1 2 4 3]);
    
    rescaled_map = bsxfun(@times,bmaps(:,:,:,1),d2b) + bsxfun(@times,bmaps(:,:,:,2),fliplr(d2b)); 
    
    side_maps = nanmean(side_maps,3);
    d2b = flipud(repmat([0:BIN_SIZE:length(bmaps(:,1,1,1,1))-1]',[1 length(bmaps(1,:,1,1,1))]));
    d2b = weighting(2).*d2b./sum(d2b(:));
    side_maps = permute(side_maps,[1 2 5 3 4]);
    rescaled_map = rescaled_map+bsxfun(@times,side_maps,d2b) + bsxfun(@times,side_maps,flipud(d2b)); 
    
    vals = bestFitMorph2(familiar_map,rescaled_map);
end