function p = genLink()
    p.type = [];
    p.init = [];
    p.learning = [];
    p.learningRate = [];
    p.learningRateIncrease = [];
    p.learningRateDecrease = [];
    p.sumWeights = [];
    p.maxWeight = inf;
    p.sumWeightNormingPops = [];
    p.sparseFrom = 1;
    p.sparseTo = 1;
    p.radius = [];
    p.rectification = [-inf -inf; inf inf];
end