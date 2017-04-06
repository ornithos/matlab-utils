function confidenceInterval(x, mu, bottom, top, varargin)
% confidenceInterval(x, mu, delta)
%   Plot a confidence interval around line mu with (variable) width delta.
%   delta should be a vector of the same length as mu.
%
%   The result will be a transparent grey polygon around mu. Mu is assumed
%   pre-existing and will not be plotted by this function.
%
% confidenceInterval(x, mu, bottom, top)
%   For non-symmetric intervals, the bottom deltas and top deltas can be
%   specified directly. Of course, if 'bottom' and 'top' are absolute
%   rather than relative co-ordinates, simply use mu as the zero vector. A
%   short-hand is built in too using the empty vector
%   (confidenceInterval([], bottom, top)).
%
% confidenceInterval(..., 'axis', ax)
%   Specifies the axis to be plotted on.
%
% confidenceInterval(..., 'facecolor', 'red')
%   Specifies the line color (default null).
%
% Further options: edgecolor, facealpha
%

%% input validation and admin
n     = numel(x);
assert(isnumeric(x) && isvector(x), 'x must be a numeric vector');
assert(isempty(mu) || (isnumeric(mu) && isvector(mu) && numel(mu) == n), 'mu must be a numeric vector of same length as x');

if isempty(mu)
    mu = zeros(n, 1);
else
    if size(mu,2) > 1; mu = mu'; end
end
if size(bottom,2) > 1; bottom = bottom'; end
if size(x,2) > 1; x = x'; end

useDeltaParameterisation = false;
if nargin > 3 
    if ~isempty(top)
        % top, bottom parameterisation
        assert(isnumeric(bottom) && isvector(bottom) && numel(bottom) == n, 'bottom must be a numeric vector of same length as x');
        assert(isnumeric(top) && isvector(top) && numel(top) == n, 'top must be a numeric vector of same length as x');
        top    = mu + top;
        bottom = mu - bottom;
    else
        useDeltaParameterisation = true;
    end
end

if nargin <= 3 || useDeltaParameterisation
    % delta parameterisation
    assert(isnumeric(bottom) && isvector(bottom) && numel(bottom) == n, 'delta must be a numeric vector of same length as x');
    top    = mu + bottom;
    bottom = mu - bottom;
end

optsDefault.axis      = [];
optsDefault.facecolor = [0 0 1];
optsDefault.edgecolor = 'none';
optsDefault.facealpha = 0.3;
opts                  = utils.base.processVarargin(varargin, optsDefault);
    
if isempty(opts.axis)
    ax = gca;
else
    ax = opts.axis;
end

% curYLim = get(ax, 'YLim');
% curXLim = get(ax, 'XLim');

origAx         = gca;
axes(ax);
origHoldStatus = ishold;

hold on;
    
%% Do plot
xcoods    = [x; flipud(x)];
ycoods    = [bottom; flipud(top)];

fill(xcoods, ycoods , 1,....
        'facecolor', opts.facecolor, ...
        'edgecolor', opts.edgecolor, ...
        'facealpha', opts.facealpha);
 
if ~origHoldStatus
    hold off
end

axes(origAx);

end