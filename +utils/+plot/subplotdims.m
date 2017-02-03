function out = subplotdims(n)
    assert(isscalar(n) && utils.is.int(n), 'n must be a scalar integer');
    if n == 1
        out = [1, 1];
    elseif n <= 6
        out = [ceil(n/2), 2];
    elseif n <= 12
        out = [ceil(n/3), 3];
    elseif n <= 20
        out = [ceil(n/4), 4];
    elseif n <= 30
        out = [ceil(n/5), 5];
    elseif n <= 48
        out = [ceil(n/6), 6];
    elseif n <= 70
        out = [ceil(n/7), 7];
    elseif n <= 96
        out = [ceil(n/8), 8];
    else
        out = [ceil(n/100), 100];
    end
end