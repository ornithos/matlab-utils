function dds = divideddiff(X, y, returnCols)
    % dds = divideddiff(X)
    % outputs divided difference of X = [x0, x1, ..., xk],
    % y = [y0, y1, ..., yk] for ordinates X and function values y in a lower
    % triangular matrix dds. Note that X and Y are stacked columnwise with
    % interpolation points
    
    assert(isnumeric(X) && isvector(X), 'X must be a numeric vector');
    assert(sum(sum(isnan(X))) == 0, 'X cannot contain NaN values');
    
    assert(isnumeric(y) && isvector(y), 'y must be a numeric vector');
    assert(sum(sum(isnan(y))) == 0, 'y cannot contain NaN values');
    
    assert(numel(X) == numel(y), 'X and y must have the same number of points (columns)');
    n = numel(X);
    
    if nargin < 3 || isempty(returnCols)
        returnCols = 1:n;
    end 
    
    dds = NaN(n, max(returnCols));
    dds(:,1) = y(:);
    for ii = 2:max(returnCols)
        for jj = ii:n
            dds(jj,ii) = (dds(jj,ii-1) - dds(jj-1,ii-1))./(X(jj) - X(jj-ii+1));
        end
    end
    
    dds = dds(:, returnCols);
end