%INPUT_FILE = 'data/pima-indians-diabetes.data';
INPUT_FILE = 'data/sonar.data';
TRAINING_RATE = 0.8;
VALIDATION_RATE = 0.8;
MAX_PROTOTYPES = 10;
NUM_CLASSES = 2;

dataSet = dlmread(INPUT_FILE);
dataSet = normalize_values(dataSet);
[trainingSet, testSet] = split_set(dataSet, TRAINING_RATE, NUM_CLASSES);

% shuffles trainingSet
trainingSet = trainingSet(randperm(size(trainingSet, 1)), :);
[adjustSet, validationSet] = split_set(trainingSet, VALIDATION_RATE, NUM_CLASSES);

k = findstr(INPUT_FILE, '.data');
prefix = INPUT_FILE(1:k-1);
dlmwrite(strcat(prefix, '.train'), adjustSet);
dlmwrite(strcat(prefix, '.val'), validationSet);
dlmwrite(strcat(prefix, '.test'), testSet);

prototypes = generate_prototypes(trainingSet, NUM_CLASSES, MAX_PROTOTYPES);
prototypes = normalize_values(prototypes);
dlmwrite(strcat(prefix, '-', int2str(MAX_PROTOTYPES), '.prot'), prototypes);
