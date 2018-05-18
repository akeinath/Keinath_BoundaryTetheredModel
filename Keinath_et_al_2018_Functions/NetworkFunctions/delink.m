function link = delink(link)
    for name = fieldnames(link)'
        link.(name{1}) = [];
    end
end