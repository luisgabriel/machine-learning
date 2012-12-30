function prototypes = lvq1(initialSet, adjustSet, validationSet, alpha, maxIteractions, numClasses)
    display('LVQ1');
    [rows, columns] = size(adjustSet);
    lastError = -10000;
    backup = [];

    for it = 0 : maxIteractions
        for index = 1 : rows
            current = adjustSet(index, :);
            nearest = knn(1, current, initialSet)(2:columns+1);

            alphaT = alpha * exp(-index/maxIteractions);
            [~, protIndex] = ismember(nearest, initialSet, 'rows');
            initialSet(protIndex, :) = lvq_adjust(current, nearest, columns, alphaT);
        end

        % validation
        [c,w] = knn_classify(3, initialSet, validationSet, numClasses, 1);
        if lastError >= w
            printf('> Stabilized: %d step(s)\n', it);
            initialSet = backup;
            break;
        end

        lastError = w;
        backup = initialSet;
    end

    prototypes = initialSet;
end
