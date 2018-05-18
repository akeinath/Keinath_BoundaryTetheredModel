function h = plotArrows(x,y,len,deg)
    h(1) = plot(x,y);
    hold on
    h(2) = plot([x(1) x(1)+cosd(deg).*len],[y(1) y(1)+sind(deg).*len]);
    h(3) = plot([x(1) x(1)-cosd(180-deg).*len],[y(1) y(1)-sind(180-deg).*len]);
    h(4) = plot([x(2) x(2)+cosd(180-deg).*len],[y(2) y(2)+sind(180-deg).*len]);
    h(5) = plot([x(2)-cosd(deg).*len x(2)],[y(2)-sind(deg).*len y(2)]);
end