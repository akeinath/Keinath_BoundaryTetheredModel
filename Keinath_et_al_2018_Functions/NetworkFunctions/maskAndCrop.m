function ac = maskAndCrop(ac,mask)
    crop_row = find(all(~(mask),1));
    crop_col = find(all(~(mask),2));
    ac(~mask') = nan;
    ac(crop_row,:) = [];
    ac(:,crop_col) = [];
end