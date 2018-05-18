function g = gridness(m)
    vals = nan(1,5);
    for r = 30:30:150
        tmp = imrotate(m,r,'nearest','crop');
        vals(r./30) = corr(tmp(~isnan(m)&~isnan(tmp)),m(~isnan(m)&~isnan(tmp)));
    end
    g = min(vals([2 4]))-max(vals([1 3 5]));
end