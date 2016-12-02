function tf = int(x, tol)
    % tf = int(x, tol)
    % Test if argument is integer valued double. (Note MATLAB's integer is
    % a fairly useless class).
    
    if any(~isnumeric(x))
        tf = false;
        return
    end
    
    if nargin < 2
        tol = 15;
    elseif tol < 1
        tol = round(-log(tol),0);
    end
    
    tf = round(x,0) == round(x, tol);
end