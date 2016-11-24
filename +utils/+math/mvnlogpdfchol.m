function p = mvnlogpdfchol(X, mu, sigmachol)
    % re-using elements of MATLAB's mvnpdf for when we already have the
    % cholesky decomposition of the covariance matrix.
    %
    % Returns the log density of X ~ N(mu, sigmachol*sigmachol')
    %
    % INPUTS:
    %  X         - (n x d) matrix of datapoints stacked in rows
    %  mu        - (1 x d) mean mu
    %  sigmachol - (d x d) matrix of cholesky decomposition of sigma
    
    [n, d]          = size(X);
    [mn, md]        = size(mu);
    if md ~= d; mu = mu'; end
    assert(isequal(size(mu), [1,d]), 'mu must be conformable to num. columns of X');
    assert(isequal(size(sigmachol), [d,d]), 'sigmachol is not conformable to mu and X');
    
    X_centered      = bsxfun(@minus,X,mu);
    xRinv           = X_centered / sigmachol;
    logSqrtDetSigma = sum(log(diag(sigmachol)));
    quadform        = sum(xRinv.^2, 2);
    p               = -0.5*quadform - logSqrtDetSigma - d*log(2*pi)/2;
end