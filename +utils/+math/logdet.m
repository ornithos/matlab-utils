function out = logdet(X)
% out = logdet(X)
% Numerically stable and efficient way of calculating log(det(X)).

[L,p]   = chol(X);
if p > 0
    % not positive definite
    [~, s, ~]   = svd(X); 
    out         = sum(log(diag(s) + 1.0e-20));  % Kevin Murphy (1e-20 for stability)
else
    % positive definite, can use cholesky
    out     = 2*sum(log(diag(L)));
end
