function wa = weightActs(net)
    wa = repmat({[]},length(net.act));
    for i = 1:length(wa)
        for j = 1:length(wa)
            if ~isempty(net.w{i,j})
                wa{i,j} = zeros(net.p.link(i,j).connectionsEach);
                wa{i,j}(:) = net.act{i}(net.linkedInds{i,j}(:,1));
            end
        end
    end
end