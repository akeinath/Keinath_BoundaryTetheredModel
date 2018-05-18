function out = getBoundaryBoundingBox(p)
    lb = p.path.boundary.line; %Line Boundaries
    cb = p.path.boundary.ellipse; %elliptical Boundaries
    if ~isempty(lb)
        b1 = [[lb(:,1); lb(:,3)] [lb(:,2); lb(:,4)]];
    else
        b1 = [];
    end
    if ~isempty(cb)
        b2 = [[cb(:,1)+cb(:,3) cb(:,2)+cb(:,4)] ; [cb(:,1)-cb(:,3) cb(:,2)-cb(:,4)]];
    else
        b2 = [];
    end
    b = [b1; b2];
    out = [min(b) max(b)];
end