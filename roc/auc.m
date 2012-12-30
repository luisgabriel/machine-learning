function area = auc(inputFile)
    l = dlmread(inputFile);
    positiveInstances = l(l(:, 2) == 1, :);
    p = size(positiveInstances, 1);
    n = size(l, 1) - p;
    area = algorithm(l, p, n);
end

function area = algorithm(l, p, n)
    lSorted = flipdim(sortrows(l, 3), 1);
    falsePositive = 0;
    truePositive = 0;
    prevFalsePositive = 0;
    prevTruePositive = 0;
    prevScore = -99999999;
    area = 0;

    for i = 1 : size(lSorted, 1)
        if lSorted(i, 3) ~= prevScore
            area += trapezoid_area(falsePositive, prevFalsePositive,
                                   truePositive, prevTruePositive);
            prevScore = lSorted(i, 3);
            prevFalsePositive = falsePositive;
            prevTruePositive = truePositive;
        end

        if lSorted(i, 2) == 1
            truePositive += 1;
        else
            falsePositive += 1;
        end
    end

    area += trapezoid_area(n, prevFalsePositive, n, prevTruePositive);
    area /= (p * n);
end

function area = trapezoid_area(x1, x2, y1, y2)
    base = abs(x1 - x2);
    height = (y1 + y2)/2;
    area = base * height;
end
