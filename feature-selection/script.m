%FILE_PREFIX = 'data/pima-indians-diabetes';
FILE_PREFIX = 'data/wdbc';
%FILE_PREFIX = 'data/sonar';

K = [1; 3];
NUM_CLASSES = 2;
FOLDS = 10;

trainingSet = dlmread(strcat(FILE_PREFIX, '.train'));
testSet = dlmread(strcat(FILE_PREFIX, '.test'));

printf('<><> Simulation:');
for i = 1 : size(K)
    printf('\n----> K = %u\n', K(i));

    for j = 2 : size(trainingSet, 2)
        %printf('\n-> Feature set %u <-\n', j-1);
        printf('\n%u ', j-1);
        [c, w] = knn_classify(K(i), trainingSet(:, 1:j), testSet(:, 1:j), NUM_CLASSES, 1);
        %printf('Correct: %.2f %%\n', (correct/FOLDS)*100);
        printf('%.2f', c*100);
    end
end
