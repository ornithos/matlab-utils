function verticalLine(x, varargin)
    
    assert(isnumeric(x) && isvector(x), 'x must be a numeric vector');
    
    optsDefault = struct('Color', 'k', 'LineWidth', 0.5, 'LinesToBack', true, 'axis', []);
    opts = utils.base.processVarargin(varargin, optsDefault);
    if isempty(opts.axis)
        ax = gca;
    else
        ax = opts.axis;
    end
    
    N         = numel(x);
    
    %% find axis limits
    lim       = axis(ax);
    chtObjsOrig = get(ax,'children');
    
    isHeld     = ishold(ax);
    hold(ax, 'on');
    
    for ii = 1:N
        line(ax, [x(ii), x(ii)], [lim(3), lim(4)], 'Color', opts.Color, 'LineWidth', opts.LineWidth);
    end
    
    axis(ax, lim)  % reset axes
    
    % put lines to back
    if opts.LinesToBack
        chtObjs = get(ax,'children');
        nPlots  = numel(chtObjsOrig);
        chtObjs = [chtObjs(end-nPlots+1:end); chtObjs(1:end-nPlots)];
        set(ax,'children', chtObjs);
    end
    
    if ~isHeld
        hold(ax, 'off');
    end
end
