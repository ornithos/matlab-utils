function [C, vals] = findall(x)
 % out = findall(x)
 % runs find on a vector and returns indices of all unique values in the
 % vector in a cell. Typically used to turn a group index vector into a row
 % index vector.
 %
 % This is not the most efficient way of achieving this, but will do for
 % now.
 %
 % INPUTS:
 %   x   -  a vector containing values to group by
 %
 % OUTPUTS:
 %   out -  a cell arry of indices corresponding to each unique value in x
 %          in order.
 %   vals - The unique values of the vector x corresponding to each element
 %          of C
    
    assert(isvector(x) && isnumeric(x), 'x must be a numeric vector');
    vals   = unique(x);
    n      = numel(vals);
    C      = cell(n, 1);
    
    for vv = 1:n
        C{vv} = find(x == vals(vv));
    end
    
end