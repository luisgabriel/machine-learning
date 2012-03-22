function [correct, wrong] = knn(k, data, training_rate)
    data_set = read_file(data);
    data_set = normalize_values(data_set);
    [training_set, test_set] = split_set(data_set, training_rate);
    [correct, wrong] = run(k, training_set, test_set);
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
        min_value = min(column);
        range = max(column) - min_value ;
        output(:, i) = (column - min_value) / range;
    end
end

function [training_set, test_set] = split_set(data_set, training_rate)
    total = size(data_set, 1);
    pivot = round(total * training_rate);
    training_set = data_set(1:pivot, :);
    test_set = data_set(pivot+1:total,:);
end

function [correct, wrong] = run(k, training_set, test_set)
    correct = 0;
    wrong = 0;

    for i = 1 : size(test_set, 1)
        distances = calc_all_distances(test_set(i, :), training_set);
        sorted_dist = sortrows(distances);
        nearest_neighbors = sorted_dist(1:k, :);
        class = classify(k, nearest_neighbors);

        if class == test_set(i, 1)
            correct += 1;
        else
            wrong += 1;
        end
    end
end

function distances = calc_all_distances(subject, training_set)
    distances = [];
    for i = 1 : size(training_set, 1)
        current = training_set(i, :);
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

function class = classify(k, nearest_neighbors)
    sorted = sortrows(nearest_neighbors, 2);
    [values, count] = count_unique(sorted(:,2));

    if length(values) == k
        class = sorted(1, 2);
    else
        [_, index] = max(count);
        class = values(index);
    end
end
