%INPUT_FILE = 'data/pima-indians-diabetes.data';
INPUT_FILE = 'data/segment.data';
%INPUT_FILE = 'data/wdbc.data';
%INPUT_FILE = 'data/sonar.data';
NUM_CLASSES = 7;
FOLDS = 10;
PCA = 0;

dataSet = dlmread(INPUT_FILE);
dataSet = normalize_values(dataSet);

k = findstr(INPUT_FILE, '.data');
prefix = INPUT_FILE(1:k-1);
mkdir(prefix);

nfeatures = size(dataSet, 2) - 1;
class = dataSet(:, 1);
data = dataSet(:, 2:nfeatures+1);

for i = 1 : nfeatures
    if PCA == 1
        newDataSet = pca(data, i);
    else
        newDataSet = lda(data', class', NUM_CLASSES, i);
    end

    newDataSet = [class newDataSet];

    folds = split_set(newDataSet, FOLDS, NUM_CLASSES);

    for k = 1 : FOLDS
        if PCA == 1
            dlmwrite(strcat(prefix, '/pca.', int2str(i), '.fold', int2str(k)), folds{k});
        else
            dlmwrite(strcat(prefix, '/lda.', int2str(i), '.fold', int2str(k)), folds{k});
        end
    end
end
