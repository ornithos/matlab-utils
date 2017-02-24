function P = vecPermTranspose(m, n)
    % P = vecPermTranspose(m, n)
    % returns the vec-permutation operator P that transforms
    %
    % P vec(A) = vec(A')
    %
    % This may have a special name, but I'm unable to find it at present.
    % 
    % INPUTS:
    %  m      - original number of *ROWS* of matrix
    %  n      - original number of *COLS* of matrix
    %
    
    assert(utils.is.scalarint(m), 'm must be a scalar int');
    assert(utils.is.scalarint(n), 'n must be a scalar int');
    
    mn   = m*n;
    A    = reshape(1:mn, m, n);
    
    orig = A(:);
    
    A    = A';
    new  = A(:);
    
    P    = sparse(orig, new, ones(mn,1), mn, mn);
end