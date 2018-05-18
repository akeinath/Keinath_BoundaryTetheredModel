function ALL_VALS = plotBorderMapAlignmentComp(m,refs,folder)
    allVals = [];
    for k = 1:length(m{1}(1,1,:,1))
        
        vals = nan(4,4,4);
        for j = 1:length(m(1,:))
            for i = 1:length(m(:,1))
                for bmi = 1:4
                    if i==1 && j==1
                        continue
                    end
                    
                    bm = m{i,j}(:,:,k,bmi);
                    ref = refs{1,1}(:,:,k);

                    do_size = max([size(bm); size(ref)]);
                    comp_size = min([size(bm); size(ref)]);

                    do_dim = size(bm)~=size(ref);

                    if do_dim(1)
                        dim1_a = bm;
                        dim1_b = ref;

                        % top
                        dim1_a(end:do_size(1),:) = nan;
                        dim1_a(:,end:do_size(2)) = nan;
                        dim1_a = (circshift(dim1_a,[0 (do_size(2) - length(bm(1,:)))./2]));

                        dim1_b(end:do_size(1),:) = nan;
                        dim1_b(:,end:do_size(2)) = nan;
                        dim1_b = (circshift(dim1_b,[0 (do_size(2) - length(ref(1,:)))./2]));
                        
                        if length(ref(:,1))<length(bm(:,1))
                            tmp = dim1_b;
                            dim1_b = dim1_a;
                            dim1_a = tmp;
                        end
                        
                        isGood = ~(isnan(dim1_a)|isnan(dim1_b));
                        top = corr(dim1_a(isGood),dim1_b(isGood));

                        % bottom
                        dim1_a = (circshift(dim1_a,[(do_size(1) - comp_size(1)) 0]));
                        isGood = ~(isnan(dim1_a)|isnan(dim1_b));
                        bottom = corr(dim1_a(isGood),dim1_b(isGood));
                    else
                        top = nan;
                        bottom = nan;
                    end

                    if do_dim(2)
                        dim1_a = bm;
                        dim1_b = ref;

                        % left
                        dim1_a(end:do_size(1),:) = nan;
                        dim1_a(:,end:do_size(2)) = nan;
                        dim1_a = (circshift(dim1_a,[(do_size(1) - length(bm(:,1)))./2 0]));

                        dim1_b(end:do_size(1),:) = nan;
                        dim1_b(:,end:do_size(2)) = nan;
                        dim1_b = (circshift(dim1_b,[(do_size(1) - length(ref(:,1)))./2 0]));
                        
                        if length(ref(1,:))<length(bm(1,:))
                            tmp = dim1_b;
                            dim1_b = dim1_a;
                            dim1_a = tmp;
                        end
                        
                        isGood = ~(isnan(dim1_a)|isnan(dim1_b));
                        left = corr(dim1_a(isGood),dim1_b(isGood));
                        
                        % right
                        dim1_a = (circshift(dim1_a,[0 (do_size(2) - comp_size(2))]));
                        isGood = ~(isnan(dim1_a)|isnan(dim1_b));
                        right = corr(dim1_a(isGood),dim1_b(isGood));
                    else
                        left = nan;
                        right = nan;
                    end
                    vals(2.*(i-1)+j,:,bmi) = [top bottom left right];
                end
            end
        end
        
        allVals = cat(4,allVals,vals);
        
    end
    allVals(:,[3 4],[1 3],:) = nan;
    allVals(:,[1 2],[2 4],:) = nan;
    
    allVals = allVals(:,:,[2 1 4 3],:);
    
    ALL_VALS = allVals;
    
    allToPlot = [];
    for sim = 1:1000
    
        chooseCells = randperm(150);
        
        allVals = ALL_VALS(:,:,:,chooseCells(1:42));
        
        notFit = all(isnan(allVals),2);
        [a b] = nanmax(allVals,[],2);
        b(notFit) = nan;
        vals = permute(b,[3 1 4 2]);    
        plotable = {[]};
        for slot = 2:4
            for j = 1:4
                for i = 1:4
                    plotable{j,i,slot} = vals(i,slot,:)==j;
                    plotable{j,i,slot}(isnan(plotable{j,i,slot})) = [];
                end
            end
        end
        allToPlot = cat(4,allToPlot,cellfun(@nanmean,plotable));
    end
    
    finalPlot = {[]};
    for i = 1:4
        for j = 1:4
            for k = 1:4
                finalPlot{i,j,k} = permute(allToPlot(i,j,k,:),[1 4 2 3]);
            end
        end
    end
    
    close all
    figure(1)
    set(gcf,'position',[50 50 900 250])
    for slot = 2:4
        subplot(1,3,slot-1)
        mkGraph(finalPlot(:,:,slot),1:4,'sd');
        set(gca,'ylim',[0 1])
    end
    drawnow
end