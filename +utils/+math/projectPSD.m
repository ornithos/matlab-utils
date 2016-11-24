function P = projectPSD(A,eps)
    % P = projectPSD(A)
    % Project a real square matrix A onto the positive semidefinite cone.
    % Source:
    % Higham, Nicholas J. Matrix nearness problems and applications. 
    % University of Manchester. Department of Mathematics, 1988.
    
    AH               = 0.5*(A + A');
    [U,H]            = utils.math.poldecomp(AH);
    P                = 0.5*(AH + H);
    
    % will usually not project to strictly positive definite - will be
    % degenerate. Add eps*I to force full rank by some epsilon > 0.
    if nargin > 1
        P            = P + eps * eye(size(P));
    end
end