function plotSplitMapACorr(m,folder)
    gridness = nan(2,2,length(m{1}(1,1,:)));
    allGridness = repmat({[]},[5 8]);
    allWidth = repmat({[]},[5 8]);
    for k = 1:90 % 1:length(m{1}(1,1,:))
        
        module = floor(k./30)+1;
        
        figure
        set(gcf,'position',[50 50 300 length(m(:,1)).*150])
        acorrSize = 25;
        
        ac = repmat({[]},[1 length(m(:,1)).*2]);
        for mi = 1:length(m(:,1))
            
            cM = m{mi}(:,:,k);
            
%             if length(cM(1,:))>57
%                 splitAt = floor(length(cM(1,:)).*0.64);
%             else
                splitAt = floor(length(cM(1,:)).*0.5);
%             end
                
            ac{1+(mi-1).*2} = pvxcorr(cM(:,1:splitAt),cM(:,1:splitAt),[],20);
            ac{2+(mi-1).*2} = pvxcorr(cM(:,splitAt+1:end),cM(:,splitAt+1:end),[],20);
        end
%         gc = nan(1,4);
%         [gc(4) s1] = adaptive_gridness(ac{4});
%         [gc(3) s2] = adaptive_gridness(ac{3});
% %         [gc(1) s1] = adaptive_gridness(ac{1},nanmean([s1 s2]));
% %         [gc(2) s2] = adaptive_gridness(ac{2},nanmean([s1 s2]));
%         
%         [gc(1) s1] = adaptive_gridness(ac{1});
%         [gc(2) s2] = adaptive_gridness(ac{2});
            
        gc = nan(1,length(ac)); 
        for i = 1:length(ac)
            if ~isempty(ac{i})
                [gc(i)] = adaptive_gridness(ac{i});
            end
        end
        
        
        fs = nan(1,4);
        for i = 1:4
            
%             [x y] = meshgrid(1:length(ac{i}(:,1)),1:length(ac{i}(1,:)));
%             center = floor(size(ac{i})./2)+1;
%             d2c = sqrt((x-center(1)).^2+(y-center(2)).^2);
%             if i == 4
%                 mask = d2c<s1.*2.5;
%             elseif i == 3
%                 mask = d2c<s2.*2.5;
%             else
%                 mask = d2c<nanmean([s1 s2]).*2.5;
%             end
%             [a b c] = getPatches(maskAndCrop(ac{i},mask),0,[],0.2);
%             fs(i) = nansum(a(:)==1);
            [a b c] = getPatches(ac{i},0,[],0.1);
            fs(i) = nansum(a(:)==1);
        end
        
        for i = 1:length(gc)
            allGridness{module,i} = [allGridness{module,i}; gc(i)];
%             allWidth{module,i} = [allWidth{module,i}; (2.*sqrt(fs(i)./pi)).*2.5];
        end
        
        close all
        figure(1)
        set(gcf,'position',[50 50 800 200])
        subplot(1,2,1)
%         mkGraph([cat(1,allGridness{:,1}) cat(1,allGridness{:,2}) ...
%             cat(1,allGridness{:,3}) cat(1,allGridness{:,4})]);
        mkGraph(allGridness(1:3,:))
        subplot(1,2,2)
%         mkGraph([cat(1,allWidth{:,1}) cat(1,allWidth{:,2}) ...
%             cat(1,allWidth{:,3}) cat(1,allWidth{:,4})])
%         mkGraph(allWidth(1:2,:))
        drawnow
    end
    
%     outP = ['Plots/' folder '/SplitACorr/Cell_' num2str(k)];
%     saveFig(gcf,outP,'tiff');
%     outP = ['Plots/' folder '/SplitACorr/EPS/Cell_' num2str(k)];
%     saveFig(gcf,outP,'eps');
%     close all; drawnow;
%     
%     
%     plotable = [];
%     count = 0;
%     for i = 1:2
%         for j = 1:2
%             count = count+1;
%             plotable{count} = permute(gridness(i,j,:),[3 1 2]);
%         end
%     end
% 
%     mkGraph(plotable,[1:4])
%     set(gca,'ylim',[-1 1.2])
end