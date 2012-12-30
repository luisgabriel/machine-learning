%INPUT_FILE = 'data/pima-indians-diabetes.data';
INPUT_FILE = 'data/wdbc.data';
%INPUT_FILE = 'data/sonar.data';
TRAINING_RATE = 0.75;
NUM_CLASSES = 2;

dataSet = dlmread(INPUT_FILE);
dataSet = normalize_values(dataSet);
[trainingSet, testSet] = split_set(dataSet, TRAINING_RATE, NUM_CLASSES);
[trainingSet, testSet] = cv_ordering(trainingSet, testSet);

k = findstr(INPUT_FILE, '.data');
prefix = INPUT_FILE(1:k-1);

dlmwrite(strcat(prefix, '.train'), trainingSet);
dlmwrite(strcat(prefix, '.test'), testSet);
