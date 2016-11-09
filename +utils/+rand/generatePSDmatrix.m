function M = generatePSDmatrix(d, n, strictlyPDepsilon)
% algorithm essentially from Roger Stafford
% https://www.mathworks.com/matlabcentral/newsreader/view_thread/163489

% defaults
if nargin < 3 || isempty(strictlyPDepsilon)
    strictlyPDepsilon = 0;
end
docell = true;
if nargin < 2 || isempty(n)
    n = 1;
    docell = false;
end


% type checks
assert(utils.base.isscalarint(n, 1), 'n must be a positive integer');
assert(utils.base.isscalarint(d, 1), 'd must be a positive integer');
assert(isscalar(strictlyPDepsilon) && strictlyPDepsilon >= 0, 'strictlyPD must be a scalar positive number');



% algo
M = cell(n,1);

for ii = 1:n
    A = randn(d);
    [U,~] = eig((A+A')/2); % (Don't really have to divide by 2)
    M{ii} = U*diag(abs(randn(d,1)) + strictlyPDepsilon)*U';
end

if ~docell
    M = M{ii};
end
end