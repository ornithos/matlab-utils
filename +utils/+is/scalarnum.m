function check = scalarnum(x)
    % check = scalarnum(x)
    % A test that x is a scalar (rational or "real") number
    % fn exists only for readability.. essentially pointless..
    
    check = isscalar(x) && isnumeric(x);
end