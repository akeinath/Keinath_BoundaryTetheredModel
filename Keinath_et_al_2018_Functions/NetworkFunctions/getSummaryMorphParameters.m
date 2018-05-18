function [fieldSize numFields pfr] = getSummaryMorphParameters(m,dm)
    p = params('specific');
    fieldSize = repmat({[]},size(m));
    numFields = repmat({[]},size(m));
    pfr = repmat({[]},size(m));
    mfr = repmat({[]},size(m));
    for i = 1:numel(m)
        fieldSize{i} = nan(length(m{i}(1,1,:)),1);
        numFields{i} = nan(length(m{i}(1,1,:)),1);
        pfr{i} = nan(length(m{i}(1,1,:)),1);
        for k = 1:length(m{i}(1,1,:))
            pfr{i}(k) = max(max(m{i}(:,:,k)));
            lm = getPatches(m{i}(:,:,k),p.minFieldSize,p.minFieldAct);
            fieldSize{i}(k) = sum(lm(:)>0).*p.mapBinSize;
            numFields{i}(k) = max(lm(:));
        end
    end
    
    figure(1)
    set(gcf,'position',[50 50 225.*2.25 225.*2.25]);
    subplot(2,2,1)
    mkDot(fieldSize,1:length(m(1,:)),false,true);
%     mkGraph(fieldSize,1:length(m(1,:)));
%     surf([1:0.25:2; 1:0.25:2],[1 1 1 1 1; 2 2 2 2 2],cellfun(@mean,fieldSize))
%     cellfun(@mean,fieldSize)
    ylabel('Field Size (cm^2)','fontname','arial','fontsize',8,'fontweight','bold');
    xlabel('X-Dim Morph','fontname','arial','fontsize',8,'fontweight','bold');
    set(gca,'xticklabel',[{'100%'} {'125%'} {'150%'} {'175%'} {'200%'}])
    set(gca,'fontname','arial','fontsize',8,'fontweight','bold')
   
    subplot(2,2,2)
%     newPlotable = repmat({[]},[2 3]);
%     for i = 1:2
%         for j = 1:3
%             if j~=3
%                 newPlotable{i,j} = mean(numFields{i}==(j-1));
%             else
%                 newPlotable{i,j} = mean(numFields{i}>=2);
%             end
%         end
%     end
%     mkGraph(numFields,[1:length(numFields(1,:))]);
    mkDot(numFields,[1:length(numFields(1,:))],false,true);
    xlabel('Environment x-axis','fontname','arial','fontsize',8,'fontweight','bold');
    ylabel('Number of fields','fontname','arial','fontsize',8,'fontweight','bold');
%     set(gca,'xticklabel',[{'0'} {'1'} {'2+'}])
    set(gca,'xticklabel',[{'100%'} {'125%'} {'150%'} {'175%'} {'200%'}])
    set(gca,'fontname','arial','fontsize',8,'fontweight','bold')
    
    subplot(2,2,3)
%     for i = length(pfr):-1:2
%         pfr{i} = pfr{i}-pfr{i-1};
%     end
    mkDot(pfr,1:length(m(1,:)),false,true);
%     mkGraph(pfr,1:length(m(1,:)));
%     surf([1:0.25:2; 1:0.25:2],[1 1 1 1 1; 2 2 2 2 2],cellfun(@mean,pfr))
    ylabel('Peak Firing Rate (Hz)','fontname','arial','fontsize',8,'fontweight','bold');
    xlabel('X-Dim Morph','fontname','arial','fontsize',8,'fontweight','bold');
    set(gca,'xticklabel',[{'100%'} {'125%'} {'150%'} {'175%'} {'200%'}])
    set(gca,'fontname','arial','fontsize',8,'fontweight','bold')
    
    if nargin>1
        subplot(2,2,4)
        isSplit = cat(2,numFields{:})>1;
        dms = getDirMod(dm);
        dms = cellfun(@times,dms,repmat({p.mapBinSize},size(dms)),'uniformoutput',false);
        mkDot(dms,1:length(dms(1,:)),false,true);
%         mkGraph(dms,1:length(dms(1,:)));
        for i = 1:length(dms)
            dms{i}(~isSplit(:,i)) = nan;
        end    
    %     mkDot(dms,1:length(dms(1,:)),true,[0.8 0.4 0.4; 0.8 0.3 0.3]);
        ylabel('Directional Map Peak Difference (cm)','fontname','arial','fontsize',8,'fontweight','bold');
        xlabel('X-Dim Morph','fontname','arial','fontsize',8,'fontweight','bold');
        set(gca,'xticklabel',[{'100%'} {'125%'} {'150%'} {'175%'} {'200%'}])
        set(gca,'fontname','arial','fontsize',8,'fontweight','bold')
    end
end