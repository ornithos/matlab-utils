function out = numjoin(x, delim)
    %out = numjoin(x, delim)
    %   equivalent of strjoin but for numbers.
    %   eg. numjoin([1 2 3 4 5], ',') = 1,2,3,4,5
    
    if nargin < 2 || isempty(delim)
        delim = ',';
    end
    assert(isvector(x), 'x must be a vector');
    assert(isnumeric(x), 'x must be numeric');
    assert(ischar(delim), 'delim must be a character');
    
    x     = cellstr(num2str(x(:)));
    out   = strjoin(x', delim);
end

