function out = kernelExpQuad(X, sigma)
    % assume x stacked in columns (each column is an obs)
    % Not especially efficient since allocates both upper and lower
    % diagonal of symmetric matrix independently.
    sumX2 = sum(X.^2,1);
    quad  = bsxfun(@plus, sumX2, sumX2');
    quad  = quad - 2*X'*X;
    const = - 1./(2 * sigma^2);
    out   = exp(const.*quad);
end