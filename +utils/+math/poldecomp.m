function [R U V] = poldecomp(F)
%POLDECOMP  Performs the polar decomposition of a regular square matrix.
%   [R U V] = POLDECOMP(F) factorizes a non-singular square matrix F such
%   that F=R*U and F=V*R, where
%   U and V are symmetric, positive definite matrices and
%   R is a rotational matrix
%
% ------ 2016-12-15 Alex Bird ------------------------------
% Took original code from Zoltán Csáti, and entirely changed the method to
% use SVD as more efficient and more stable. Outputs still the same.

    assert(isnumeric(F), 'input must be matrix');
    assert(numel(unique(size(F)))==1, 'Matrix must be square');

    [U1, S, V1] = svd(F, 'econ');
    R = U1*V1';
    U = V1*S*V1';
    V = U1*S*U1';

end