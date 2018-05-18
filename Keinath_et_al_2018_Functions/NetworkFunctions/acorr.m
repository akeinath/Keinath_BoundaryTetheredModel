function am = acorr(m,varargin)

    [a b c] = size(m);
    am = nan(2.*a-1,2.*b-1,c);
    for k = 1:length(m(1,1,:))
        forCorr = m(:,:,k);
        for xlag = round(a./2):round(3.*a./2)
            xa = [max(length(m(:,1,1))-xlag+1,1):...
                min(length(m(:,1,1)),2.*length(m(:,1,1))-xlag)];
            xb = [max(-length(m(:,1,1))+xlag+1,1):...
                min(length(m(:,1,1)),xlag)];
            for ylag = round(b./2):round(3.*b./2) % 1:length(am(1,:,1))
                ya = [max(length(m(1,:,1))-ylag+1,1):...
                    min(length(m(1,:,1)),2.*length(m(1,:,1))-ylag)];
                yb = [max(-length(m(1,:,1))+ylag+1,1):...
                    min(length(m(1,:,1)),ylag)];
                ind1 = false(size(m(:,:,k)));
                ind2 = false(size(m(:,:,k)));
                ind1(xa,ya) = true;
                ind2(xb,yb) = true;
                am(xlag,ylag,k) = corr(forCorr(ind1),forCorr(ind2));
            end
        end
    end
end