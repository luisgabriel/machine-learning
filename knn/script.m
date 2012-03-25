function process(k, data, trainingRate, numClasses, weighted)
    [trainingSet, testSet] = preprocessor(data, trainingRate);
    [c, w] = knn(k, trainingSet, testSet, numClasses, weighted);
    printf('Correct: %.2f %%\n', c*100);
    printf('  Wrong: %.2f %%\n', w*100);
end


K = [1; 2; 3; 5; 7; 9; 11; 13; 15];
TRAINING_RATE = 0.7;
INPUT_FILE = 'data/segment.data';
NUM_CLASSES = 7;

printf('<><> Simulation of simple k-NN:');
for i = 1 : size(K)
    printf('\n----> K = %u\n', K(i));
    process(K(i), INPUT_FILE, TRAINING_RATE, NUM_CLASSES, 0);
end

printf('\n\n<><> Simulation of weighted k-NN:');
for i = 1 : size(K)
    printf('\n----> K = %u\n', K(i));
    process(K(i), INPUT_FILE, TRAINING_RATE, NUM_CLASSES, 1);
end
