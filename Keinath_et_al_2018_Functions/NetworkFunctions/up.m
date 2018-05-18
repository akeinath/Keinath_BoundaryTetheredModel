%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                         %
%%  Updating the network, integrating network activity,    %
%%      and carrying out learning                          %
%%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function upnet = up(net,delta,doLearning)
    upnet = net;
    upAct = repmat({[]},[1 length(net.act)]);
    
    for pi = 1:length(net.act)
        upAct{pi} = zeros(size(net.act{pi}));
    end
    
    if ~isempty(net.p.link(2,2).type)
        upAct{2} = upAct{2} + gridFilter(net,delta,deg2rad(97.5));
    end
    
    %%% Carry Out Weight-Matrix-Based Connections
    for i = 1:length(net.w(:,1))
        for j = 1:length(net.w(:,1))
            if ~isempty(net.w{i,j})
%                 upAct{j}(:) = upAct{j}(:) + filt(net.w{i,j}'*net.act{i}(:),net.p.link(i,j).rectification);
                upAct{j}(:) = upAct{j}(:) + sum(net.w{i,j}.*net.wAct{i,j},1)';
            end
        end
    end
    
    %%% Carry Out Fourier-Based Connections
    if ~isempty(net.filt)
        for i = 1:length(net.filt(:,1))
            for j = 1:length(net.filt(:,1))
                if ~isempty(net.filt{i,j})
                    for mi = 1:length(net.act{i}(1,1,:))
%                         upAct{j}(:,:,mi) = upAct{j}(:,:,mi) + filt(real(ifft2(net.filt{i,j}.*fft2(net.act{i}(:,:,mi)))),net.p.link(i,j).rectification);
                        upAct{j}(:,:,mi) = upAct{j}(:,:,mi) + real(ifft2(net.filt{i,j}.*fft2(net.act{i}(:,:,mi))));

                    end
                end
            end
        end
    end
    
    for i = 1:length(net.act)
        if ~net.p.spiking
            upnet.act{i} = upnet.act{i} - (upnet.act{i} - (upAct{i}-upnet.thresh{i})).*(net.p.ts./net.p.pop(i).tc);
            upnet.act{i} = max(upnet.act{i},0);
        else
            spike = (upAct{i}- net.thresh{i}).*(net.p.ts).*net.p.pop(i).excitability > rand(size(net.act{i}));
            upnet.spikes{i} = spike;
            spike = spike.*net.p.specific.spikeScalar;
            upnet.act{i} = net.act{i} + (net.p.ts/net.p.pop(i).tc)*(-net.act{i} +(net.p.pop(i).tc/net.p.ts)*spike);
            if max(max( upAct{i}.*(net.p.ts).*net.p.pop(i).excitability ))>1
                'fail'
            end
        end        
    end
    
    upnet.wAct = weightActs(upnet);
    
%     net.act{2}
    %%% Adjust Weights
    if ~isempty(doLearning) && doLearning
        for pi = 1:length(net.p.link(:,1))
            for pj = 1:length(net.p.link(1,:))
                if ~isempty(net.p.link(pi,pj).learning)
                   
                    %%% Standard Hebbian Learning
                    if ismember({'Hebb'},net.p.link(pi,pj).learning)
                        a = net.act{pi}(:);
                        b = max(upnet.act{pj}(:)-upnet.thresh{pj}(:),0);
                        
                        fullChange = (a*b'-upnet.w{pi,pj}).*upnet.p.link(pi,pj).learningRate;

                        % Update weights only for active cells in receiving population
                        update = repmat((b>0)',[length(net.w{pi,pj}(:,1)) 1]);
                        upnet.w{pi,pj}(update) = upnet.w{pi,pj}(update) + fullChange(update);
                    end
                    
                    %%% Asymmetric Learning Rate Hebbian Learning
                    if ismember({'HebbAsymmetric'},net.p.link(pi,pj).learning)
                        a = net.act{pi}(:);
                        b = max(upnet.act{pj}(:)-upnet.thresh{pj}(:),0);
                        
                        change = (a*b'-upnet.w{pi,pj});
                        change(change>0) = change(change>0).*upnet.p.link(pi,pj).learningRateIncrease;
                        change(change<0) = change(change<0).*upnet.p.link(pi,pj).learningRateDecrease;
                        
                        % Update weights only for active cells in receiving population
                        update = repmat((b>0)',[length(net.w{pi,pj}(:,1)) 1]);
                        upnet.w{pi,pj}(update) = upnet.w{pi,pj}(update) + change(update);
                        upnet.w{pi,pj}(upnet.w{pi,pj}>upnet.p.link(pi,pj).maxWeight) = upnet.p.link(pi,pj).maxWeight;
                    end
                    
                    %%% Contrastive Hebbian Learning
                    if ismember({'ContrastiveHebb'},net.p.link(pi,pj).learning)

                        rectAAct = net.wAct{pi,pj};
%                         if net.p.spiking
%                             rectBAct = repmat([net.spikes{pj}(:)]',[length(upnet.w{pi,pj}(:,1)) 1]);
%                         else
                            rectBAct = repmat((max(upnet.act{pj}(:),0))',...
                                [length(upnet.w{pi,pj}(:,1)) 1]); % removed squaring
%                         end
                        
                        % Determine contributions from other populations to
                        % allow norming the sumWeights across populations
                        
                        otherWeightContributors = upnet.p.link(pi,pj).sumWeightNormingPops;
                        
                        if isempty(otherWeightContributors)
                            otherContributions = 0;
                        else
                            otherContributions = zeros(1,length(rectAAct(1,:)));
                            for others = otherWeightContributors'
                                contribution = net.wAct{others(1),others(2)};
                                otherContributions = otherContributions+sum(contribution,1);
                            end
                        end
                        
                        change = rectBAct.*[(upnet.p.link(pi,pj).sumWeights-net.w{pi,pj}).*rectAAct - ...
                            (net.w{pi,pj}.*bsxfun(@plus,bsxfun(@minus,sum(rectAAct),rectAAct),otherContributions))];
                        
                        upnet.w{pi,pj} = net.w{pi,pj} + change.*net.p.link(pi,pj).learningRate;
                            
                    end
                end               
            end
        end
    end
end