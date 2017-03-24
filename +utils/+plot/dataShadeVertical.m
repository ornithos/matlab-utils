function dataShadeVertical(x, y, cmap, varargin)
    
    assert(isnumeric(x) && isvector(x), 'x must be a numeric vector');
    assert(isnumeric(y) && isvector(y), 'y must be a numeric vector');
    assert(all(size(x)==size(y)), 'x and y are not the same size');
    assert(numel(x) > 1, 'require more than one datapoint to shade plot');
    
    assert(isnumeric(cmap) && size(cmap,2) == 3, 'colormap cmap must be numeric matrix of size n x 3');
    assert(size(cmap,1) > 1, 'colormap cmap must have at least 2 rows');
    
    optsDefault = struct('rescale', false, 'edgecolor', 'k', 'edgedetect', 'auto', ...
                        'edgemanual', 0, 'edgesToBack', true, 'axis', []);
    opts = utils.base.processVarargin(varargin, optsDefault);
    if isempty(opts.axis)
        ax = gca;
    else
        ax = opts.axis;
    end
    
    ncols     = size(cmap,1);
    N         = numel(x);
    
    %% find axis limits
    lim       = axis(ax);
    chtObjsOrig = get(ax,'children');
    
    assert(numel(unique(x))==numel(x), 'x values must be unique');
    assert(all(diff(x)>0),'x values must be in ascending order');
    
    border = 0.01;
    height = (1-border/2)*(lim(4)-lim(3));
    bottom = lim(3) + (border/2)*(lim(4)-lim(3));
    pltWidth   = (lim(2)-lim(1));
    
    %% rescale x, y
    if opts.rescale
        x_orig   = x;
        x        = (x - min(x))./range(x);
        x        = lim(1) + x*pltWidth;
    end
    
    y_orig   = y;
    if all(y==y(1))
        % catch div/0 error
        y = ones(size(y)) * 0.5;
    else
        y        = (y - min(y))./range(y);
    end
    
    %%
    ycols      = zeros(N, 3);
    ycols(:,1) = interp1(linspace(0,1,ncols), cmap(:,1), y);
    ycols(:,2) = interp1(linspace(0,1,ncols), cmap(:,2), y);
    ycols(:,3) = interp1(linspace(0,1,ncols), cmap(:,3), y);
    
    if ~opts.rescale
        y = y_orig;
    end
    
    switch opts.edgedetect
        case 'auto'
            % ideally we do this with something like DP-means, but for
            % now do this lame-ass thing
            [tmpy, tmpx] = ecdf(y);
            cutoffs = find(abs(diff(diff(tmpy))) > 0.1) + 1; % + 1 since second deriv.
            if numel(cutoffs) < 1
                cutoffs = mean(tmpy);
            else
                cutoffs = tmpx(cutoffs);
            end
            edges = bsxfun(@le, y(:), cutoffs(:)');
            [~,edges] = max(edges, [], 2);
            edges = [false; abs(diff(edges))>0.5];

        case 'none'
            edges = false(size(y));
        case 'all'
            edges = true(size(y));
        case 'manual'
            assert(isnumeric(opts.edgemanual) || islogical(opts.edgemanual), 'edgemanual is not numeric');
            if isscalar(opts.edgemanual) && ~islogical(opts.edgedetect)
                % scalar threshold
                edges = y(:) < opts.edgemanual;
                edges = [false; false; abs(diff(edges))>0.5];
                edges = edges(1:end-1);
            else
                % manual vector
                assert(numel(opts.edgedetect) == N, 'edgedetect matrix not same size as x or y. Should be string or logical of size(x)');
                edges = opts.edgedetect;
            end
        otherwise
            error('unknown edgedetect argument. Should be in {auto, manual, none, all}');
    end
    
    isHeld     = ishold(ax);
    hold(ax, 'on');
        
    %% Plot
%     imagesc(x, y, cmap);
    for ii = 2:N
        xpos   = x(ii-1);
        wdth   = x(ii)-x(ii-1);
        pos    = [xpos, bottom, wdth, height]; 
        
        if ~all(ycols(ii-1,:)==1) % white
            h=rectangle(ax, 'pos',pos,'facecolor',ycols(ii-1,:),'edgecolor','none');
        end
        
        if edges(ii)
            utils.plot.verticalLine(pos(1), 'axis', ax, 'Color', opts.edgecolor, 'LinesToBack', false)
        end
    end

    axis(ax, lim)  % reset axes
    
    % put rectangles to back
    chtObjs = get(ax, 'children');
    nLines  = numel(chtObjsOrig);
    chtObjs = [chtObjs(end-nLines+1:end); chtObjs(1:end-nLines)];
    set(ax,'children', chtObjs);
    
    if ~isHeld
        hold(ax, 'off')
    end
end
%     %position the box in the centre of x-axis, 1% wide, full height of axis
%     border = 0.01;
%     width  = 1 - border;
%     pos    = [(lim(1)+lim(2))/2 lim(3) width*(lim(2)-lim(1)) (lim(4)-lim(3))]; 
%     % a grey box with no edge
%     h=rectangle('pos',pos,'facecolor',[.8 .8 .8],'edgecolor','none');