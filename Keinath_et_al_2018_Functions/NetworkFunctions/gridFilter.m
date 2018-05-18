function out = gridFilter(net,delta,theta)
    delta = [cos(theta) -sin(theta); sin(theta) cos(theta)]*delta;    
%     theta = cart2pol(delta(1),delta(2));
%     vel = sqrt(sum(delta.^2));
%     move = [-cos(theta).*vel sin(theta).*vel cos(theta).*vel -sin(theta).*vel];

    move = [-delta(1) delta(2) delta(1) -delta(2)];
    
    out = zeros(size(net.act{2}));
    for filt = 1:4
        % do Directional Filters
        out = out + real(ifft2(fft2(net.act{2}.*net.p.movementTypes{filt}) ...
            .*net.p.movementFilters{filt}));

        % Add Velocity Dependent Input
        out = out + max(net.p.movementTypes{filt}.*...
            (net.p.pop(2).input + move(filt).*net.p.specific.translationFactor),0); 
    end
end