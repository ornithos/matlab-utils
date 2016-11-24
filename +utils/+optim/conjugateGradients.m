function [x, val, fval] = conjugateGradients(A, b, x0, opts)
% [x_star, val] = conjugateGradients(A, b, initial, opts)
% A generic (linear) conjugate gradients solver of:
% min_x 0.5*(x-A^(-1)b)'A(x-A^(-1)b)  
%
% INPUTS:
% A       - (matrix) matrix of above (quadratic) objective function
% b       - (vector) constant in above function
% x0      - (vector) initial location for optimisation
% opts    - (struct) options for convergence, maxiter etc.

%% Input Checking
assert(isnumeric(A) && ismatrix(A), 'A must be a numeric matrix');
assert(isnumeric(A) && any(size(b)==1), 'b must be a numeric vector');
[n,m]    = size(A);
b        = b(:);
x0       = x0(:);
assert(all(size(b)==[n,1]), 'b must be conformable to A');
assert(all(size(x0)==[m,1]), 'x must be conformable to A');

if nargin < 3
    error('Please give A, b and x0 inputs');
elseif nargin == 3
    opts = struct;
end

optsDef     = struct('maxiter',100,'epsilon',1e-3,'verbose',true,'recalcFreq',50);
opts        = utils.struct.structCoalesce(opts, optsDef);


%% ALGO
converged   = false;
fval        = NaN(opts.maxiter+1);

r           = b - A*x0;
d           = r;
dnorm       = r'*r;
del0        = dnorm;
fval(1)     = dnorm;
x           = x0;

for ii = 1:opts.maxiter
    q         = A*d;
    alpha     = dnorm./(d'*q);
    x         = x + alpha.*d;
    
    if false && mod(ii,opts.recalcFreq) > 0
        r = r - alpha*q;
    else
        r = b - A*x;
    end
    
    dnOld     = dnorm;
    dnorm     = r'*r;
    fval(ii+1)= dnorm;
    
    if dnorm < opts.epsilon.^2 * del0
        converged = true;
        if opts.verbose
            fprintf('Converged in %d iterations: dnorm = %.5f\n', ii, dnorm);
            break
        end
    end
    
    beta      = dnorm./dnOld;
    d         = r + beta.*d;
end

if ~converged
    warning('Algorithm did not converge in %d iterations (dnorm: %.5f)', opts.maxiter, dnorm);
end

val = dnorm;
fval= fval(1:ii+1);
end
