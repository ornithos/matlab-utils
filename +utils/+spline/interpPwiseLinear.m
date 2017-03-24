function yhat = interpPwiseLinear(x, y, xq, returnType)
    % yhat = interpPwiseLinear(x, y, xq)
    % For two vectors x, y each of length n, the function creates a
    % piecewise linear fit between each interpolation point and evaluates
    % the linear fit at each query point xq. Note that no penalties are 
    % used and no noise is assumed, the interpolation is (per the name) exact.
    %
    % CAN ONLY INTERPOLATE FOR QUERY POINTS WITHIN [min(x), max(x)].
    %
    % fn   = interpPwiseLinear(x, y, [], 'function')
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
    
    [~,order] = sort(x);
    x       = x(order);
    y       = y(order);
    
    dds     = utils.spline.divideddiff(x, y, 1:2);
    interpFn  = @(z) linearInterp(dds,x,z); 
    
    if rType == 2
        yhat = interpFn;
    else
        yhat = interpFn(xq);
    end
end

function out = linearInterp(dd, x, z)
    
    x = x(:);
    z = z(:)';
    n = numel(x);
    currng = bsxfun(@ge, z, x(1:n-1)) & bsxfun(@le, z, x(2:n));
    assert(all(any(currng, 1)), 'query points %s not in range [x0, xn] of interpolation points', utils.base.numjoin(find(~any(currng, 1)),[],0)); %#ok
    
    m     = numel(z);
    out   = NaN(size(z));
    
    for ii = 1:m
        tau     = find(currng(:,ii));
        out(ii) = dd(tau(1),1) + (z(ii) - tau(1))*dd(tau(1)+1, 2);
    end
end