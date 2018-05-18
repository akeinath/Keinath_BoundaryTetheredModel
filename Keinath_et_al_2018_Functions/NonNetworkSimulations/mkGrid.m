function m = mkGrid(s,o,p1,p2,lm)
    [x y] = meshgrid(0:lm(1),0:lm(2));
    m = zeros([size(x) 1]);
    for k = 0:2
        m = m+cos(4.*pi.*(1./(sqrt(3).*s)).* ...
            [(x-p1).*sin((k*(pi/3)+o)) + (y-p2).*cos((k*(pi/3)+o))]);
    end
%     m = exp(0.25*(m./3)+2);
%     m = m+2;
    m(m<0) = 0;
end