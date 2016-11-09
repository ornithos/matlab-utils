function s = seq(x, y, dowarn)
    % seq([a, b])
    %   Creates sequence of unit step using vector inputs as endpoints: ie.
    %   a, a+1, a+2, ... b-1, b.
    %
    % seq(a, b)
    %   Creates sequence of unit step using vector inputs as endpoints: ie.
    %   a, a+1, a+2, ... b-1, b.
    %
    % This is simply a wrapper for the colon operator which allows one to
    % operate on existing vectors of endpoints without messy syntax.
    
    if nargin < 3 || isempty(dowarn); dowarn = true; end
    
    if nargin < 2 || isempty(y)
        assert(isvector(x) && numel(x) >= 2, 'x must be a vector of two elements');
        if dowarn && numel(x) > 2
            warning('x is of length greater than 2: first and last element will be used for sequence');
        end
        s = x(1):x(end);
    else
        assert(isscalar(x) && isscalar(y), 'x and y must be scalar quantities');
        s = x:y;
    end
        
end

