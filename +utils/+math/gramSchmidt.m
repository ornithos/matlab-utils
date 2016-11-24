function D = gramSchmidt(X, A)
% Gram Schmidt operations to find a set of orthonormal basis vectors from
% X. If A is specified, the procedure finds A-conjugate vectors, that is if
% (u, v) in basis, u'*A*v = 0 for all u ~= v.
% This will be way, way, way slower than any Gram-Schmidt procedures
% implemented in say LAPACK or other numerical libraries. Not recommended!
% Largely for my own pedagogical reasons.
%
% INPUTS:
% X     - The matrix to orthonormalise
% A     - (optional) define the metric for which the basis is orthonormal.
%
% OUTPUTS:
% D     - the orthogonalised matrix
%

assert(utils.is.numericmatrix(X) && utils.is.square(X), 'X must be a square numeric matrix');
n = size(X,1);
if nargin < 2
    A = eye(n);
else
    assert(utils.is.numericmatrix(A) && utils.is.square(A), 'A must be a square numeric matrix');
end
D = zeros(n);

% pre-allocate Ad, dAd when available.
q     = zeros(n);
denom = zeros(n,1);
beta  = zeros(n,1);

for ii = 1:n
    for jj = 1:ii-1
        beta(jj) = - X(:,ii)'*q(:,jj)./denom(jj);
    end
    % compute new column as linear combo of X and prev D.
    D(:,ii) = X(:,ii) + D(:,1:ii-1)*beta(1:ii-1);
    % pre-compute Ad for future use
    q(:,ii) = A * D(:,ii);
    denom(ii) = D(:,ii)'*q(:,ii);
end

% check
test = NaN(n);
for ii = 1:n
    for jj = 1:n
        test(ii,jj) = D(:,ii)'*A*D(:,jj);
    end
end
% disp(test);
end