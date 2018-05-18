function path = mkPath(net)
    
    samplingFrequency = 0.001;
    velocity_SD = 1; %cm/sec
    velocity_Bounds = [0 40].*samplingFrequency; %cm/sec
    
    HD_SD = 1500;
    pathLength = net.p.path.length./samplingFrequency;
    
    path = nan(2,pathLength);
    path(:,1) = net.p.path.init';
    pos = net.p.path.init;
    
    vel = 0;
    HD = rand.*2.*pi;
    
    allVel = nan(1,pathLength);
    for i = 2:pathLength
        
        vel = min(max(vel + (randn.*velocity_SD.*samplingFrequency),velocity_Bounds(1)),velocity_Bounds(2));
        HD = HD + randn.*HD_SD.*samplingFrequency;
        if isfield(net.p.path.boundary,'max_radius')
            outRange = sqrt(sum([pos+[sind(HD) cosd(HD)].*vel].^2))>net.p.path.boundary.max_radius;
        else
            outRange = false;
        end
        while outRange || wouldCrossBound(pos',[pos+[sind(HD) cosd(HD)].*vel]',net)
            HD = HD+randn.*HD_SD.*samplingFrequency;
            if isfield(net.p.path.boundary,'max_radius')
                outRange = sqrt(sum([pos+[sind(HD) cosd(HD)].*vel].^2))>net.p.path.boundary.max_radius;
            end
        end
        
        pos = pos+[sind(HD) cosd(HD)].*vel;
        path(:,i) = pos';
        allVel(i) = vel;
    end
    
    path = path(:,1:net.p.ts./samplingFrequency:end);    
%     hist(allVel./samplingFrequency,[velocity_Bounds(1):range(velocity_Bounds)./10:velocity_Bounds(2)]./samplingFrequency)
end