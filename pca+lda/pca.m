function final = pca(dataSet, nfeatures)
    covariance = cov(dataSet);             % find covariance matrix
    [eVector, eValues] = eig(covariance);  % find eigenvectors and eigenvalues of covariance matrix
    [eValues, idx] = sort(diag(eValues));
    eValues = eValues(end:-1:1)';
    eVector = eVector(:, idx(end:-1:1));   % put eigenvectors in order to correspond with eigenvalues
    t = eVector(:, 1:nfeatures);           % 'nfeatures' Principal Components
    prefinal = t' * dataSet';
    final = prefinal';                     % final is normalised data projected onto eigenspace
end
