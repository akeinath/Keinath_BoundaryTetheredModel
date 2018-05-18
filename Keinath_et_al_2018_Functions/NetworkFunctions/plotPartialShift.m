function plotPartialShift(m,folder)
    gridness = nan(2,2,length(m{1}(1,1,:)));
    allGridness = repmat({[]},[5 8]);
    allWidth = repmat({[]},[5 8]);
    aS = repmat({[]},[5 length(m(:,1))]);
    aX = repmat({[]},[5 length(m(:,1))]);
    aY = repmat({[]},[5 length(m(:,1))]);
    
    


    pvcmap = nan([size(m{1}(:,:,1)) 4]);
    for envI = 2:4
        for i = 1:length(m{1}(:,1,1))
            for j = 1:length(m{1}(1,:,1))
                a = permute(m{1}(i,j,:),[3 2 1]);
                b = permute(m{envI}(i,j,:),[3 2 1]);
                
                pvcmap(i,j,envI) = corr(a,b);
            end
        end
        h = figure(2);
        set(gcf,'position',[50 50 900 250])
        subplot(1,3,envI-1)
        imagesc(pvcmap(:,:,envI))
        alpha(double(~isnan(pvcmap(:,:,envI))))
        colormap('jet')
        axis equal
        set(gca,'ydir','normal');
        axis off
        caxis([0.3 1])
    end
    
    outP = ['Plots/' folder '/PopulationVectorCorrelation'];
    saveFig(h,outP,'tiff');
    outP = ['Plots/' folder '/PopulationVectorCorrelation'];
    saveFig(h,outP,'pdf');
    close(h);
    
    figure(3)
    set(gcf,'position',[50 50 250 500])
%     subplot(2,1,1)
%     mkGraph(pvcmap(:,:,4)')
    plot(nanmedian(pvcmap(:,:,4),1))
    set(gca,'ylim',[0.3 1])
%     subplot(2,1,2)
%     plot(nanmedian(pvcmap(:,:,4),2))
%     set(gca,'ylim',[0.3 1])
    
    %
%     for k = 1:length(m{1}(1,1,:))
%         
%         module = floor((k-1)./30)+1;
%         
%         cM = nan([size(m{1}(:,:,1)) length(m(:,1))]);
%         pC = repmat({[]},[1 length(m(:,1))]);
%         for mi = 1:length(m(:,1))
%             cM(:,:,mi) = m{mi}(:,:,k);
%             tmp = m{mi}(:,:,k);
%             [a b c] = getPatches(m{mi}(:,:,k),0,[],0.2);
%             for i = 1:nanmax(a(:))
%                 [x y] = find(a==i & tmp == nanmax(tmp(a==i)));
%                 c(i,:) = [nanmedian(y) nanmedian(x)];
%             end            
%             pC{mi} = c;
%         end
%         
%         for pci = 2:length(pC)
% %             sameEnvDist = sqrt(bsxfun(@minus,pC{1}(:,1),pC{1}(:,1)').^2 + ...
% %                 bsxfun(@minus,pC{1}(:,2),pC{1}(:,2)').^2);
% %             sameEnvDist(logical(eye(length(sameEnvDist)))) = nan;
% %             maxDist = nanmin(sameEnvDist,[],2);
%             
%             minShift = nanmin(sqrt(bsxfun(@minus,pC{pci}(:,1),pC{1}(:,1)').^2 + ...
%                 bsxfun(@minus,pC{pci}(:,2),pC{1}(:,2)').^2),[],2);
%             
% %             minShift(minShift)
%             
% %             isBad = minShift > maxDist;
% 
%             aS{module,pci} = [aS{module,pci}; minShift.*2.5];
%             aX{module,pci} = [aX{module,pci}; pC{pci}(:,1)];
%             aY{module,pci} = [aY{module,pci}; pC{pci}(:,2)];
%         end
%         
%     end
% 
%     
%     
%     for envI = 2:4
%         isBad = isnan(m{1}(:,:,1)) | isnan(m{envI}(:,:,1));
%         if length(aX(1,:)) < envI
%             continue
%         end
%         
%         x = cat(1,aX{:,envI});
%         y = cat(1,aY{:,envI});
%         s = cat(1,aS{:,envI});
%         
%         elim = isBad(sub2ind(size(isBad),y,x));
%         x(elim) = [];
%         y(elim) = [];
%         s(elim) = [];
%         
%         x = ceil(x./6);
%         y = ceil(y./6);
%         
% %         x(s>30) = [];
% %         y(s>30) = [];
% %         s(s>30) = [];
%         
%         
%         shiftMap = nan(nanmax(x),nanmax(y));
%         for xi = unique(x)'
%             for yi = unique(y)'
%                 shiftMap(xi,yi) = nanmedian(s(xi==x&yi==y));
%             end
%         end
%         
%         isBad2 = isnan(shiftMap);
%         shiftMap(isBad2) = 0;
%         
%         figure(2)
%         set(gcf,'position',[50 50 900 250])
%         subplot(1,3,envI-1)
% %         [fspecial('gaussian',[11 11],0.75)]
% %         imagesc(imfilter(shiftMap',ones(3).*1./9,'same','replicate'))
%         imagesc(shiftMap')
%         alpha(double(~isBad2)')
%         colormap('jet')
%         axis equal
%         set(gca,'ydir','normal');
%         axis off
%         caxis([0 nanmax(caxis)])
%     end
%     
%     
%     
%     
%     
% %     mkGraph(aS)
% %     
%     space = 6;
%     clear plotable
%     for env = 2:length(pC)
%         figure(1)
%         set(gcf,'position',[50 50 1200 300])
%         subplot(1,3,env-1)
%         
%         tS = cat(1,aS{:,env});
%         tX = cat(1,aX{:,env});
%         tY = cat(1,aY{:,env});
%         
%         isBad = isnan(m{1}(:,:,1)) | isnan(m{envI}(:,:,1));
%         elim = isBad(sub2ind(size(isBad),tY,tX));
%         tX(elim) = [];
%         tY(elim) = [];
%         tS(elim) = [];
% 
%         
%         
%         for i = 0:space:72
%             plotable{[i./space]+1} = (tS(tX>=i & tX<i+space));
%         end
%         
% %         plotable = repmat({[]},[5 ceil(60./space)]);
% %         for module = 1:5
% %             for i = 0:space:60
% %                 plotable{module,[i./space]+1} = nanmedian(aS{module,env}(aX{module,env}>=i & aX{module,env}<i+space));
% %             end
% %         end
%         mkGraph(plotable(:,1:end-1))
%         set(gca,'ylim',[0 20]);
%     end
    
end