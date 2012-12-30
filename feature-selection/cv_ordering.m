function [orderedTraining, orderedTest] = cv_ordering(trainingSet, testSet)
    numAttributes = size(trainingSet, 2) - 1;
    instances = trainingSet(:, 2:numAttributes+1);

    dataVariance = var(instances);
    dataMean = mean(instances);
    dataCV = bsxfun(@rdivide, sqrt(dataVariance), dataMean);
    [_, sortIndexes] = sort(dataCV);

    orderedTraining = trainingSet(:, 1);
    orderedTest = testSet(:, 1);
    for i = 1 : size(sortIndexes, 2)
        orderedTraining = [orderedTraining instances(:, sortIndexes(i))];
        orderedTest = [orderedTest testSet(:, sortIndexes(i)+1)];
    end
end
