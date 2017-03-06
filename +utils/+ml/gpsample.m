function out = gpsample(x, n, kernel, sigma, epsilon)
    % out = gpsample(x, n, kernel, sigma, epsilon)
    % Obtain n samples from a Gaussian Process with sample positions n.
    % Kernel is fixed to be exponentiated quadratic (or SE) for now, for
    % computational convenience.
    %
    % INPUTS:
    % x       - (vector) sampling points
    % n       - (scalar) number of samples to draw
    % kernel  - (string) kernel type (currently only EQ supported)
    % sigma   - (scalar) width of kernel
    % epsilon - (scalar) noise of process (> 0 for pos. def.)
    %
    % OUPTUTS
    % out     - (matrix) (numel(x) x n) columnwise matrix of samples.
    %
    
    assert(isnumeric(x) && isvector(x), 'x must be a numeric vector of sample points');
    if nargin < 2 || isempty(n)
        n = 1;
    else
        assert(utils.is.scalarint(n), 'n must be a scalar number of samples to return');
    end
    
    if nargin < 3 || isempty(kernel)
        kernel = 'EQ';
    end
    if nargin < 4 || isempty(sigma)
        sigma = 1;
    end
    
    if nargin < 5 || isempty(epsilon)
        epsilon = 1e-9;
    end
    
    if ~strcmpi(kernel, 'EQ')
        error('only exponentiated quadratic implemented at present');
    end
    
    %%
    N = numel(x);
    K = utils.ml.kernelExpQuad(x, sigma);
    K = K + eye(N) * epsilon;
    
    % sample
    cholK = chol(K);
    out   = zeros(N, n);
    for ii = 1:n
        out(:,ii) = cholK' * randn(N, 1);
    end
end