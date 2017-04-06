function xtint  = colortint(x, amt)
    % xtint = colortint(x, amt)
    % Creates a lighter tint of color x (where x is a n * 3 matrix of rgb
    % values).

    n = size(x, 1);
    assert(size(x, 2) == 3, 'x must be an n-by-3 matrix or RGB values');
    assert(all(all(x >= 0)) && all(all(x <= 1)), ' x must be values in [0,1]');
    assert(isscalar(amt) && amt >= 0 && amt <= 2, 'amt must be scalar in [0 2]');

    if amt <= 1
        xtint = 1 - x;
        xtint = 1 - amt.*xtint;
    else
        non1  = x < 1;
        xtint = x;
        xtint(non1) = (2-amt).*x(non1);
    end    
end