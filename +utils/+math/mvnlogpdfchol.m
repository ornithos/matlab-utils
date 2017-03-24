function p = mvnlogpdfchol(X, mu, sigmachol, noCheck)
    % re-using elements of MATLAB's mvnpdf for when we already have the
    % cholesky decomposition of the covariance matrix.
    %
    % Returns the log density of X ~ N(mu, sigmachol*sigmachol')
    %
    % INPUTS:
    %  X         - (n x d) matrix of datapoints stacked in rows
    %  mu        - (1 x d) mean mu
    %  sigmachol - (d x d) matrix of cholesky decomposition of sigma
    %  noCheck   - (bool) switch off input checking (production) - default = false
    
    if nargin < 4
        noCheck = false;
    end
    
    [n, d]          = size(X);
    
    if ~noCheck
        [mn, md]        = size(mu);
        if md ~= d; mu = mu'; end
        if ~isempty(mu); assert(isequal(size(mu), [1,d]), 'mu must be conformable to num. columns of X'); end
        assert(isequal(size(sigmachol), [d,d]), 'sigmachol is not conformable to mu and X');
    end
    
    if ~isempty(mu)  % assume empty mu is all zeros
        X_centered      = bsxfun(@minus,X,mu);
    else
        X_centered      = X;
    end
    
    xRinv           = X_centered / sigmachol;
    logSqrtDetSigma = sum(log(diag(sigmachol)));
    quadform        = sum(xRinv.^2, 2);
    p               = -0.5*quadform - logSqrtDetSigma - d*log(2*pi)/2;
end