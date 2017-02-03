function check = scalarint(x, minnum)
    % check = scalarint(x)
    % A test that x is a scalar integer number
    %
    % check = scalarint(x, minnum)
    % A test that x is a scalar integer number >= minnum
    % For instance, if minnum == 0, we test for natural numbers
    
    if nargin < 2 || isempty(minnum)
        minnum = -Inf;
    end
    
    check = false;
    if isscalar(x) && isnumeric(x) && round(x) == x && x >= minnum
        check = true;
    end
    
end