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

    ax = axes('Units','Normal','Position',[.15 .105 .7 .85],'Visible','off');
    set(get(ax,'Title'),'Visible','on')

    ttl = '';
    if isnumeric(varargin{1})
        ttl = sprintf('\\fontsize{%d}', varargin{1});
        varargin(1) = [];
    end

    ttl = [ttl, varargin{1}];
    varargin(1) = [];
    
    if ~isempty(varargin)
        ttl = sprintf(ttl, varargin{:});
    end
    
    title(ttl);

    if nargout > 1
        h=get(ax,'Title');
    end

end