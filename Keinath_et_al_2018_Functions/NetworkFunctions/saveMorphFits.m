function saveMorphFits(m,mods,xMorph,yMorph)
    best = repmat({[]},([size(m) mods 2]));
    cellsPerMod =(length(m{1,1}(1,1,:))./mods);
    for mi = 1:mods
        refs = m{yMorph==1,xMorph==1}(:,:,(mi-1).*cellsPerMod+1:(mi).*cellsPerMod);
        for i = 1:length(m(:,1))
            for j = 1:length(m(1,:))
                fprintf(['Fitting Module ' num2str(mi) ' mx: ' num2str(xMorph(j)) '  my: ' num2str(yMorph(i)) ' ...'])
                tic
                [vals] = bestFitMorph3(refs,m{i,j}(:,:,(mi-1).*cellsPerMod+1:(mi).*cellsPerMod),xMorph,yMorph);
                toc
                best{i,j,mi,1} = vals(:,1);
                best{i,j,mi,2} = vals(:,2);
            end
        end
    end
    save('Fits','best','-v7.3');
end