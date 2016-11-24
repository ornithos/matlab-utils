function X = mmInverseChol(A, R)
    
    % the bad stuff
    B = R'*R;
    X1 = A * inv(B);
    
    % double triangular solve
    X2 = A / R;
    X2 = X2 / R';
    
    % compute cholesky based inverse
    Rinv = inv(R);
    X3   = A * (Rinv * Rinv');
    
    % mldivide
    X4   = A / B;
    
    fprintf('bad = %.4e, cholinv = %.4e, dbltri = %.4e\n', norm(X4-X1), norm(X4 - X3), norm(X4 - X2));
    
    X = X4;
end