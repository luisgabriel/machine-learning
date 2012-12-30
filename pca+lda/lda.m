function final = lda(dataSet, class, nclasses, nfeatures)
    dataMean = mean(dataSet, 2);
    Sw = 0; Sb = 0;

    for l = nclasses
        index = class == l;
        nl = sum(index);
        lSamples = dataSet(:, index);
        lMean = mean(lSamples, 2);
        diff = lMean - dataMean;
        Sb = Sb + (nl * diff * diff');

        for i = 1:nl
            diff = lSamples(:, i) - lMean;
            Sw = Sw + (diff * diff');
        end
    end

    if det(Sw) == 0
        Sw = Sw + 0.00001*eye(size(Sw, 1));
    end

    [eVector, eValues] = eig(Sw/Sb);
    [_, index] = sort(sum(eValues, 1), 'descend');
    t = eVector(:, index(1:nfeatures));
    prefinal = t' * dataSet;
    final = prefinal';
end
