classdef underplot < handle
    % Create custom plot arrangement with one main plot, and n thin plots
    % underneath (eg. sparklines or heatmaps)
    %
    %   obj = underplot(n, mainPct)
    %   Create underplot object with n thin plots underneath, with mainPct
    %   of space occupied by the main plot
    %
    %   obj.plot('main', ...)
    %   Creates a plot in the main axis of the underplot figure
    %
    %   obj.plot('under', n, ...)
    %   Creates a plot in the nth minor plot axis under the main figure;
    %
    %   obj.getAxis('main')
    %   obj.getAxis('under', n)
    %   Get relevant axis object to manipulate more freely.
    %
    
    properties
        figHandle
        n
        axisMain
        axesThin
        borderHoriz
        borderVert
        underYtickmarks, underXtickmarks
        yAxisLabelMain, yAxisLabelUnder
    end
    methods
        function obj = underplot(n, mainPct, varargin)
            
            % defaults and arg processing
            optsDefault             = struct;
            optsDefault.position    = [0 0 1 1];
            optsDefault.borderHoriz = 0.05;
            optsDefault.borderVert  = 0.05;
            optsDefault.clf         = true;
            
            optsDefault.underYtickmarks  = true;
            optsDefault.underXtickmarks  = false;
            optsDefault.yAxisLabelMain   = '';
            optsDefault.yAxisLabelUnder  = {};
            opts      = utils.base.processVarargin(varargin, optsDefault);
            position  = opts.position;
            
            assert(utils.is.scalarint(n, 0), 'n must be a positive scalar integer');
            assert(isscalar(mainPct) && mainPct < 0.99 && mainPct > 0.01, 'mainPct must be in [0.1,0.99]');
            assert(isnumeric(position) && isvector(position) && numel(position) == 4 && ...
                    all(position <=1) && all(position>=0), 'position must be a 4 element vector in [0,1]');
            
            assert(opts.borderHoriz < 0.49, 'borderHoriz must be less than 0.49 to allow room for plot!');
            assert(opts.borderVert < 0.4, 'borderVert must be less than 0.4 to allow room for plot!');
            
            % reparameterise window position
            wdwWidth    = position(3);% - position(1);
            wdwHeight   = position(4);% - position(2);
            bottom      = position(2);
            top         = bottom + wdwHeight;
            left        = position(1);
            
            % rescale everything by window position
            borderHoriz = opts.borderHoriz * wdwWidth;
            borderVert  = opts.borderVert * wdwHeight;
            mainPct     = mainPct * wdwHeight;
            
            mainPct     = (1 - 2*borderVert)*mainPct;
            mainBottom  = top - (borderVert + mainPct);
            totalWidth  = (wdwWidth - 2*borderHoriz);
            
            %% Start plotting
            if opts.clf
                clf;
            end
            f             = gcf;
            obj.axisMain  = axes(f, 'position', [left+borderHoriz, mainBottom, totalWidth, mainPct]);
            obj.figHandle = f;
            obj.n         = n;
            obj.borderHoriz = borderHoriz;
            obj.borderVert  = borderVert;
            
            %% thin plots
            pctWhitespace = 0.4;
            lenThinPlots  = mainBottom - borderVert - bottom;
            pctPlots      = (1-pctWhitespace) * lenThinPlots;
            
            % calculate dims
            thinBottom   = NaN(n,1);
            thinHeight   = pctPlots./n;
            thinWsHeight  = (lenThinPlots - pctPlots)./n;
            % this thinWsHeight is whitespace all things being equal. I
            % think it looks better if the main plot has a little more
            % space underneath.
            thinWsHeight  = thinWsHeight - 0.5*thinWsHeight./n;
            thinBottom(1) = bottom + borderVert;
            for ii = 2:n
                thinBottom(ii) = thinBottom(ii-1) + thinHeight + thinWsHeight;
            end
            thinBottom = flipud(thinBottom);
            
            obj.axesThin  = cell(n,1);
            for ii = 1:n
                pos = [left+borderHoriz, thinBottom(ii), totalWidth, thinHeight];
                obj.axesThin{ii} = axes(f, 'position', pos);
            end
            
            %% Cosmetics
            % remove x axes labels (except for bottom axis)
            for ii = 1:n-1
                set(obj.axesThin{ii}, 'xticklabel', {[]});
            end
            if ~opts.underXtickmarks
                set(obj.axesThin{n}, 'xticklabel', {[]});
            end
            
            % remove y axes labels if requested
            if ~opts.underYtickmarks
                for ii = 1:n
                    set(obj.axesThin{ii}, 'yticklabel', {[]});
                end
            end
            
            % add labels
            obj.ylabels(opts.yAxisLabelMain, opts.yAxisLabelUnder);

            % save options in case plotting over-writes this.
            obj.underYtickmarks = opts.underYtickmarks;
            obj.underXtickmarks = opts.underXtickmarks;
            obj.yAxisLabelMain  = opts.yAxisLabelMain;
            obj.yAxisLabelUnder = opts.yAxisLabelUnder;
        end
    
        function ax = plot(obj, axisName, varargin)
            
            if isnumeric(axisName)
                plotType = (axisName > 0) + 1;
                varargin = [axisName, varargin];
            else
                axisName = lower(axisName);
                assert(any(ismember(axisName, {'main', 'under'})));
                assert(numel(varargin)>0, 'not enough arguments');

                plotType = find(strcmp(axisName, {'main', 'under'}));
            end
            
            if plotType == 1 
                if utils.is.scalarint(varargin{1}) || isempty(varargin{1})
                    varargin(1) = [];
                end
                assert(numel(varargin) > 1, 'nothing to plot!');
                plot(obj.axisMain, varargin{:});
                mainaxislims = xlim(obj.axisMain);
                for ii = 1:obj.n
                    xlim(obj.axesThin{ii}, mainaxislims);
                end
                ax = obj.axisMain;
            else
                assert(numel(varargin) > 2, 'insufficient arguments for underplot');
                nn = varargin{1};
                assert(utils.is.scalarint(nn) && nn > 0 && nn <= obj.n, 'invalid underplot specification. Must be <= %d', obj.n);
                ax = obj.axesThin{nn};
                varargin(1) = [];
                mainaxislims = xlim(obj.axisMain);
                plot(ax, varargin{:});
                
                % plotting (without hold) overwrites options
                xlim(ax, mainaxislims);
                if nn < obj.n || ~obj.underXtickmarks
                    set(ax, 'xticklabel', {[]});
                end
                if ~obj.underYtickmarks; set(ax, 'yticklabel', {[]}); end
                if ~isempty(obj.yAxisLabelUnder); ylabel(ax, obj.yAxisLabelUnder{nn}); end
            end
        end
        
        function out = getAxis(obj, axisName, axisNum)
            
            % input manipulation
            if isnumeric(axisName) && utils.is.scalarint(axisName) && axisName >= 0 && axisName <= obj.n
                plotType = (axisName > 0) + 1;
                axisNum  = axisName;
            else
                axisName = lower(axisName);
                assert(any(ismember(axisName, {'main', 'under'})));
                plotType = find(strcmp(axisName, {'main', 'under'}));
                if plotType == 1
                    if nargin > 2 && ~isempty(axisNum)
                        warning('ignoring additional arguments');
                    end
                    axisNum = 0;
                else
                    assert(nargin > 2 && ~isempty(axisNum), 'axisNum not specified!');
                    assert(utils.is.scalarint(axisNum) && axisNum > 0 && axisNum <= obj.n, 'invalid underplot specification. AxisNum ust be <= %d', obj.n);
                end
            end
            
            out = obj.getAxisObject(axisNum);
