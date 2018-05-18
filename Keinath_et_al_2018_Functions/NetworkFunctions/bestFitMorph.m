function [best] = bestFitMorph(refMap,allMaps,xMorph,yMorph)

    %%% Range to search for fit
    
    xr = min(length(allMaps(:,1,1)),length(refMap(:,1,1))):2:max(length(allMaps(:,1,1)),length(refMap(:,1,1)));
    yr = min(length(allMaps(1,:,1)),length(refMap(1,:,1))):2:max(length(allMaps(1,:,1)),length(refMap(1,:,1)));

    yr = [yr(1)-4 yr(1)-2 yr yr(end)+2 yr(end)+4];
    xr = yr;
    
%     best = nan(length(allMaps(1,1,:)),2);
    
    %%% Best Fit Stretch for Individual Maps
    for k = 1:length(allMaps(1,1,:))
        tmpA = allMaps(:,:,k);
        tmpBest = nan(length(xr),length(yr));
        for xi = xr
            for yi = yr
                reR = imresize(refMap(:,:,k),[xi yi]);
                
                
                dxy = [floor((length(reR(:,1))-min(length(tmpA(:,1)),length(reR(:,1))))./2) ...
                    floor((length(reR(1,:))-min(length(tmpA(1,:)),length(reR(1,:))))./2)];
                
                tmpR2 = reR(dxy(1)+1:end-dxy(1),dxy(2)+1:end-dxy(2));
                
                dxy = [floor((length(tmpA(:,1))-min(length(tmpA(:,1)),length(reR(:,1))))./2) ...
                    floor((length(tmpA(1,:))-min(length(tmpA(1,:)),length(reR(1,:))))./2)];
                tmpA2 = tmpA(dxy(1)+1:end-dxy(1),dxy(2)+1:end-dxy(2));
                
                xc = pvxcorr(tmpR2,tmpA2,[],20); % ceil([min([size(tmpR2); size(tmpA2)])]./2)
                [a b c] = getPatches(xc,0,[],0.3);
                
                tmpBest(xi==xr,yi==yr) = nanmax(xc(a==1));
                
%                 for dx = -driftAllowance:driftAllowance
%                     for dy = -driftAllowance:driftAllowance
%                         driftR2 = tmpR2(max(dx+1,1):min(length(tmpR2(:,1,1))+dx,length(tmpR2(:,1,1))),...
%                             max(dy+1,1):min(length(tmpR2(1,:,1))+dy,length(tmpR2(1,:,1))),:);
% 
%                         driftA2 = tmpA2(max(-dx+1,1):min(length(tmpR2(:,1,1))-dx,length(tmpR2(:,1,1))),...
%                             max(-dy+1,1):min(length(tmpR2(1,:,1))-dy,length(tmpR2(1,:,1))),:);
% 
%                         driftA3 = tmpA3(max(-dx+1,1):min(length(tmpR2(:,1,1))-dx,length(tmpR2(:,1,1))),...
%                             max(-dy+1,1):min(length(tmpR2(1,:,1))-dy,length(tmpR2(1,:,1))),:);
% 
%                         cVals(dx==-driftAllowance:driftAllowance,...
%                             dy==-driftAllowance:driftAllowance,:) = ...
%                             [corr(driftR2(~isnan(driftR2)&~isnan(driftA2)),driftA2(~isnan(driftR2)&~isnan(driftA2))) ...
%                             corr(driftR2(~isnan(driftR2)&~isnan(driftA3)),driftA3(~isnan(driftR2)&~isnan(driftA3)))];
%                     end
%                 end

%                 tmpBest(xi==xr,yi==yr) = max(cVals(:));
            end
        end
        
        [x y] = find(max(max(tmpBest))==tmpBest);
        best(k,:) = [mean(xr(x))./length(refMap(:,1,1)) mean(yr(y))./length(refMap(1,:,1))].*100;
    end
% %     
%     %%% Best Fit Stretch for Individual Maps
%     tmpBest = nan(length(xr),length(yr));
%     for xi = xr
%         for yi = yr
%             reR = nan([xi yi length(refMap(1,1,:))]);
%             for k = 1:length(refMap(1,1,:))
%                 reR(:,:,k) = imresize(refMap(:,:,k),[xi yi]);
%             end
%             
% 
%             tmpR2 = reR(1:min(length(allMaps(:,1,1)),length(reR(:,1,1))),...
%                 1:min(length(allMaps(1,:,1)),length(reR(1,:,1))),:);
%             
%             % Bottom Aligned
%             tmpA2 = allMaps(1:min(length(allMaps(:,1,1)),length(reR(:,1,1))),...
%                 1:min(length(allMaps(1,:,1)),length(reR(1,:,1))),:);
%             
%             % Top Aligned
%             tmpA3 = allMaps(end-min(length(allMaps(:,1,1)),length(reR(:,1,1)))+1:end,...
%                 end-min(length(allMaps(1,:,1)),length(reR(1,:,1)))+1:end,:);
%             
%             % Center Aligned
%             
% %             cVals = nan(driftAllowance.*2-1,driftAllowance.*2-1,2);
%             for dx = -driftAllowance:driftAllowance
%                 for dy = -driftAllowance:driftAllowance
%                     driftR2 = tmpR2(max(dx+1,1):min(length(tmpR2(:,1,1))+dx,length(tmpR2(:,1,1))),...
%                         max(dy+1,1):min(length(tmpR2(1,:,1))+dy,length(tmpR2(1,:,1))),:);
% 
%                     driftA2 = tmpA2(max(-dx+1,1):min(length(tmpR2(:,1,1))-dx,length(tmpR2(:,1,1))),...
%                         max(-dy+1,1):min(length(tmpR2(1,:,1))-dy,length(tmpR2(1,:,1))),:);
% 
%                     driftA3 = tmpA3(max(-dx+1,1):min(length(tmpR2(:,1,1))-dx,length(tmpR2(:,1,1))),...
%                         max(-dy+1,1):min(length(tmpR2(1,:,1))-dy,length(tmpR2(1,:,1))),:);
% 
%                     cVals(dx==-driftAllowance:driftAllowance,...
%                         dy==-driftAllowance:driftAllowance,:) = ...
%                         [corr(driftR2(~isnan(driftR2)&~isnan(driftA2)),driftA2(~isnan(driftR2)&~isnan(driftA2))) ...
%                         corr(driftR2(~isnan(driftR2)&~isnan(driftA3)),driftA3(~isnan(driftR2)&~isnan(driftA3)))];
%                 end
%             end
%             
%             tmpBest(xi==xr,yi==yr) = max(cVals(:));
%         end
%     end
% 
%     [x y] = find(max(max(tmpBest))==tmpBest);
%     bestPop = [mean(xr(x))./length(refMap(:,1,1)) mean(yr(y))./length(refMap(1,:,1))].*100;
end