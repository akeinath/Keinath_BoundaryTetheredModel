function am = pvxcorr(m,varargin)

    [a b c] = size(m);
    am = nan(2.*a-1,2.*b-1);
    for xlag = 1:length(am(:,1,1))
        xa = [max(length(m(:,1,1))-xlag+1,1):...
            min(length(m(:,1,1)),2.*length(m(:,1,1))-xlag)];
        xb = [max(-length(m(:,1,1))+xlag+1,1):...
            min(length(m(:,1,1)),xlag)];
        for ylag = 1:length(am(1,:,1))
            ya = [max(length(m(1,:,1))-ylag+1,1):...
                min(length(m(1,:,1)),2.*length(m(1,:,1))-ylag)];
            yb = [max(-length(m(1,:,1))+ylag+1,1):...
                min(length(m(1,:,1)),ylag)];
            ind1 = false(size(m(:,:,1)));
            ind2 = false(size(m(:,:,1)));
            ind1(xa,ya) = true;
            ind2(xb,yb) = true;
            am(xlag,ylag) = corr(m(repmat(ind1,[1 1 length(m(1,1,:))])),...
                m(repmat(ind2,[1 1 length(m(1,1,:))])));
        end
    end
end