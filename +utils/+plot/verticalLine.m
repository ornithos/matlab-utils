function verticalLine(x, varargin)
    
    assert(isnumeric(x) && isvector(x), 'x must be a numeric vector');
    
    optsDefault = struct('Color', 'k', 'LineWidth', 0.5, 'LinesToBack', true);
    opts = utils.base.processVarargin(varargin, optsDefault);
    
    N         = numel(x);
    
    %% find axis limits
    lim       = axis;
    chtObjsOrig = get(gca,'children');
    
    isHeld     = ishold;
    hold on;
    
    for ii = 1:N
        line([x(ii), x(ii)], [lim(3), lim(4)], 'Color', opts.Color, 'LineWidth', opts.LineWidth);
    end
    
    axis(lim)  % reset axes
    
    % put lines to back
    if opts.LinesToBack
        chtObjs = get(gca,'children');
        nPlots  = numel(chtObjsOrig);
        chtObjs = [chtObjs(end-nPlots+1:end); chtObjs(1:end-nPlots)];
        set(gca,'children', chtObjs);
    end
    
    if ~isHeld
        hold off
    end
end
