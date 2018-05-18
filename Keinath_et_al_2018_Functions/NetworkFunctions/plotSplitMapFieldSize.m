function plotSplitMapFieldSize(m,folder)
    allFieldSize = [];
    for k = 1:90 % 1:length(m{1}(1,1,:))
        
        figure
        set(gcf,'position',[50 50 300 length(m(:,1)).*150])
        acorrSize = 25;
        
        mm = repmat({[]},[1 4]);
        for mi = 1:length(m(:,1))
            
            cM = m{mi}(:,:,k);
            
            if length(cM(1,:))>57
                splitAt = floor(length(cM(1,:)).*0.64);
            else
                splitAt = floor(length(cM(1,:)).*0.5);
            end
                
            mm{1+(mi-1).*2} = cM(:,1:splitAt);
            mm{2+(mi-1).*2} =cM(:,splitAt+1:end);
        end
        
        fs = nan(1,4);
        for i = 1:4
            [a b c] =getPatches(mm{i},9,[],0.5);
            fs(i) = nansum(a(:)~=0)./nanmax(a(:));
        end
        allFieldSize = [allFieldSize; fs.*(2.5.^2)];
        
        close all
        mkGraph(allFieldSize);
        drawnow
    end
end
    