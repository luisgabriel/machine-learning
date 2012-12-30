function prototypes = generate_prototypes(data, numClasses, numProt)
    prototypes = [];
    numAttributes = size(data, 2) - 1;
    for classId = 1 : numClasses
        instances = data(data(:, 1) == classId, :);
        instances = instances(:, 2:numAttributes+1);

        if size(instances) > 0
            classMean = mean(instances);
            classVariance = var(instances);
            randomMatrix = randn(numProt, numAttributes);

            newProts = bsxfun(@times, sqrt(classVariance), randomMatrix);
            newProts = bsxfun(@plus, classMean, newProts);
            prototypes = [prototypes; [zeros(numProt, 1)+classId newProts]];
        end
    end
end
