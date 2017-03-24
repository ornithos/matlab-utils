function v = num2idx(x, type)
    % ix = num2idx(x)
    % Creates a (large) 1-hot vector v from a (short) vector whose elements
    % correspond to the elements of v which are one.
    %
    % ix = num2idx(x, 'sparse');
    % ix = num2idx(x, 'full');
    % force the output to be either sparse or full. Otherwise, type is
    % chosen dynamically by maximum value (> 10^4 is sparse)
    assert(all(utils.is.int(x)) && isvector(x), 'x must be an integer-valued (of type double) scalar');
    if nargin > 1
        makefull   = strcmpi(type, 'full');
        makesparse = strcmpi(type, 'sparse');
        assert(makefull || makesparse, 'type must be ''full'' or ''sparse''');
    else
        makefull = max(x) < 10^4;
    end
    
    v = sparse(x, ones(size(x)), true(size(x)));
    if makefull
        v = full(v);
    end
end