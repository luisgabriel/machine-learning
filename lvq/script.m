%TRAINING_FILE = 'data/pima-indians-diabetes.train';
%VALIDATION_FILE = 'data/pima-indians-diabetes.val';
%TEST_FILE = 'data/pima-indians-diabetes.test';
%PROTOTYPES_FILE = 'data/pima-indians-diabetes.prot';

TRAINING_FILE = 'data/sonar.train';
VALIDATION_FILE = 'data/sonar.val';
TEST_FILE = 'data/sonar.test';
PROTOTYPES_FILE = 'data/sonar-10.prot';

K = [1; 3];
NUM_CLASSES = 2;

MAX_ITERACTIONS = 30;
ALPHA = 0.02;
WINDOW = 0.05;
EPSILON = 0.45;

k = findstr(TEST_FILE, '.test');
prefix = TEST_FILE(1:k-1);

trainingSet = dlmread(TRAINING_FILE);
validationSet = dlmread(VALIDATION_FILE);
testSet = dlmread(TEST_FILE);
prototypes = dlmread(PROTOTYPES_FILE);

lvq1Prototypes = lvq1(prototypes, trainingSet, validationSet, ALPHA, MAX_ITERACTIONS, NUM_CLASSES);
lvq1Prototypes = normalize_values(lvq1Prototypes);

lvq2Prototypes = lvq2(lvq1Prototypes, trainingSet, validationSet, ALPHA, MAX_ITERACTIONS, WINDOW, NUM_CLASSES);
lvq2Prototypes = normalize_values(lvq2Prototypes);

lvq3Prototypes = lvq3(lvq1Prototypes, trainingSet, validationSet, ALPHA, MAX_ITERACTIONS, WINDOW, EPSILON, NUM_CLASSES);
lvq3Prototypes = normalize_values(lvq3Prototypes);

printf('<><> simple k-NN simulation:');
for i = 1 : size(K)
    printf('\n----> K = %u\n', K(i));
    [c, w] = knn_classify(K(i), [trainingSet; validationSet], testSet, NUM_CLASSES, 1);
    printf('Correct: %.2f %%\n', c*100);
    printf('  Wrong: %.2f %%\n', w*100);
end

printf('\n\n<><> k-NN with LVQ1 simulation:');
for i = 1 : size(K)
    printf('\n----> K = %u\n', K(i));
    [c, w] = knn_classify(K(i), lvq1Prototypes, testSet, NUM_CLASSES, 1);
    printf('Correct: %.2f %%\n', c*100);
    printf('  Wrong: %.2f %%\n', w*100);

end

printf('\n\n<><> k-NN with LVQ2 simulation:');
for i = 1 : size(K)
    printf('\n----> K = %u\n', K(i));
    [c, w] = knn_classify(K(i), lvq2Prototypes, testSet, NUM_CLASSES, 1);
    printf('Correct: %.2f %%\n', c*100);
    printf('  Wrong: %.2f %%\n', w*100);

end

printf('\n\n<><> k-NN with LVQ3 simulation:');
for i = 1 : size(K)
    printf('\n----> K = %u\n', K(i));
    [c, w] = knn_classify(K(i), lvq3Prototypes, testSet, NUM_CLASSES, 1);
    printf('Correct: %.2f %%\n', c*100);
    printf('  Wrong: %.2f %%\n', w*100);

end
