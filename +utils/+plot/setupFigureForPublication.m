function setupFigureForPublication(varargin)
    % setupFigureForPublication(fig)
    % setup dimensions and line colors (currently optimised for 2x2). fig
    % is a given fighandle (may be omitted).
    %
    % setupFigureForPublication(... 'Dimensions', false)
    % will not rescale dimensions
    %
    % setupFigureForPublication(... 'Colours', false)
    % will not redo line colours
    %
    
    if nargin < 1 || ~isa(varargin{1}, 'matlab.ui.Figure')
        fighandle = gcf;
    else
        varargin(1) = [];
    end
    
    optsDefault = struct('Dimensions', true, 'Colours', true, 'startBlack', false);
    opts        = utils.base.processVarargin(varargin, optsDefault);
    
    if opts.Dimensions
        fighandle.Position = [fighandle.Position(1:2), 700, 500];
    end
    
    if opts.Colours
        N = numel(fighandle.Children);
        
        for ii = 1:N
            ax = fighandle.Children(ii);
            if strcmp(ax.Visible,'on') && numel(ax.Children) > 0 && isa(ax, 'matlab.graphics.axis.Axes')
                lines  = ax.Children;
                nlines = numel(lines);
                for jj = 1:nlines
                    if all(all(isnan(lines(jj).YData)))
                        lines(jj).delete;
                    end
                end
                lines  = ax.Children;
                nlines = numel(lines);
                cols = utils.plot.distinguishable_colors(nlines, opts.startBlack);
                
                if nlines == 1
                    lines(1).Color = [0 0 0];
                else
                    for jj = 1:nlines
                        lines(jj).Color = cols(nlines-jj+1,:);
                    end
                end
            end
        end
    end
end


%set(subplot(3,1,1), 'Position', [x, y, w, h])
%set(subplot(3,1,1), 'Position', [0.05, 0.69, 0.92, 0.27])
%set(subplot(3,1,2), 'Position', [0.05, 0.37, 0.92, 0.27])
%set(subplot(3,1,3), 'Position', [0.05, 0.05, 0.92, 0.27])