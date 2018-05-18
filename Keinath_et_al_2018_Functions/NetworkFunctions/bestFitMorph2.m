function [cellBest popBest] = bestFitMorph2(ref,maps,xMorph,yMorph)
    ref = permute(ref,[2 1 3]);
    maps = permute(maps,[2 1 3]);
    nC = length(maps(1,1,:));

%     xr = [round(length(ref(:,1,1)).*min(xMorph)):2:round(length(ref(:,1,1)).*max(xMorph))];
%     yr = [round(length(ref(1,:,1)).*min(yMorph)):2:round(length(ref(1,:,1)).*max(yMorph))];
    
    xr = min(length(maps(:,1,1)),length(ref(:,1,1))):2:max(length(maps(:,1,1)),length(ref(:,1,1)));
    yr = min(length(maps(1,:,1)),length(ref(1,:,1))):2:max(length(maps(1,:,1)),length(ref(1,:,1)));

    xr = [xr(1)-4 xr(1)-2 xr xr(end)+2 xr(end)+4];
%     yr = xr;
    
    cellBest = nan(length(xr),length(yr),nC,3);
    popBest = nan(length(xr),length(yr));
    
    for xi = xr
        for yi = yr
            reRef = nan(xi,yi,nC);
            for k = 1:nC
                reRef(:,:,k) = imresize(ref(:,:,k),[xi yi]);
            end
            
            fullSize = min([size(reRef(:,:,1)); size(maps(:,:,1))]);
            
            %%% Center
%             pieceSize = floor(min([size(reRef(:,:,1)); size(maps(:,:,1))])./2);
%             rCenter = ceil(size(reRef(:,:,1))./2);
%             mCenter = ceil(size(maps(:,:,1))./2);
%             
%             tmpRef = reRef([rCenter(1)-pieceSize(1)]:[rCenter(1)+pieceSize(1)],...
%                 [rCenter(2)-pieceSize(2)]:[rCenter(2)+pieceSize(2)],:);
%             
%             tmpMaps = maps([mCenter(1)-pieceSize(1)]:[mCenter(1)+pieceSize(1)],...
%                 [mCenter(2)-pieceSize(2)]:[mCenter(2)+pieceSize(2)],:);
%             
%             mask = ~(isnan(tmpRef)|isnan(tmpMaps));
%             centerCorr= corr(tmpRef(mask),tmpMaps(mask));
            
%             %%% Top
            blah = [floor(size(reRef,2)./2)+1-floor(fullSize(2)./2)
                floor(size(reRef,2)./2)+1+floor(fullSize(2)./2)];
            tmpRef = reRef(1:fullSize(1),blah(1):blah(2),:);
            blah = [floor(size(maps,2)./2)+1-floor(fullSize(2)./2)
                floor(size(maps,2)./2)+1+floor(fullSize(2)./2)];
            tmpMaps = maps(1:fullSize(1),blah(1):blah(2),:);
            mask = ~(isnan(tmpRef)|isnan(tmpMaps));
            topCorr= corr(tmpRef(mask),tmpMaps(mask));
            
            for k = 1:nC
                a = tmpRef(:,:,k);
                b = tmpMaps(:,:,k);
                cellBest(xi==xr,yi==yr,k,1) = corr(a(mask(:,:,k)),b(mask(:,:,k)));
            end

%             
%             %%% Bottom
            blah = [floor(size(reRef,2)./2)+1-floor(fullSize(2)./2)
                floor(size(reRef,2)./2)+1+floor(fullSize(2)./2)];
            tmpRef = reRef(end-fullSize(1)+1:end,blah(1):blah(2),:);
            blah = [floor(size(maps,2)./2)+1-floor(fullSize(2)./2)
                floor(size(maps,2)./2)+1+floor(fullSize(2)./2)];
            tmpMaps = maps(end-fullSize(1)+1:end,blah(1):blah(2),:);
            
            mask = ~(isnan(tmpRef)|isnan(tmpMaps));
            bottomCorr= corr(tmpRef(mask),tmpMaps(mask));
            
            for k = 1:nC
                a = tmpRef(:,:,k);
                b = tmpMaps(:,:,k);
                cellBest(xi==xr,yi==yr,k,2) = corr(a(mask(:,:,k)),b(mask(:,:,k)));
            end
            
            popBest(xi==xr,yi==yr) = max([topCorr bottomCorr]);
%             popBest(xi==xr,yi==yr) = max([topCorr bottomCorr]);
%             popBest(xi==xr,yi==yr) = centerCorr;
            
        end
    end
    
    [a b] = max(popBest,[],1);
    [a c] = max(popBest,[],2);
    popBest = ([mean(xr(b)) mean(yr(c)) ].*100)./size(ref(:,:,1));
    
    cellBest = nanmax(cellBest,[],4);
%     [a b] = nanmax(cellBest(:,:,:,1),[],1);
%     cellBest = permute((xr(b).*100)./length(ref(:,1,1)),[3 2 1]);

    ind = [];
    for k = 1:length(cellBest(1,1,:))
        if nanmax(nanmax(cellBest(:,:,k))) < 0.5
            
        end
        [x y] = find(cellBest(:,:,k)==nanmax(nanmax(cellBest(:,:,k))));
        ind = [ind; 100.*[xr(x(1)) yr(y(1))]./size(ref(:,:,1))];
    end
%     cellBest = permute((xr(b).*100)./length(ref(:,1,1)),[3 2 1]);
    cellBest = ind;
end

















