function maps = mkMap(p,a,bin)

    isBad = any(isnan(a),1);
    p(:,isBad) = [];
    a(:,isBad) = [];
    
    
    p = floor([p-repmat(min(p,[],2),[1 length(p)])]./bin)+1;
    
    maps = zeros([max(p,[],2)' length(a(:,1))]);
    for loc = unique(p','rows')';
        maps(loc(1),loc(2),:) = nansum(a(:,p(1,:)==loc(1)&p(2,:)==loc(2)),2);
        maps(loc(1),loc(2),:) = maps(loc(1),loc(2),:)./(sum(p(1,:)==loc(1)&p(2,:)==loc(2)));
    end
    
    kern = fspecial('gauss',[9 9],1.5);
    for i = 1:length(maps(1,1,:))
        maps(:,:,i) = imfilter(maps(:,:,i),kern,'same');
    end
    maps = permute(maps,[2 1 3]);
end