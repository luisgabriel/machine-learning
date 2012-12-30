function roc_curve(inputFile)
    l = dlmread(inputFile);
    positiveInstances = l(l(:, 2) == 1, :);
    p = size(positiveInstances, 1);
    n = size(l, 1) - p;
    points = algorithm(l, p, n);
    plot_curve(points);
end

function plot_curve(points)
    plot(points(:, 1), points(:, 2));
    xlabel('False positive rate');
    ylabel('True positive rate');
    set(gca,'XTick',0:0.1:1)
    set(gca,'YTick',0:0.1:1)
end

function points = algorithm(l, p, n)
    lSorted = flipdim(sortrows(l, 3), 1);
    falsePositive = 0;
    truePositive = 0;
    prevScore = -99999999;
    points = [];

    for i = 1 : size(lSorted, 1)
        if lSorted(i, 3) ~= prevScore
            points = [points; (falsePositive/n) (truePositive/p)];
            prevScore = lSorted(i, 3);
        end

        if lSorted(i, 2) == 1
            truePositive += 1;
        else
            falsePositive += 1;
        end
    end

    points = [points; (falsePositive/n) (truePositive/p)];
end
