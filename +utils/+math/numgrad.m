function g = numgrad(fn, X, h, shutup)
    % g = numgrad(fn, X h)
    % Returns the numerical gradient of function fn evaluated at X. By
    % default a precision of sqrt(eps) is used. To override, use the h
    % value. The value is calculated via the central derivative.
    %
    % INPUTS:
    %  fn - a function handle which takes a single input.
    %  X  - a scalar/vector/matrix conformable to the function input. 
    %  h  - the value of the difference d to use.
    %
    % OUPUTS:
    %  g  - the gradient (usually of size (numel(X) x d)), where d is
    %       the dimension of the function image. The exception is where
    %       either fn or X is a scalar in which case it is the same size as
    %       the non-scalar quantity.
    
    assert(isa(fn, 'function_handle'), 'fn must be a function handle');
    assert(ismatrix(X) && isnumeric(X), 'X must be a numeric matrix');
    
    if nargin < 4 || isempty(shutup)
        shutup = false;
    end
    if nargin < 3 || isempty(h)
        h = sqrt(eps);
    end
    assert(isscalar(h) && isnumeric(h), 'h must be a numeric scalar');
    
    vX  = X(:);   % vec(X)
    sX  = size(X);
    rsX = sX(2)>1;
    nX  = prod(sX);
    imF = size(fn(X));
    rsF = imF(2)>1;
    g   = zeros(prod(imF), nX);
    
    fnX = fn(X);
    
    for ii = 1:nX
        Xplus       = vX;
        Xplus(ii)   = Xplus(ii) + h;
        % central differences..
%         Xminus      = vX;
%         Xminus(ii)  = Xminus(ii) - h/2;
        
        if rsX
            Xplus   = reshape(Xplus, sX);
%             Xminus  = reshape(Xminus, sX);
        end
        
        % calculate gradient here!
        cG          = (fn(Xplus) - fnX)/h;
        cG          = cG(:);    % vec(cG)
        g(:,ii)     = cG;
    end
    
    if nX == 1 && rsF
        g           = reshape(g, imF);
    elseif rsX && prod(imF)==1
        g           = reshape(g, sX);
    else
        if ~shutup
            warning('Returning gradient as n(fn output) x n(variables)');
        end
    end
end
