function [x, val, fval] = conjugateDirections(A, b, x0, D, opts)
% [x_star, val] = conjugateGradients(A, b, initial, opts)
% A generic (linear) conjugate gradients solver of:
% min_x 0.5*(x-A^(-1)b)'A(x-A^(-1)b)  
%
% INPUTS:
% A       - (matrix) matrix of above (quadratic) objective function
% b       - (vector) constant in above function
% x0      - (vector) initial location for optimisation
% D       - (matrix) each column is a search direction d which collectively 
%           form an A-orthogonal basis for R^d.
% opts    - (struct) options for convergence, maxiter etc.

%% Input Checking
assert(utils.is.numericmatrix(A) && utils.is.square(A), 'A must be a numeric matrix');
assert(isnumeric(A) && any(size(b)==1), 'b must be a numeric vector');

[n,m]    = size(A);
b        = b(:);
x0       = x0(:);
assert(all(size(b)==[n,1]), 'b must be conformable to A');
assert(all(size(x0)==[m,1]), 'x must be conformable to A');

if nargin < 4 || isempty(D)
    D = utils.math.gramSchmidt(eye(size(A,1)), A);
else
    assert(utils.is.numericmatrix(D) && utils.is.square(D), 'D must be a square numeric matrix');
    assert(all(size(D,1)==n), 'D is not the same dimension as A');
end

if nargin < 5
    opts = struct;
end

optsDef     = struct('maxiter',100,'epsilon',1e-3,'verbose',true,'recalcFreq',50);
opts        = utils.struct.structCoalesce(opts, optsDef);


%% ALGO
% The below is not optimised in the same way as classical CG. There only
% need be one matrix-vec operation per iteration.
fval        = NaN(opts.maxiter+2);
x           = x0;

for ii = 1:n
    % calculate residual
    r        = b - A*x;
    rnorm    = r'*r;
    if opts.verbose; fprintf('rnorm is %.6f\n', rnorm); end
    fval(ii) = rnorm;
    
    % remove component of error in direction d
    d        = D(:,ii);
    alpha    = (d'*r)./(d'*A*d);
    x        = x + alpha.*d;
end
r           = b - A*x;
fval(n+1)   = r'*r;
val         = rnorm;
fval        = fval(1:n+1);
end
