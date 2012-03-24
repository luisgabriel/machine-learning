function [trainingSet, testSet] = preprocessor(data, trainingRate)
    dataSet = read_file(data);
    dataSet = normalize_values(dataSet);
    [trainingSet, testSet] = split_set(dataSet, trainingRate);
end

function output = read_file(fileName)
    file = fopen(fileName);
    A = fscanf(file, '%c,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u\n', [17 inf]);
    fclose(file);
    output = A';
end

function output = normalize_values(data)
    output = [];

    % change the class repersentation to a number starting from 1
    output(:, 1) = data(:, 1) - 64;

    for i = 2 : size(data, 2)
        column = data(:, i);
        minValue = min(column);
        range = max(column) - minValue ;
        output(:, i) = (column - minValue) / range;
    end
end

function [trainingSet, testSet] = split_set(dataSet, trainingRate)
    trainingSet = [];
    testSet = [];
    classes = unique(dataSet(:, 1));

    for i = 1 : size(classes, 1)
        classId = classes(i);
        content = dataSet(dataSet(:,1) == classId,:);
        total = size(content, 1);
        pivot = round(total * trainingRate);
        trainingSet = [trainingSet; content(1:pivot, :)];
        testSet = [testSet; content(pivot+1:total,:)];
    end
end

