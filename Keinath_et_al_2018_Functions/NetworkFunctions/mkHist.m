function mkHist(d)
    groups = length(d(:,1));
    ticks = length(d(1,:));
    hold on
    step = 0.1;
    groupColor = [{[0.9 0.6 0.6]} {[0.6 0.6 0.9]} {[0.9 0.9 0.6]} {[0.6 0.9 0.6]}];
    for i = 1:groups
        for j = 1:ticks
            for s = -1:step:1-step
                x = [s s+step s+step s];
                count = mean(d{i,j}>=s & d{i,j}<=s+step);
                y = [j j j+count j+count];
                patch(x,y,groupColor{i},'edgecolor','k')
                hold on
            end
        end
    end
    set(gca,'ylim',[1 ticks+1]);
end