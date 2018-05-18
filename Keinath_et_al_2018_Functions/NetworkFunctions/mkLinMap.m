function maps = mkLinMap(p,a,bin)

    dir = diff(p(1,:),[],2);
    dir = ((-sign(dir)+1)./2)+1;
    dir = [0 dir];

    isBad = any(isnan(a),1);
    p(:,isBad) = [];
    a(:,isBad) = [];
    dir(isBad) = [];
    
    p = floor([p-repmat(min(p,[],2),[1 length(p)])]./bin)+1;
    
    maps = zeros([max(p,[],2)' length(a(:,1)) 2]);
    for d = 1:2
        for loc = unique(p','rows')';
            maps(loc(1),loc(2),:,d) = nanmean(a(:,p(1,:)==loc(1)&p(2,:)==loc(2)&dir==d),2);
        end
    end
    
    kern = fspecial('gauss',[9 9],1.5);
    for d = 1:2
        for i = 1:length(maps(1,1,:,d))
            maps(:,:,i,d) = imfilter(maps(:,:,i,d),kern,'same');
        end
    end
end