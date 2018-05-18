function dirScore = getDirMod(m)
    use = [1 2];
    dirScore = repmat({[]},[size(m)]);
    for mi = 1:numel(m)
        dirScore{mi} = nan(length(m{mi}(1,1,:,1)),1);
        for k = 1:length(m{mi}(1,1,:,1))
            [peak_x_1 peak_y_1] = find(m{mi}(:,:,k,use(1))==max(max(m{mi}(:,:,k,use(1)))));
            [peak_x_2 peak_y_2] = find(m{mi}(:,:,k,use(2))==max(max(m{mi}(:,:,k,use(2)))));
            
            dirScore{mi}(k) = sqrt((peak_x_1-peak_x_2).^2 + (peak_y_1-peak_y_2).^2);
%             dirScore{mi}(k) = sqrt(sum(sum((m{mi}(:,:,k,use(1))-m{mi}(:,:,k,use(2))).^2)));
        end
    end
end