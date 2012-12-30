%FILE_PREFIX = 'data/pima-indians-diabetes';
FILE_PREFIX = 'data/segment';
%FILE_PREFIX = 'data/wdbc';
%FILE_PREFIX = 'data/sonar';

NUM_CLASSES = 7;
NUM_FEATURES = 19;
FOLDS = 10;
PCA = 0;

if PCA == 1
    printf('<><> 3-NN Simulation using PCA:\n');
else
    printf('<><> 3-NN Simulation using LDA:\n');
end
printf('Data set: %s\n', FILE_PREFIX);
printf('Cross validation: %d-fold\n\n', FOLDS);
printf('Dimensions - Accuracy (%%)\n');

for k = 1 : NUM_FEATURES
    printf('%d - ', k);

    trainingSet = {};
    testSet = {};

    for i = 1 : FOLDS
        if PCA == 1
            testSet{i} = dlmread(strcat(FILE_PREFIX, '/pca.', int2str(k), '.fold', int2str(i)));
        else
            testSet{i} = dlmread(strcat(FILE_PREFIX, '/lda.', int2str(k), '.fold', int2str(i)));
        end
        trainingSet{i} = [];
    end

    for i = 1 : FOLDS
        for j = 1 : FOLDS
            if i ~= j
                trainingSet{i} = [trainingSet{i}; testSet{j}];
            end
        end
    end

    correct = 0;
    for j = 1 : FOLDS
        [c, w] = knn_classify(3, trainingSet{j}, testSet{j}, NUM_CLASSES, 1);
        correct += c;
    end
    printf('%.2f\n', (correct/FOLDS)*100);
end
