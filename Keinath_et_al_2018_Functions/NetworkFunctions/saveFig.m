function saveFig(h,p,form)
    drawnow;
    
    checkP(p);
    STYLE = hgexport('readstyle','default');
    hgexport(h, [p '.' form],STYLE, 'Format',form);
end