function m = mkStressMap(ma,mb)
    ms = size(ma);
    nma = nan(ms);
    nmb = nan(ms);
    for k = 1:length(ma(1,1,:))
        nma(:,:,k) = imresize(ma(:,:,k),[ms(1:2)]);
        nmb(:,:,k) = imresize(mb(:,:,k),[ms(1:2)]);
    end
    m = sqrt(sum((nma-nmb).^2,3));
end