function yhat = interpGlobalPoly(x, y, xq, returnType)
    % yhat = interpGlobalPoly(x, y, xq)
    % For two vectors x, y each of length n, the function creates a degree
    % n (global) polynomial, and evaluates the polynomial at each query
    % point xq. Note that no penalties are used and no noise is assumed,
    % the interpolation is (per the name) exact.
    %
    % NOTE THAT THIS IS A NOTORIOUSLY BADLY BEHAVED APPROXIMATION RELATING
    % TO THE COLLINEARITY OF MONOMIAL FUNCTIONS. IT SHOULD NOT BE USED
    % EXCEPT FOR COMPARISON OR PEDAGOGICAL REASONS.
    %
    % fn   = interpGlobalPoly(x, y, [], 'function')
    % Return the interpolating function for use later.
    %
    % See Conte and De Boor - Numerical Analysis
    
    assert(isnumeric(x) && isnumeric(y) && isnumeric(xq), 'first 3 arguments must be numeric');
    assert(isvector(x) && isvector(y) && isnumeric(xq), 'first 3 arguments must be vectors');
    if nargin == 4
        rType = strcmpi(returnType, {'VALUES', 'FUNCTION'});
        assert(any(rType), 'returnType must be one of ''values'', ''function''');
        rType = find(rType);
    else
        rType = 1;
    end
    
    dds     = utils.spline.divideddiff(x, y);
    dds     = dds(numel(x),:);
    polyfn  = @(z) polyInterpNewton(dds,x,z); 
    
    if rType == 2
        yhat = polyfn;
    else
        yhat = polyfn(xq);
    end
end

function out = polyInterpNewton(ddBottom, x, z)
    out   = 0;
    n     = numel(x);
    for ii = 1:n
        out = ddBottom(n - ii + 1) + (z - x(ii)).*out;
    end
end