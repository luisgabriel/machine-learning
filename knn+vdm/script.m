function process(k, trainingSet, testSet, numClasses, weighted, ntable)
    [c, w] = knn(k, trainingSet, testSet, numClasses, weighted, ntable);
    printf('Correct: %.2f %%\n', c*100);
    printf('  Wrong: %.2f %%\n', w*100);
end

function [trainingSet, testSet] = split_set(dataSet, trainingRate)
    trainingSet = [];
    testSet = [];
    classes = unique(dataSet(:, 1));

    for i = 1 : size(classes, 1)
        classId = classes(i);
        content = dataSet(dataSet(:,1) == classId,:);
        total = size(content, 1);
        pivot = round(total * trainingRate);
        trainingSet = [trainingSet; content(1:pivot, :)];
        testSet = [testSet; content(pivot+1:total,:)];
    end
end

function table = build_table(dataSet, numClasses)
    table = {};

    for i = 2 : size(dataSet, 2)
        column = dataSet(:, i);
        values = unique(column);
%        printf('--> ATRIBUTO %u \n', i);
        for j = 1 : size(values, 1)
            value = values(j);

            % total occurrences of 'value'
            x = size(column(column == value), 1);
            table{1}(value, i) = x;
%            printf('Total de ocorrencias de %u: %u\n', value, x);

            % occurrences of 'value' per class
            for k = 1 : numClasses
                B = dataSet(dataSet(:, 1) == k, i);
                y = size(B(B == value), 1);
%                printf('Ocorrencias de %u na classe %u: %u\n', value, k, y);
                table{i}(value, k) = y;
            end
        end
    end
end

K = [1; 2; 3; 5; 7; 9; 11; 13; 15];
TRAINING_RATE = 0.7;
INPUT_FILE = 'data/balance-scale.data';
NUM_CLASSES = 3;


%dataSet = dlmread(INPUT_FILE);
%[trainingSet, testSet] = split_set(dataSet, TRAINING_RATE);

trainingSet = dlmread('data/SPECT.train') + 1;
testSet = dlmread('data/SPECT.test') + 1;

ntable = build_table(trainingSet, NUM_CLASSES);

printf('<><> Simulation of simple k-NN:');
for i = 1 : size(K)
    printf('\n----> K = %u\n', K(i));
    process(K(i), trainingSet, testSet, NUM_CLASSES, 0, ntable);
end

printf('\n\n<><> Simulation of weighted k-NN:');
for i = 1 : size(K)
    printf('\n----> K = %u\n', K(i));
    process(K(i), trainingSet, testSet, NUM_CLASSES, 1, ntable);
end
