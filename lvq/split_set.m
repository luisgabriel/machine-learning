function [trainingSet, testSet] = split_set(dataSet, trainingRate, numClasses)
    trainingSet = [];
    testSet = [];

    for classId = 1 : numClasses
        content = dataSet(dataSet(: ,1) == classId, :);
        total = size(content, 1);
        pivot = round(total * trainingRate);
        trainingSet = [trainingSet; content(1:pivot, :)];
        testSet = [testSet; content(pivot+1:total,:)];
    end
end
