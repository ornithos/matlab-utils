function verticalLine(x, varargin)
    % verticalLine(x)
    %
    % Draw vertical line on plot at x = x.
    %
    % verticalLine(..., 'Color', 'k');
    % verticalLine(..., 'LineWidth', 0.5);
    % verticalLine(..., 'LineStyle', '-');
    % verticalLine(..., 'axis', []);           --> optional specify existing axis
    % verticalLine(..., 'LinesToBack', true);  --> send to back
    
    assert(isnumeric(x) && isvector(x), 'x must be a numeric vector');
    
    optsDefault = struct('Color', 'k', 'LineWidth', 0.5, 'LinesToBack', true, 'axis', [], 'LineStyle', '-');
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
        line(ax, [x(ii), x(ii)], [lim(3), lim(4)], 'Color', opts.Color, 'LineWidth', opts.LineWidth, 'LineStyle', opts.LineStyle);
    end
    
    axis(ax, lim)  % reset axes
    
    % remove from legend / put lines to back
    chtObjs = get(ax,'children');
    nPlots  = numel(chtObjsOrig);
    for ii = (nPlots+1):numel(chtObjs)
        set(get(get(chtObjs(end-ii+1),'Annotation'),'LegendInformation'), 'IconDisplayStyle','off');
    end
    if opts.LinesToBack
        chtObjs = [chtObjs(end-nPlots+1:end); chtObjs(1:end-nPlots)];
        set(ax,'children', chtObjs)
    end
    
    if ~isHeld
        hold(ax, 'off');
    end
end
