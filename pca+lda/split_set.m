function folds = split_set(dataSet, k, numClasses)
    folds = {};
    content = {};
    total = [];

    for classId = 1 : numClasses
        content{classId} = dataSet(dataSet(: ,1) == classId, :);
        total(classId) = size(content{classId}, 1);
    end

    for i = 1 : k
        for classId = 1 : numClasses
            portion = floor(total(classId) / k);
            beginFold = ((i-1) * portion) + 1;

            if i == k
                endFold = total(classId);
            else
                endFold = i * portion;
            end

            if classId == 1
                folds{i} = content{classId}(beginFold:endFold, :);
            else
                folds{i} = [folds{i}; content{classId}(beginFold:endFold, :)];
            end
        end
    end
end