%             % get axes
%             if plotType == 1 
%                 out = obj.axisMain;
%             else
%                 out = obj.axesThin{axisNum};
%             end
%             
%             % check axes ok
%             if ~isvalid(out)
%                 error('Required axis has been deleted. Please create a new underplot object.');
%             end
            
            % select current axes
            axes(out);
        end
        
            
        function ax = hold(obj, holdtype, axisName, axisNum)
            assert(ischar(holdtype) && ismember(holdtype, {'on', 'off'}), 'holdType must be ''on'' or ''off''');
            if nargin < 3
                error('axisName (''main'', ''under'') required');
            end
            if nargin < 4
                axisNum = [];
            end
            ax = obj.getAxis(axisName, axisNum);
            hold(ax, holdtype);
        end
        
        function ax = title(obj, strTitle, axisName, axisNum)
            assert(ischar(strTitle), 'strTitle must be a character string');
            if nargin < 3
                error('axisName (''main'', ''under'') required');
            end
            if nargin < 4
                axisNum = [];
            end
            ax = obj.getAxis(axisName, axisNum);
            title(ax, strTitle);
        end
        
        function lims = xlim(obj, x1, x2, axisName, axisNum)
            if nargin > 3
                if nargin < 5; axisNum = []; end
                ax = obj.getAxis(axisName, axisNum);
            else
                ax = [];
            end
                
            if nargin < 2
                if isempty(ax)
                    x1 = obj.axisMain.XLim;
                else
                    x1 = ax.XLim;
                end
                lims = [x1(1), x1(2)];
                return
            end
            if isnumeric(x1) && numel(x1) == 2 && (nargin < 3 || isempty(x2))
                x2 = x1(2);
                x1 = x1(1);
            end
            
            assert(isnumeric(x1) && isscalar(x1), 'x1 is not numeric scalar');
            assert(isnumeric(x2) && isscalar(x2), 'x2 is not numeric scalar');
            if ~isempty(ax)
                xlim(ax, [x1, x2]);
            else
                xlim(obj.axisMain, [x1, x2]);
                for ii = 1:obj.n
                    xlim(obj.axesThin{ii}, [x1, x2]);
                end
            end
            lims = [x1,x2];
        end
        
        function lims = ylim(obj, y1, y2, axisName, axisNum)
            if nargin > 3
                if nargin < 5; axisNum = []; end
                ax = obj.getAxis(axisName, axisNum);
            else
                ax = [];
            end
                
            if nargin < 2
                if isempty(ax)
                    y1 = obj.axisMain.YLim;
                else
                    y1 = ax.YLim;
                end
                lims = [y1(1), y1(2)];
                return
            end

            if isnumeric(y1) && numel(y1) == 2 && (nargin < 3 || isempty(y2))
                y2 = y1(2);
                y1 = y1(1);
            end

            assert(isnumeric(y1) && isscalar(y1), 'y1 is not numeric scalar');
            assert(isnumeric(y2) && isscalar(y2), 'y2 is not numeric scalar');
            if ~isempty(ax)
                ylim(ax, [y1, y2]);
            else
                ylim(obj.axisMain, [y1, y2]);
                for ii = 1:obj.n
                    xlim(obj.axesThin{ii}, [y1, y2]);
                end
            end
            lims = [y1,y2];
        end
        
        function kludge = ylabels(obj, yAxisLabelMain, yAxisLabelUnder)
            if ~isempty(yAxisLabelMain)
                if iscell(yAxisLabelMain)
                    assert(numel(yAxisLabelMain), 'yAxisLabelMain should contain only one element');
                    lab = yAxisLabelMain{1};
                else
                    assert(ischar(yAxisLabelMain), 'yAxisLabelMain should be a character string');
                    lab = yAxisLabelMain;
                end
                ylabel(obj.axisMain, lab);
            end
            
            if nargin > 1 && ~isempty(yAxisLabelUnder)
                assert(iscellstr(yAxisLabelUnder), 'yAxisLabelUnder must be a cell of character strings');
                assert(numel(yAxisLabelUnder)==obj.n, 'yAxisLabelUnder must contain a label for each of the %d subordinate axes');
                for ii = 1:obj.n
                    ylabel(obj.axesThin{ii}, yAxisLabelUnder{ii});
                end
            end
            kludge = [];
        end
        
        function ax = legend(obj, cellLegend, axisName, axisNum)
            assert(iscellstr(cellLegend), 'cellLegend must be a cell of character strings');
            if nargin < 3
                error('axisName (''main'', ''under'') required');
            end
            if nargin < 4
                axisNum = [];
            end
            ax = obj.getAxis(axisName, axisNum);
            legend(ax, cellLegend);
        end
        
        function newrotation = rotateYlabels(obj, newrotation, varargin)
            togglerotation = false;
            if nargin < 2 || isempty(newrotation)
                togglerotation = true;
            else
                assert((isnumeric(newrotation) && isscalar(newrotation) ) || ischar(newrotation), ...
                        'newrotation must be angle of rotation in degrees, or ''horizontal''/''vertical''');
                if ischar(newrotation)
                    switch newrotation
                        case 'horizontal'
                            newrotation = 90;
                        case 'vertical'
                            newrotation = 0;
                        otherwise
                            error('character input for newrotation must be ''horizontal''/''vertical''');
                    end
                end
            end
            axs = obj.charSwitchMultipleAxes(varargin{:});
            
            for ii = axs
                ax = obj.getAxisObject(ii);
                if togglerotation
                    cRotation = get(get(ax,'YLabel'),'Rotation');
                    newrotation = 0 + (cRotation == 0)*90;
                end
                set(get(ax,'YLabel'),'Rotation', newrotation);
                set(get(ax, 'YLabel'),'HorizontalAlignment','right', 'VerticalAlignment', 'middle');
            end
        end
        
    end
    
    
    
    %% Internals
    methods (Hidden=true, Access=public)
        % Enable subscripting of underplot object
        
        
        function sref = subsref(obj,s)
            % obj(i) is equivalent to obj.Data(i)
            switch s(1).type
              case '.'
                 if false && ismember(s(1).subs, {'plot', 'hold'})
                     % no output
                     builtin('subsref',obj,s);
                 else
                     sref = builtin('subsref',obj,s);
                 end
              case '()'
                 if length(s) < 2
                    sref = obj.getAxis(s.subs{1});
                    return
                 else
                    sref = builtin('subsref',obj,s);
                 end
              case '{}'
                 error('underplot:subsref',...
                    'Not a supported subscripted reference')
            end
        end
    end
    
    methods (Hidden=true, Access=protected)
        function out = getAxisObject(obj, num)
            if num == 0
                out = obj.axisMain;
            else
                out = obj.axesThin{num};
            end
            
            % check axes ok
            if ~isvalid(out)
                error('Required axis has been deleted. Please create a new underplot object.');
            end
        end
        
        function axs = charSwitchMultipleAxes(obj, varargin)
            if isempty(varargin)
                axs = 0:obj.n;
            elseif numel(varargin) < 2
                axisName = varargin{1};
                if strcmpi(axisName, 'main')
                    axs = 0;
                elseif strcmpi(axisName, 'under')
                    axs = 1:obj.n;
                else
                    ME = MException('underplot:charSwitchMultipleAxes1','unknown axisname ''%s''', axisName);
                    throwAsCaller(ME);
                end
            else
                axisName = varargin{1};
                if numel(varargin) > 2
                    warning('ignoring additional arguments');
                end
                if strcmpi(axisName, 'main')
                    if numel(varargin) > 1
                        warning('main axis specified: no additional arguments will be utilised');
                    end
                    axs = 0;
                elseif strcmpi(axisName, 'under')
                    axisNum = varargin{2};
                    if ~isnumeric(axisNum)
                        ME = MException('underplot:charSwitchMultipleAxes2','axisNum must be numeric');
                        throwAsCaller(ME);
                    end
                    axisNum = varargin{2};
                    if axisNum > obj.n
                        ME = MException('underplot:charSwitchMultipleAxes3','axisNum doesn''t exist.');
                        throwAsCaller(ME);
                    end
                    axs = axisNum;
                end
            end
        end
    end
end