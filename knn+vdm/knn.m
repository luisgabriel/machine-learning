function [correct, wrong] = knn(k, trainingSet, testSet, numClasses, weighted, ntable)
    correct = 0;
    wrong = 0;
    testSetSize = size(testSet, 1);
    parfor i = 1 : testSetSize
        distances = calc_all_distances(testSet(i, :), trainingSet, ntable, numClasses);
        sortedDistances = sortrows(distances);
        nearestNeighbors = sortedDistances(1:k, :);
        class = classify(k, nearestNeighbors, numClasses, weighted);

        if class == testSet(i, 1)
            correct += 1;
        else
            wrong += 1;
        end
    end

    correct = correct / testSetSize;
    wrong = wrong / testSetSize;
end

function distances = calc_all_distances(subject, trainingSet, ntable, numClasses)
    distances = [];
    for i = 1 : size(trainingSet, 1)
        current = trainingSet(i, :);
        dist = vdm(subject, current, ntable, numClasses);
        distances = [distances; [dist current(1)]];
    end
end

function result = vdm(a, b, ntable, numClasses)
    dimensions = min(length(a), length(b));
    acc = 0;
    for i = 2 : dimensions
        ai = a(i);
        bi = b(i);
        for c = 1 : numClasses
            Niac = ntable{i}(ai, c);
            Nibc = ntable{i}(bi, c);
            Nac = ntable{1}(ai, i);
            Nbc = ntable{1}(bi, i);

            div1 = 0;
            div2 = 0;

            if (Nac != 0)
                div1 = Niac / Nac;
            end

            if (Nbc != 0)
                div2 = Nibc / Nbc;
            end

%            acc += power(div1 - div2, 2);
             acc += abs(div1 - div2);
        end
    end
    result = sqrt(acc);
end

function class = classify(k, nearestNeighbors, numClasses, weighted)
    sorted = sortrows(nearestNeighbors, 2);

    if k == 1
        class = sorted(1, 2);
    elseif k == 2
        % 2-NN case with same distance and diffent classes -> random choice
        if (sorted(1, 2) != sorted(2, 2)) && (sorted(1, 1) == sorted(2, 1))
            choice = round(rand(1) + 1);
            class = sorted(choice, 2);
        else
            class = sorted(1, 2);
        end
    else
        counter = zeros(numClasses, 1);

        for i = 1 : size(sorted, 1)
            classId = sorted(i, 2);

            if weighted == 1
                distance = sorted(i, 1);
                if distance ~= 0
                    counter(classId) += (1 / distance);
                end
            else
                counter(classId) += 1;
            end
        end

        [_, newIndex] = max(counter);
        values = counter(counter ~= 0);

        if length(values) == k
            class = sorted(1, 2);
        else
            class = newIndex;
        end
    end
end
