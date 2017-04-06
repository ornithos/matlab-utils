classdef subUnderplot < handle
    % Create a subplot-like array of underplots. Access is intended to be
    % as easy as subplot, but have to call underplot methods through this
    % wrapper.
    %
    % subunder = subUnderplot(m, n, k, mainPct);
    %    creates a m x n grid of underplots.
    %    If k and mainPct are scalar, k is the number of underplots in each
    %    figure, and mainPct is the size of the main plot. Each of these
    %    arguments can be vectorised: scalar case is simply recycled.
    %
    % example:
    %    create a 2x2 grid of underplots each with 1 subordinate plots and
    %    70% of the subfigure taken up by the main plot.
    %
    %          subUnPlot = utils.plot.subUnderplot(2,2,1,0.7);
    %
    %    add a plot to the main window of the subfigure on row 2, column 1
    %          subUnPlot(2,1).plot('main', 1:4, [1 0 1 0]);
    %
    
    properties
        underplots
    end
    methods
        function obj = subUnderplot(m, n, k, mainPct, varargin)
            optsDefault = struct;
            optsDefault.borderHoriz     = 0.05;
            optsDefault.borderHorizBtwn = 0.04;
            optsDefault.borderVert      = 0.05;
            optsDefault.borderVertBtwn  = 0.04;
            optsDefault.plotOnly        = m*n;     % only create plots for the first plotOnly axes.
            optsDefault.opts            = struct;  % underplot opts
            opts = utils.base.processVarargin(varargin, optsDefault);
            
            assert(isnumeric(m) && utils.is.scalarint(m) && m > 0, 'm must be a scalar int > 0');
            assert(isnumeric(n) && utils.is.scalarint(n) && n > 0, 'n must be a scalar int > 0');
            assert(isnumeric(k) && isvector(k), 'k must be a numeric vector');
            assert(isnumeric(mainPct) && isvector(mainPct), 'mainPct must be a numeric vector');
            
            p = m*n;
            if isscalar(k)
                k = repmat(k, p, 1);
            else
                assert(numel(k) == p, 'k is not the same length as m x n');
            end
            if isscalar(mainPct)
                mainPct = repmat(mainPct, p, 1);
            else
                assert(numel(mainPct) == p, 'mainPct is not the same length as m x n');
            end

            assert(m < 10, 'cannot reasonably view this many underplots. Maybe use subplot?');
            assert(n < 10, 'cannot reasonably view this many underplots. Maybe use subplot?');
            
            clf
            underplots      = cell(m,n);
            availableWidth  = 1 - opts.borderHoriz*2;
            availableHeight = 1 - opts.borderVert*2;
            plotWidth    = (availableWidth - (n-1)*opts.borderHorizBtwn)./n;
            plotHeight   = (availableHeight - (m-1)*opts.borderVertBtwn)./m;
            if any([plotWidth, plotHeight] < 0.01)
                error('Not enough space to plot all charts. Reduce grid or size of borders');
            end
            
            for ii = 1:m
                for jj = 1:n
                    if (ii-1)*n + jj > opts.plotOnly
                        break
                    end
                    left   = opts.borderHoriz + (jj-1)*(plotWidth + opts.borderHorizBtwn);
                    bottom = opts.borderVert  + (m-ii)*(plotHeight + opts.borderVertBtwn);
                    upOpts.position = [left, bottom, plotWidth, plotHeight];
                    upOpts.clf = false;
                    upOpts     = utils.struct.structCoalesce(upOpts, opts.opts);
                    ix         = (ii-1)*n + jj;
                    obj.underplots{ii, jj} = utils.plot.underplot(k(ix), mainPct(ix), upOpts);
                end
            end
            
        end
        
        function sref = subsref(obj,s)
            % obj(i) is equivalent to obj.Data(i)
            switch s(1).type
              case '.'
                 sref = builtin('subsref',obj,s);
              case '()'
                 ll = length(s);
                 curS = s(1);
                 curS.type = '{}';
                 if numel(curS.subs) == 1
                     [m,n] = size(obj.underplots);
                     ss    = curS.subs{1};
                     assert(ss >= 1 && ss <= m*n, 'index must be between 1 and m*n');
                     curS.subs  = {floor((ss - 1)./n)+1, mod(ss-1, m)+1};
                 end
                 sref = builtin('subsref', obj.underplots, curS);
                 
                 if ll > 1
                     curS = s(2:end);
                     sref = builtin('subsref', sref, curS);                     
                 end
                 
              case '{}'
                 error('subUnderplot:subsref',...
                    'Not a supported subscripted reference')
            end
        end
    end
end
            