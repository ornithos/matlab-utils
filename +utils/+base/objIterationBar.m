classdef objIterationBar < handle
    properties (Access = public)
        currOutputLen = 0;
        text          = '';
        prefix        = '';
        postfix       = '';
        startTime     = 0;
    end
    
    properties (Access = private)
        maxLen   = 0;
        curPct   = 0;
        showElapsed = false;
        maxIter     = 0;
    end
    
    methods (Access = public)
        % constructor
        function obj = objIterationBar
        end
        
        function newIterationBar(obj, text, maxIter, showElapsed, prefix, postfix)
            if obj.maxLen > 0
                warning('Progress Bar is already initialised. Use method ''.finish'' in future. Re-initialising anyway...');
            end
            
            if nargin < 6 || isempty(postfix)
                postfix = '';
            end
            
            if nargin < 5 || isempty(prefix)
                prefix = '';
            end
            
            if nargin < 4 || isempty(showElapsed)
                showElapsed = false;
            end
            
            if nargin < 3 || isempty(maxIter)
                maxIter = 0;
            end
            
            assert(ischar(text), 'text must be a character string');
            assert(isnumeric(maxIter) && isscalar(maxIter));
            assert(islogical(showElapsed) && isscalar(showElapsed), 'showElapsed must be true or false');
            
            obj.text          = text;
            obj.prefix        = prefix;
            obj.postfix       = postfix;
            obj.maxIter       = maxIter;
            obj.showElapsed   = showElapsed;
            obj.startTime     = now;
            obj.currOutputLen = 0;
        end
        
        % update string text
        function updateText(obj, text)
            obj.text          = text;
        end
        
        % print
        function obj = print(obj, iternum, delta)
            assert(obj.maxIter > 0, 'maxIter must be a positive integer');
            assert(isnumeric(iternum) && isscalar(iternum), 'iternum must be a numeric scalar');
            if nargin < 3
                delta = [];
            end
            
            % prefix with time (if applicable)
            if obj.showElapsed
                printOut  = sprintf('%s(%s) %s%d', obj.prefix, obj.elapsedTime('MM:SS'), obj.text, iternum);
            else
                printOut  = sprintf('%s(%s) %s%d', obj.prefix, datestr(now, 'HH:MM:SS'), obj.text, iternum);
            end
            
            if obj.maxIter > 0
                printOut = [printOut, sprintf(' of %d', obj.maxIter)];
            end
            
            if ~isempty(delta)
                printOut = [printOut, sprintf(' %s %.3f', obj.postfix, delta)];
            end
            
            % clear screen
            obj.clearConsole;
            
            fprintf(printOut);
            obj.currOutputLen = numel(printOut);
            
            return
        end
        
        % get elapsed time from initialisation
        %   default: return HH:MM:SS.
        %   Specify 0 for datenum absolute value
        %    or another date format (see datestr for details)
        function elapsT = elapsedTime(obj, dateFmt)
            elapsT = now - obj.startTime;
            
            if nargin < 2 || isempty(dateFmt)
                dateFmt = 'HH:MM:SS';
            end
            
            if dateFmt ~= 0
                elapsT = datestr(elapsT, dateFmt);
            end
        end
        
        % delete current output
        function clearConsole(obj)
            if obj.currOutputLen > 0
                fprintf(repmat('\b', 1, obj.currOutputLen));
                obj.currOutputLen = 0;
            end
        end
        
        % cleanup (object uninitialise / new line)
        function finish(obj)
            obj.text          = '';
            obj.maxIter       = 0;
            obj.showElapsed   = 0;
            obj.startTime     = 0;
            obj.currOutputLen = 0;
            fprintf('\n');
        end
    end

end