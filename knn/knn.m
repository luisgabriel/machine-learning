function [correct, wrong] = knn(k, trainingSet, testSet)
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
    diff = power(a(2:dimensions) - b(2:dimensions), 2);
    result = sqrt(sum(diff));
end

function class = classify(k, nearestNeighbors)
    sorted = sortrows(nearestNeighbors, 2);

    if k == 1
        class = sorted(1, 2);
    elseif k == 2
        % 2-NN case with same distance and diffent classes -> random choice
        if (sorted(1, 2) != sorted(2, 2)) && (sorted(1, 1) == sorted(2, 1))
            choice = round(rand(1));
            class = sorted(choice, 2);
        else
            class = sorted(1, 2);
        end
    else
        [values, count] = count_unique(sorted(:,2));

        if length(values) == k
            class = sorted(1, 2);
        else
            [_, index] = max(count);
            class = values(index);
        end
    end
end
