function process(k, data, trainingRate)
    [trainingSet, testSet] = preprocessor(data, trainingRate);
    [c, w] = knn(k, trainingSet, testSet);
    printf('Correct: %.2f %%\n', c*100);
    printf('  Wrong: %.2f %%\n', w*100);
end


process(3, 'data/letter-recognition.data', 0.7);
