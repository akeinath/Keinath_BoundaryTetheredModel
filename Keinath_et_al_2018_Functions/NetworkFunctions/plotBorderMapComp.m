function plotBorderMapComp(m,folder)
    colors = hsv(4);
    colors = circshift(colors,[3 0]); %[3 0]
    labels = [{'up_down'} {'left_right'}];
    group = [2 4; 1 3];
    for udlr = [1 2]

        for k = 1:length(m{1}(1,1,:,1))
            h = figure(1);
            set(gcf,'position',[50 50 150.*length(m(1,:)) 150.*length(m(:,1))])
            for j = 1:length(m(1,:))
                for i = 1:length(m(:,1))

                    a = permute(m{i,j}(:,:,k,[group(udlr,:)]),[1 2 4 3]);
                    a = bsxfun(@minus,a,min(min(a,[],1),[],2));
                    a = bsxfun(@rdivide,a,max(max(a,[],1),[],2));
                    
                    bm1 = repmat(a(:,:,1),[1 1 3]).*repmat(permute(colors(group(udlr,1),:),[3 1 2]),[size(a(:,:,1))]);
                    bm2 = repmat(a(:,:,2),[1 1 3]).*repmat(permute(colors(group(udlr,2),:),[3 1 2]),[size(a(:,:,1))]);
                    
                    subplot(length(m(:,1)),length(m(1,:)),(i-1).*length(m(1,:))+j)
                    image(bm1+bm2)
                    tmp = get(gca,'position');

                    scale = [length(a(:,1,1))./max(max(cellfun(@size,m,repmat({1},[size(m)])))) ...
                        length(a(1,:,1))./max(max(cellfun(@size,m,repmat({2},[size(m)]))))];
                        set(gca,'ydir','normal','position',[tmp(1)+0.5.*(1-scale(2)).*tmp(3) tmp(2)+0.5.*(1-scale(1)).*tmp(4) tmp(3).*scale(2) tmp(4).*scale(1)])
                    axis equal
                    axis off
                end
            end
            outP = ['Plots/' folder '/MorphedBorderMaps/Cell_' num2str(k) '_' labels{udlr}];
            saveFig(h,outP,'tiff');
            outP = ['Plots/' folder '/MorphedBorderMaps/EPS/Cell_' num2str(k) '_' labels{udlr}];
            saveFig(h,outP,'eps');
            close(h);
        end
    end
end