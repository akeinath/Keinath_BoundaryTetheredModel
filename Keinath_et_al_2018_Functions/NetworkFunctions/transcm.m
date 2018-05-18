function cm = transcm
    cm = [linspace(0.5,0.85,200)' (0.0)+([1:-1./99:0 0:1./99:1].^(0.8)'.*0.35) ones(200,1).*0.95];
    cm = hsv2rgb(cm);
%     cs = min(1:length(cm),abs([1:length(cm)]-length(cm)));
%     cs = cs./max(cs);
%     cs = (cs+0.0)./1.0;
%     cm = 1-bsxfun(@times,1-cm,1-cs').*0.9;
end