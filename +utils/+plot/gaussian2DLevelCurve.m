function coods = gaussian2DLevelCurve(alpha, mu, sigma, ncoods)
    % gaussian2DLevelCurve(alpha, mu, sigma, ncoods)
    % Generate coordinates for an alpha-level curve of a Gaussian with
    % specified mean and variance (mu, sigma). ncoods specifies the number
    % of co-ordinates governing the curve.
    %
    % OUTPUT:
    % coods   - (ncoods x 2) matrix of coordinates for the level curve
    
    assert(all(size(mu)==[2,1]), 'mu must be 2x1 vector');
    assert(all(size(sigma)==[2,2]), 'sigma must be 2x2 vector');
    
    if nargin == 3
        ncoods = 100;
    elseif nargin < 3
        error('Insufficient number of arguments. Should be (alpha, mu, sigma, ncoods)');
    end
    
    [U, S, V] = svd(sigma);
    
    % precision eigenvalue scaling
    dir1  = sqrt(S(1,1));
    dir2  = sqrt(S(2,2));
    coods = linspace(0, 2*pi, ncoods)';
    coods = [dir1.*cos(coods), dir2.*sin(coods)].*alpha;
    
    % project onto basis of ellipse
    coods = (V * coods')';
    
    % add mean
    coods = bsxfun(@plus, coods, [mu(1), mu(2)]);
end