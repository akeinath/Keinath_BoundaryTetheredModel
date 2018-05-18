function [act bvcs] = bvcAct(net,p)
    d2b = [p(1,:)-net.p.path.boundingBox(1); ...
        p(2,:)-net.p.path.boundingBox(2); ...
        net.p.path.boundingBox(3)-p(1,:); ...
        net.p.path.boundingBox(4)-p(2,:)];
    
    bvcpd = net.p.pop(1).nPerMod./4;
    dtune = [0:net.p.specific.bvcIncrement:net.p.specific.bvcIncrement.*(bvcpd-1)];
    d2tune = abs(repmat(dtune',[1 length(p(1,:)) 4]) - repmat(permute(d2b,[3 2 1]),[bvcpd 1 1]));
    sds = repmat(net.p.specific.bvcIncrement.*[1:bvcpd]'.*net.p.specific.bvcInitSD,[1 length(p(1,:)) 4]);
    
    act = net.p.specific.bvcScalar.*exp(-(d2tune.^2) ./ (2.*sds))./(sqrt(2.*pi.*sds));
    act = [act(:,:,1); act(:,:,2); act(:,:,3); act(:,:,4)];
    if net.p.spiking
        bvcs = (act- repmat(net.thresh{1},[1 length(act(1,:))])).*(net.p.ts).*net.p.pop(1).excitability > ...
            rand(size(act));
%         spikes = zeros(length(act(:,1)),1);
%         bvcs = zeros(size(act));
%         for i = 1:length(act(1,:))
%             spike = (act(:,i)- net.thresh{1}).*(net.p.ts).*net.p.pop(1).excitability > rand(size(spikes));
%             bvcs(:,i) = spike;
% %             spike = spike.*net.p.specific.spikeScalar;
% %             spikes = spikes + (net.p.ts/net.p.pop(1).tc)*(-spikes +(net.p.pop(1).tc/net.p.ts)*spike);
% %             act(:,i) = spikes;
% %             if (act(:,i)- net.thresh{1}).*(net.p.ts).*net.p.pop(1).excitability > 1
% %                 fprintf('fail')
% %             end
%         end
    end
end