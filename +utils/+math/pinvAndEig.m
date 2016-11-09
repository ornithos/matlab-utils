function [inverse, eigv] = pinvAndEig(A, tol)

    [U,S,V] = svd(A,'econ');
    s = diag(S);
    if nargin < 2 
        tol = max(size(A)) * eps(norm(s,inf));
    end
    r1 = sum(s > tol)+1;
    V(:,r1:end) = [];
    U(:,r1:end) = [];
    s(r1:end) = [];
    eigv = s;
   
    s = 1./s(:);
    inverse = (V.*s.')*U';
end