function [correct,wrong] = knn(n, training_data, test_data)
    training_set = read_file(training_data);
    test_set = read_file(test_data);

    correct = 0;
    wrong = 0;

    for i = 1 : length(test_set)
        distances = calc_all_distances(test_set(i, :), training_set);
        sorted = sortrows(distances);
        nearest_neighbors = sorted(1:n, :);
        class = classify(n, nearest_neighbors);
%        str = sprintf('expected: %c, classified: %c', );
%        display(str);

        if class == test_set(i, 1)
            correct += 1;
        else
            wrong += 1;
        end
    end
end

function output = read_file(file_name)
    file = fopen(file_name);
    A = fscanf(file, '%c,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u\n', [17 inf]);
    fclose(file);
    output = A';
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

function distances = calc_all_distances(subject, training_set)
    distances = [];
    for i = 1 : length(training_set)
        current = training_set(i, :);
        dist = euclidian_distance(subject, current);
        distances = [distances; [dist current(1)]];
    end
end

function class = classify(n, nearest_neighbors)
    sorted = sortrows(nearest_neighbors, 2);
    [values, count] = count_unique(sorted(:,2));

    if length(values) == n
        class = sorted(1, 2);
    else
        [_, index] = max(count);
        class = values(index);
    end
end
