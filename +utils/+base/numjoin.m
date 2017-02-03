function out = numjoin(x, delim, dp)
    % out = numjoin(x, delim)
    %   equivalent of strjoin but for numbers.
    %   eg. numjoin([1 2 3 4 5], ',') = 1,2,3,4,5
    %
    % out = numjoin(x, delim, dp)
    %   specify number of decimal places to keep. If desired, a printf
    %   style format can be specified (eg. %3.4fe) if more control reqd.
    
    if nargin < 2 || isempty(delim)
        delim = ',';
    end
    
    if nargin < 3 || isempty(dp)
        dp = '%.4f';
    elseif isnumeric(dp)
        dp = sprintf('%%.%df', dp);
    end
    
    assert(isvector(x), 'x must be a vector');
    assert(isnumeric(x), 'x must be numeric');
    assert(ischar(delim), 'delim must be a character');
    
    x     = cellstr(num2str(x(:), dp));
    out   = strjoin(x', delim);
end

