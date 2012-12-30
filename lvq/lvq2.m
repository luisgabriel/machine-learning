function prototypes = lvq2(lvq1Set, adjustSet, validationSet, alpha, maxIteractions, window, numClasses)
    display('LVQ2');
    [rows, columns] = size(adjustSet);
    lastError = -10000;
    backup = [];

    for it = 0 : maxIteractions
        for index = 1 : rows
            current = adjustSet(index, :);
            nearest = knn(2, current, lvq1Set);

            mi = nearest(1, 2:columns+1);
            mj = nearest(2, 2:columns+1);
            [~, miIndex] = ismember(mi, lvq1Set, 'rows');
            [~, mjIndex] = ismember(mj, lvq1Set, 'rows');

            cond1 = in_window(current, nearest(1, 1), nearest(2, 1), window);
            cond2 = (mi(1) ~= mj(1)) && (mi(1) == current(1) || mj(1) == current(1));
            if cond1 && cond2
                alphaT = alpha * exp(-index/maxIteractions);
                lvq1Set(miIndex, :) = lvq_adjust(current, mi, columns, alphaT);
                lvq1Set(mjIndex, :) = lvq_adjust(current, mj, columns, alphaT);
            end
        end

        % validation
        [c,w] = knn_classify(3, lvq1Set, validationSet, numClasses, 1);
        if lastError >= w
            printf('> Stabilized: %d step(s)\n', it);
            lvq1Set = backup;
            break;
        end

        lastError = w;
        backup = lvq1Set;
    end

    prototypes = lvq1Set;
end
