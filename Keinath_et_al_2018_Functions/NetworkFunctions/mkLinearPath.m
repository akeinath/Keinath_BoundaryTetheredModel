function p = mkLinearPath(net)
    step = net.p.path.velocity.*net.p.ts;
    x = net.p.path.boundingBox(1)+step:step:net.p.path.boundingBox(3)-step;
    x = [x fliplr(x)];
    
    lapTime = length(x).*net.p.ts;
    numLaps = floor(net.p.path.length./lapTime);
    x = repmat(x,[1 numLaps]);
    y = zeros(1,length(x));
    
    p = [x; y];
end