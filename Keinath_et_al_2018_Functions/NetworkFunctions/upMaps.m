function upnet = upMaps(net,p,theta,lastBorder)
    thetaBin = floor(((mod(theta,2*pi)./(2.*pi)).*360)./net.p.specific.HDBinSize)+1;
    dbsize = 180;
    dirBin = floor(mod((((mod(theta,2*pi)./(2.*pi)).*360)-dbsize/2),360)./dbsize)+1;
    
    
    
    upnet = net;
    bP = floor([p-net.p.path.boundingBox(1:2)']./net.p.specific.mapBinSize)+1;
    for i = 1:length(net.act)
        if net.p.spiking
            if size(net.spikes{i}(net.p.pop(i).store),2)>1
                
                % Regular Map
                upnet.maps.act{i}(bP(1),bP(2),:) = net.maps.act{i}(bP(1),bP(2),:) + ...
                    permute(net.spikes{i}(net.p.pop(i).store),[1 3 2]);
                
                % Head Directions Tuning Curves
                upnet.maps.HD{i}(:,thetaBin) = net.maps.HD{i}(:,thetaBin) + ...
                    permute(net.spikes{i}(net.p.pop(i).store),[2 3 1]);
                
                % NESW Maps
                upnet.maps.directionMaps{i}(bP(1),bP(2),:,dirBin) = ...
                    net.maps.directionMaps{i}(bP(1),bP(2),:,dirBin) + ...
                    permute(net.spikes{i}(net.p.pop(i).store),[1 3 2]);
                
                % Border Maps
                upnet.maps.borderMaps{i}(bP(1),bP(2),:,lastBorder) = ...
                    net.maps.borderMaps{i}(bP(1),bP(2),:,lastBorder) + ...
                    permute(net.spikes{i}(net.p.pop(i).store),[1 3 2]);
            else
                upnet.maps.act{i}(bP(1),bP(2),:) = net.maps.act{i}(bP(1),bP(2),:) + ...
                    permute(net.spikes{i}(net.p.pop(i).store),[2 3 1]);
                
                upnet.maps.HD{i}(:,thetaBin) = net.maps.HD{i}(:,thetaBin) + ...
                    permute(net.spikes{i}(net.p.pop(i).store),[1 3 2]);
                
                upnet.maps.directionMaps{i}(bP(1),bP(2),:,dirBin) = ...
                    net.maps.directionMaps{i}(bP(1),bP(2),:,dirBin) + ...
                    permute(net.spikes{i}(net.p.pop(i).store),[2 3 1]);
                
                upnet.maps.borderMaps{i}(bP(1),bP(2),:,lastBorder) = ...
                    net.maps.borderMaps{i}(bP(1),bP(2),:,lastBorder) + ...
                    permute(net.spikes{i}(net.p.pop(i).store),[2 3 1]);
            end
        else
            if size(net.act{i}(net.p.pop(i).store),2)>1
                upnet.maps.act{i}(bP(1),bP(2),:) = net.maps.act{i}(bP(1),bP(2),:) + ...
                    permute(net.act{i}(net.p.pop(i).store),[1 3 2]);
                
                upnet.maps.HD{i}(:,thetaBin) = net.maps.HD{i}(:,thetaBin) + ...
                    permute(net.act{i}(net.p.pop(i).store),[2 3 1]);
                
                upnet.maps.directionMaps{i}(bP(1),bP(2),:,dirBin) = ...
                    net.maps.directionMaps{i}(bP(1),bP(2),:,dirBin) + ...
                    permute(net.act{i}(net.p.pop(i).store),[1 3 2]);
                
                upnet.maps.borderMaps{i}(bP(1),bP(2),:,lastBorder) = ...
                    net.maps.borderMaps{i}(bP(1),bP(2),:,lastBorder) + ...
                    permute(net.act{i}(net.p.pop(i).store),[1 3 2]);
            else
                upnet.maps.act{i}(bP(1),bP(2),:) = net.maps.act{i}(bP(1),bP(2),:) + ...
                    permute(net.act{i}(net.p.pop(i).store),[2 3 1]);
                
                upnet.maps.HD{i}(:,thetaBin) = net.maps.HD{i}(:,thetaBin) + ...
                    permute(net.act{i}(net.p.pop(i).store),[1 3 2]);
                
                upnet.maps.directionMaps{i}(bP(1),bP(2),:,dirBin) = ...
                    net.maps.directionMaps{i}(bP(1),bP(2),:,dirBin) + ...
                    permute(net.act{i}(net.p.pop(i).store),[2 3 1]);
                
                upnet.maps.borderMaps{i}(bP(1),bP(2),:,lastBorder) = ...
                    net.maps.borderMaps{i}(bP(1),bP(2),:,lastBorder) + ...
                    permute(net.act{i}(net.p.pop(i).store),[2 3 1]);
            end
        end
    end
    upnet.maps.directionMapsSampling(bP(1),bP(2),dirBin) = net.maps.directionMapsSampling(bP(1),bP(2),dirBin)+net.p.ts;
    upnet.maps.borderMapsSampling(bP(1),bP(2),lastBorder) = net.maps.borderMapsSampling(bP(1),bP(2),lastBorder)+net.p.ts;
    upnet.maps.sampling(bP(1),bP(2)) = net.maps.sampling(bP(1),bP(2))+net.p.ts;
    upnet.maps.HDsampling(thetaBin) = net.maps.HDsampling(thetaBin)+net.p.ts;
end