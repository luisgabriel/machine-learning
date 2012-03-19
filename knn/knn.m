function [correct, wrong] = knn(n, data, training_rate)
    set = read_file(data);
    total = size(set, 1);
    pivot = round(total * training_rate);
    training_set = set(1:pivot, :);
    test_set = set(pivot+1:total,:);
    [correct, wrong] = run(n, training_set, test_set);
end

function output = read_file(file_name)
    file = fopen(file_name);
    A = fscanf(file, '%c,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u,%u\n', [17 inf]);
    fclose(file);
    output = A';
end

function [correct, wrong] = run(n, training_set, test_set)
    correct = 0;
    wrong = 0;

    for i = 1 : size(test_set, 1)
        distances = calc_all_distances(test_set(i, :), training_set);
        sorted_dist = sortrows(distances);
        nearest_neighbors = sorted_dist(1:n, :);
        class = classify(n, nearest_neighbors);

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
