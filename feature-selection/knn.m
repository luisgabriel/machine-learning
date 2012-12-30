function nearestNeighbors = knn(k, sample, trainingSet)
    distances = calc_all_distances(sample, trainingSet);
    sortedDistances = sortrows(distances);
    nearestNeighbors = sortedDistances(1:k, :);
end

function distances = calc_all_distances(subject, trainingSet)
    distances = [];
    for i = 1 : size(trainingSet, 1)
        current = trainingSet(i, :);
        dist = euclidian_distance(subject, current);
        distances = [distances; [dist current]];
    end
end
