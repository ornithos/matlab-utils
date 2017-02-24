function [ax,h]=subtitleRm(fighandle)
    %
    % Removes the (most recent) subtitle from a plot. This is detected
    % because the plot has property 'Visible' = 'off' and has no graphics
    % children. If there exist weird invisible plots in the figure, these 
    % may be destroyed by this operation ...!

    if nargin < 1 || isempty(fighandle)
        fighandle = gcf;
    end
    assert(isa(fighandle, 'matlab.ui.Figure'), 'argument must be figure handle');
    
    N = numel(fighandle.Children);
    for ii = 1:N
        ax = fighandle.Children(ii);
        if strcmp(ax.Visible,'off') && numel(ax.Children) == 0 && isa(ax, 'matlab.graphics.axis.Axes')
            ax.delete;
            break
        end
    end

end