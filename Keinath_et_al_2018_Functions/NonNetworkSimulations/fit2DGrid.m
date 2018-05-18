function fit2DGrid(paths,fileOut)
    clc
    fprintf('Fitting 2D Grids to Linear Grids...\n')
    labels = [{'Left'} {'Right'} {'All'}];
    allOrs = [];
    for p = paths'
        s = load(p{1});
        fprintf(['\n\tAnimal:  ' s.properties.rat '\tSession:  ' s.properties.session])
        [kx ky]  = find(~cellfun(@isempty,s.unit));
        
        s.fit = repmat({[]},size(s.unit));
        for k = [kx'; ky']
            for i = 1:2
                if max(s.fields{k(1),k(2)}(i,:))==0
                    continue
                end
                
                fm = s.fields{k(1),k(2)}(i,:);
                m = s.maps{k(1),k(2)}(i,:);
                m(fm==0) = 0;
                [out grid] = fitGrid(m,s.p.lims);
                val = corr(grid(:),m(:));
                
                figure(1)
                set(gcf,'position',[50 50 450 150])
                plot(m./max(m),'color','k','linewidth',3);
                hold on
                plot(grid./max(grid),'color','r','linewidth',3);
                title(num2str(val),'fontname','arial','fontweight','bold','fontsize',11)
                outP = ['Plots/GridFits/' s.properties.rat '/T' num2str(k(1)) ...
                    '_' num2str(k(2)) '/' s.properties.session '_' labels{i}];
                saveFig(gcf,outP,'tiff')
                close all
                
                allOrs = [allOrs; out max(s.fields{k(1),k(2)}(i,:)) corr(grid(:),m(:))];
                s.fit{k(1),k(2)}(i,:) = [out corr(grid(:),m(:))];
            end
        end
        save(p{1},'-struct','s','-v7.3')
    end
    
    save(fileOut,'allOrs','-v7.3');
    
    load(fileOut)    
    tmp = rad2deg(allOrs(:,2));
    tmp(tmp>30) = tmp(tmp>30)-60;
    tmp(tmp<-30) = tmp(tmp<-30)+60;
    allOrs(:,2) = deg2rad(tmp);
    
    valThresh = 0
    numFieldsThresh = 8
    good = (allOrs(:,end)>valThresh)&(allOrs(:,end-1)>=numFieldsThresh);
    sum(good)
    set(gca,'xlim',[-pi/6 pi/6])
    fprintf(['\n\tCircular Median:  ' num2str(rad2deg(circ_median(allOrs(good,2).*6)./6))]);
    fprintf(['\n\tCircular Mean:  ' num2str(rad2deg(circ_mean(allOrs(good,2).*6)./6))]);
    
    
    [pval f] = circ_vtest(allOrs(good,2).*6,pi);
    fprintf(['\n\tKuipers Test for 30deg Alignment:  p = ' num2str(pval) '\n']);
    
%     mkGridFig(allOrs(:,1),allOrs(:,2),allOrs(:,end))
    
    
    tmp = abs(allOrs(:,2))-(pi./9);
    [pval f] = circ_vtest(tmp(good).*12,0);
    fprintf(['\n\tKuipers Test for 20deg Alignment:  p = ' num2str(pval) '\n']);
    
    tmp = abs(allOrs(:,2))-(pi./24);
    [pval f] = circ_vtest(tmp(good).*12,0);
    fprintf(['\n\tKuipers Test for 7.5deg Alignment:  p = ' num2str(pval) '\n']);
    hist(rad2deg(allOrs(good,2)))
end

function [out grid] = fitGrid(m,lims)
    options = optimset('Display','off','Algorithm','active-set');
    
    nsims = 500;
    vals = nan(nsims,1); 
    out = nan(nsims,4);
    for sim = 1:nsims
        init = [lims(1,:)+(lims(2,:)-lims(1,:)).*rand(1,4)];
        
        init = [randi(390)+5 deg2rad(randi(58)-60) 0 0];
        [out(sim,:) vals(sim)] = fmincon(@(inV)error(inV,m),init,...
            [],[],[],[],lims(1,:),lims(2,:),[],options);
    end
    [a b] = nanmin(vals);
    out = out(b,:);
    grid = mkGrid(out(1),out(2),out(3),out(4),length(m));
end

function err = error(g,m)
    grid = mkGrid(g(1),g(2),g(3),g(4),length(m));
    err = -atan(corr(grid(:),m(:)));
end