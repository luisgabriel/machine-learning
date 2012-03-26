function [trainingSet, testSet] = preprocessor(data, trainingRate)
    k = findstr(data, '.data');
    prefix = data(1:k-1);

    if is_cached(prefix, trainingRate) != 0
        [trainingSet, testSet] = load_data(prefix, trainingRate);
    else
        dataSet = dlmread(data);
        dataSet = normalize_values(dataSet);
        [trainingSet, testSet] = split_set(dataSet, trainingRate);

        % Caching
        save_data(prefix, 'all', trainingRate, dataSet);
        save_data(prefix, 'training', trainingRate, trainingSet);
        save_data(prefix, 'test', trainingRate, testSet);
    end
end

function cached = is_cached(prefix, trainingRate)
    rate = sprintf('%.2f', trainingRate);
    fileName1 = strcat(prefix, '-all-', rate, '.data');
    fileName2 = strcat(prefix, '-training-', rate, '.data');
    fileName3 = strcat(prefix, '-test-', rate, '.data');
    cached = exist(fileName1) && exist(fileName2) && exist(fileName3);
end

function save_data(prefix, sufix, trainingRate, dataSet)
    rate = sprintf('%.2f', trainingRate);
    fileName = strcat(prefix, '-', sufix, '-', rate, '.data');
    dlmwrite(fileName, dataSet);
end

function [trainingSet, testSet] = load_data(prefix, trainingRate)
    rate = sprintf('%.2f', trainingRate);
    fileName = strcat(prefix, '-training-', rate, '.data');
    trainingSet = dlmread(fileName);
    fileName = strcat(prefix, '-test-', rate, '.data');
    testSet = dlmread(fileName);
end

function output = normalize_values(data)
    output = [];

    output(:, 1) = data(:, 1);

    for i = 2 : size(data, 2)
        column = data(:, i);
        minValue = min(column);
        range = max(column) - minValue ;
        if range > 0
            output(:, i) = (column - minValue) / range;
        end
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
