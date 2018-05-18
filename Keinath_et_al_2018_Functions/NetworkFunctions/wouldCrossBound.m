function tf = wouldCrossBound(a,b,net)
    tf = false;
%     
%     if all(a==b)
%         % if both positions are the same, then would not cross
%         return
%     end
    
    % Check line boundaries
    if ~isempty(net.p.path.boundary.line)
        tmp = lineSegmentIntersect(net.p.path.boundary.line,[a' b']);
        if any(tmp.intAdjacencyMatrix)
            tf = true;
            return
        end
    end
    
    % Check ellipse boundaries
    if ~isempty(net.p.path.boundary.ellipse)
        for i = 1:length(net.p.path.boundary.ellipse(:,1))
            if (sideOfEllipse(a,net.p.path.boundary.ellipse(i,:))<=1) ~= ...
                    (sideOfEllipse(b,net.p.path.boundary.ellipse(i,:))<=1)
                tf = true;
                return
            end
        end
        
%         tmp = inpolygon([a(1); b(1)],[a(2); b(2)], ...
%             net.p.path.boundary.ellipsePoints(:,1,1),net.p.path.boundary.ellipsePoints(:,2,1));
%         if tmp(1)~=tmp(2)
%             tf = true;
%             return
%         end
    end
end

function s =  sideOfEllipse(a,ellipse)
    s = (((a(1) - ellipse(1)).^2)./(ellipse(3).^2)) + ...
        (((a(2) - ellipse(2)).^2)./(ellipse(4).^2));
end