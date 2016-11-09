classdef objProgressBar < handle
    properties (Access = public)
        currOutputLen = 0;
        text          = '';
        startTime     = 0;
    end
    
    properties (Access = private)
        maxLen   = 0;
        curPct   = 0;
        showPct  = false;
        showTime = false;
    end
    
    methods (Static = true, Access = public)
        function td = getInstance(varargin)

            % Import the Teradata package.
            import tesco.teradata.*

            % Call helper function.
            td = getInstanceHelper(varargin{:});
            
            % This function is needed in order to avoid a bug in MATLAB
            % R2014a that causes issues when deploying a singleton class (a
            % class containing persistent variables) that is executed by
            % multiple MCRs simultaneously (as is the case when deploying
            % to MATLAB Production Server).

        end
    end
    
    methods (Access = public)
        % constructor
        function obj = objProgressBar
        end
        
        function newProgressBar(obj, text, maxLen, showPct, showTime)
            if obj.maxLen > 0
                warning('Progress Bar is already initialised. Use method ''.finish'' in future. Re-initialising anyway...');
            end
            
            if nargin < 5 || isempty(showTime)
                showTime = false;
            end
            
            if nargin < 4 || isempty(showPct)
                showPct = false;
            end
            
            assert(ischar(text), 'text must be a character string');
            assert(isnumeric(maxLen) && isscalar(maxLen) && maxLen > 0, 'maxLen must be a positive integer');
            assert(islogical(showPct) && isscalar(showPct), 'showPct must be true or false');
            assert(islogical(showTime) && isscalar(showTime), 'showTime must be true or false');
            
            obj.text          = text;
            obj.maxLen        = maxLen;
            obj.showPct       = showPct;
            obj.showTime      = showTime;
            obj.startTime     = now;
            obj.currOutputLen = 0;
        end
        
        % update string text
        function updateText(obj, text)
            obj.text          = text;
        end
        
        % print
        function obj = print(obj, pct)
            assert(obj.maxLen > 0, 'Progress Bar is not initialised.');
            assert(isnumeric(pct) && isscalar(pct), 'pct must be a numeric scalar');
            assert(pct >= 0 && pct <= 1, 'pct must be between 0 and 1');

            numBars    = round(pct*obj.maxLen);
            
            % prefix with time (if applicable)
            if obj.showTime
                printOut  = sprintf('(%s) %s', datestr(now, 'HH:MM:SS'), obj.text);
            else
                printOut   = obj.text;
            end
            
            % clear screen
            obj.clearConsole;
            
            % bars
            if numBars > 0
                printOut = [printOut, repmat('|', 1, numBars)];
            end
            
            if numBars < obj.maxLen
                printOut = [printOut, repmat('.', 1, obj.maxLen - numBars)];
            end
            
            % percentage
            if obj.showPct
                printOut = [printOut, sprintf(' (%02.1f%%%%)', pct*100)];
            end
            
            fprintf(printOut);
            obj.currOutputLen = numel(printOut)-1*obj.showPct;
            
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
            obj.maxLen = 0;
            obj.curPct = 0;
            obj.currOutputLen = 0;
            obj.text = '';
            obj.startTime = 0;
            obj.showTime  = 0;
            fprintf('\n');
        end
    end

end