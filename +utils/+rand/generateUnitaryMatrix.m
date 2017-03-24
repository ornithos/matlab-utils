function Q = generateUnitaryMatrix(n, field)
    % Q = generateUnitaryMatrix(n)
    %
    % Generates a real matrix of size n x n for which all eigenvalues are
    % in {+1, -1}. These correspond either to reflections / rotations
    % across the different coordinates. The matrices are generated
    % according to a Haar measure which roughly corresponds to a uniform
    % distribution over eigenvalues.
    %
    % Q = generateUnitaryMatrix(m, 'complex')
    % The method used is to orthonormalise random normal matrices according
    % to the method in section 5, Mezzadri 2007, How to generate random 
    % matrices from the classical compact groups.
    % https://arxiv.org/pdf/math-ph/0609050.pdf
    
    if nargin < 2 || isempty(field) ||strcmpi(field, 'real')
        Z     = randn(n,n);
    elseif strcmpi(field, 'complex')
        Z     = randn(n,n) + i*randn(n,n);
    else
        error('unknown ''field'' specified. Must be ''real'' or ''complex''');
    end
    
    [Q,R] = qr(Z);
    D     = diag(R)./abs(diag(R));
    Q     = Q*diag(D);
end
    