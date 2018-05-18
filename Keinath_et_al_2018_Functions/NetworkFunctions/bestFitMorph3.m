%%% Best Fit Morph with shifts
function popBest = bestFitMorph3(ref,maps,xMorph,yMorph)
    ref = permute(ref,[2 1 3]);
    maps = permute(maps,[2 1 3]);
    nC = length(maps(1,1,:));

    xr = [round(length(ref(:,1,1)).*min([xMorph yMorph]).*0.9):1:round(length(ref(:,1,1)).*max([xMorph yMorph]).*1.1)];
    yr = [round(length(ref(1,:,1)).*min([xMorph yMorph]).*0.9):1:round(length(ref(1,:,1)).*max([xMorph yMorph]).*1.1)];
    yr = yr((length(yr)./2)-4.5:(length(yr)./2)+4.5);
    
    popBest = nan(length(xr),length(yr));
    for xii = 1:length(xr)
        xi = xr(xii);
        parfor yii = 1:length(yr)
            yi = yr(yii);
            reRef = nan(xi,yi,nC);
            for k = 1:nC
                reRef(:,:,k) = imresize(ref(:,:,k),[xi yi]);
            end
            
            xc = pvxcorr2(reRef,maps,1/2);
            popBest(xii,yii) = nanmax(xc(:));
        end
    end
    
    [a b] = max(popBest,[],1);
    [a c] = max(popBest,[],2);
    popBest = ([mean(xr(b)) mean(yr(c)) ].*100)./size(ref(:,:,1));
end