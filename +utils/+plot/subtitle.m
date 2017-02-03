function [ax,h]=subtitle(varargin)
    %
    % Centers a title over a group of subplots.
    % Returns a handle to the title and the handle to an axis.
    %
    % [ax, h] = subtitle(text)
    % [ax, h] = subtitle(fontsize, text)
    % [ax, h] = subtitle(fontsize, text, ...)
    %
    % These additional arguments can be used as printf arguments in the same
    % way as error messages for example.
    %
    % OUTPUTS:
    % ax      - handle to the axes
    % h       - handle to the title.
    %
    % Adapted from https://www.mathworks.com/matlabcentral/answers/100459-how-can-i-insert-a-title-over-a-group-of-subplots
    %
    % 

    ax = axes('Units','Normal','Position',[.075 .095 .85 .85],'Visible','off');
    set(get(ax,'Title'),'Visible','on')

    if isnumeric(varargin{1})
        title(sprintf('\\fontsize{%d}%s', varargin{:}));
    else
        title(sprintf('%s', varargin{:}));
    end

    if nargout > 1
        h=get(ax,'Title');
    end

end