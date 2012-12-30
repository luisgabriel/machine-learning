function prototypes = lvq3(lvq1Set, adjustSet, validationSet, alpha, maxIteracts, window, epsilon, numClasses)
    display('LVQ3');
    [rows, columns] = size(adjustSet);
    lastError = -10000;
    backup = [];

    for it = 0 : maxIteracts
        for index = 1 : rows
            current = adjustSet(index, :);
            nearest = knn(2, current, lvq1Set);

            mi = nearest(1, 2:columns+1);
            mj = nearest(2, 2:columns+1);
            [~, miIndex] = ismember(mi, lvq1Set, 'rows');
            [~, mjIndex] = ismember(mj, lvq1Set, 'rows');

            if in_window(current, nearest(1, 1), nearest(2, 1), window)
                alphaT = alpha * exp(-index/maxIteracts);

                if (mi(1) ~= mj(1)) && (mi(1) == current(1) || mj(1) == current(1))
                    lvq1Set(miIndex, :) = lvq_adjust(current, mi, columns, alphaT);
                    lvq1Set(mjIndex, :) = lvq_adjust(current, mj, columns, alphaT);
                elseif mi(1) == current(1) && mj(1) == current(1)
                    lvq1Set(miIndex, :) = lvq_adjust(current, mi, columns, alphaT, epsilon);
                    lvq1Set(mjIndex, :) = lvq_adjust(current, mj, columns, alphaT, epsilon);
                end
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
