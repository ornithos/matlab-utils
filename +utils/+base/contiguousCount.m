function out = contiguousCount(x)
    % contiguousCount
    %   Equivalent to a SELECT x, COUNT(*) OVER (PARTITION by x), except
    %   that only *contiguous* values are considered the same partition.
    %   eg.
    %   |  x     |   contiguousCount |
    %   |--------|-------------------|
    %   |  2     |        3          |
    %   |  2     |        3          |
    %   |  2     |        3          |
    %   |  1     |        2          |
    %   |  1     |        2          |
    %   |  0     |        2          |
    %   |  0     |        2          |
    %   |  2     |        1          |
    %   |--------|-------------------|
    
    assert(isvector(x), 'x is not a vector')
    out = zeros(size(x));
    cnt = 1;
    ss  = 1;
    
    for ii = 2:numel(x)
        if x(ii) ~= x(ii-1)
            out(ss:ii-1) = cnt;
            cnt  = 1;
            ss   = ii;
        else
            cnt = cnt + 1;
        end
    end
    
    out(ss:numel(x)) = cnt;

    
    
end

