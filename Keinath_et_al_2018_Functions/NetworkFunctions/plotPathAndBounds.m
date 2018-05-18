function plotPathAndBounds(path,net,lastBorder)
    colors = [0.5 0.5 0.5; 0.2 0.2 0.9; 0.5 0.5 0.5; 0.9 0.2 0.2];

    oLB = lastBorder;
    
    figure(1)
    set(gcf,'position',[50 50 300 300])
    for i = [1 3 2 4]
        while any(lastBorder==i)
            start = find(lastBorder==i,1,'first');
            stop = find(lastBorder(start+1:end)~=i,1,'first');
            if isempty(stop)
                stop = length(lastBorder)-start;
            end
            plot(path(1,start:start+stop),path(2,start:start+stop),'color',colors(i,:),'linestyle','-')
            lastBorder(start:start+stop) = 0;
            hold on
        end
    end
    hold on
    plot(path(1,1),path(2,1),'marker','o','color','k','linewidth',1.5,'markersize',6,'markerfacecolor','k');
    plot(path(1,end),path(2,end),'marker','x','color','k','linewidth',1.5,'markersize',10);
    
    if ~isempty(net.p.path.boundary.line)
        lb = net.p.path.boundary.line;
        plot(lb(:,[1 3])',lb(:,[2 4])','color','k','linewidth',3)
    end
    
    if ~isempty(net.p.path.boundary.ellipse)
        approx = 0:2*pi/360:2*pi;
        
        for i = 1:length(net.p.path.boundary.ellipse(:,1))
            plot(net.p.path.boundary.ellipse(i,1)+net.p.path.boundary.ellipse(i,3).*cos(approx),...
                net.p.path.boundary.ellipse(i,2)+net.p.path.boundary.ellipse(i,4).*sin(approx),'color','k','linewidth',3)
        end
    end
    axis equal
    axis off
end