function [correct, wrong] = knn(k, data, trainingRate, x)
    dataSet = read_file(data)(1:x, :);
    dataSet = normalize_values(dataSet);
    [trainingSet, testSet] = split_set(dataSet, trainingRate);
    [correct, wrong] = run(k, trainingSet, testSet);
end

function output = read_file(file_name)
    file = fopen(file_name);
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

function [correct, wrong] = run(k, trainingSet, testSet)
    correct = 0;
    wrong = 0;
    testSetSize = size(testSet, 1);

    for i = 1 : testSetSize
        distances = calc_all_distances(testSet(i, :), trainingSet);
        sortedDistances = sortrows(distances);
        nearestNeighbors = sortedDistances(1:k, :);
        class = classify(k, nearestNeighbors);

        if class == testSet(i, 1)
            correct += 1;
        else
            wrong += 1;
        end
    end

    correct = correct / testSetSize;
    wrong = wrong / testSetSize;
end

function distances = calc_all_distances(subject, trainingSet)
    distances = [];
    for i = 1 : size(trainingSet, 1)
        current = trainingSet(i, :);
        dist = euclidian_distance(subject, current);
        distances = [distances; [dist current(1)]];
    end
end

function result = euclidian_distance(a, b)
    dimensions = min(length(a), length(b));
    acc = 0;
    for i = 2 : dimensions
        diff = a(i) - b(i);
        acc += power(diff, 2);
    end
    result = sqrt(acc);
end

function class = classify(k, nearestNeighbors)
    sorted = sortrows(nearestNeighbors, 2);
    [values, count] = count_unique(sorted(:,2));

    if length(values) == k
        class = sorted(1, 2);
    else
        [_, index] = max(count);
        class = values(index);
    end
end
