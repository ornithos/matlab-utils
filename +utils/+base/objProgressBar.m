classdef objProgressBar < handle
    properties (Access = public)
        currOutputLen = 0;
        text          = '';
        startTime     = 0;
    end
    
    properties (Access = private)
        maxLen   = 0;
        curPct   = 0;
        showPct  = true;
        showTime = true;
        showElapsed = false;
    end
    
    methods (Access = public)
        % constructor
        function obj = objProgressBar
        end
        
        % old syntax newProgressBar(obj, text, maxLen, showPct, showTime)
        function newProgressBar(obj, text, maxLen, varargin)
            
            assert(ischar(text), 'text must be a character string');
            assert(isnumeric(maxLen) && isscalar(maxLen) && maxLen > 0, 'maxLen must be a positive integer');
            
            if numel(varargin) > 0
                if sum(cellfun(@ischar, varargin)) == 0
                    error('progress bar syntax has changed to newProgressBar(obj, text, maxLen, varargin) (eg. ''showElapsed''');
                end
            end
            
            if ismember('showPct', varargin(1:2:end))
                pos        = find(strcmp('showPct', varargin));
                if numel(varargin) < pos + 1; error('all varargin arguments must come in pairs'); end
                obj.showPct = varargin{pos+1};
                assert(isscalar(obj.showPct) && islogical(obj.showPct), 'showPct must be a scalar bool');
                varargin([pos, pos+1]) = [];
            end

            if ismember('showElapsed', varargin(1:2:end))
                pos        = find(strcmp('showElapsed', varargin));
                if numel(varargin) < pos + 1; error('all varargin arguments must come in pairs'); end
                obj.showElapsed = varargin{pos+1};
                obj.showTime    = false;    % <----- Note XOR here
                assert(isscalar(obj.showElapsed) && islogical(obj.showElapsed), 'showElapsed must be a scalar bool');
                varargin([pos, pos+1]) = [];
            end
            
            if ismember('showTime', varargin(1:2:end))
                pos        = find(strcmp('showTime', varargin));
                if numel(varargin) < pos + 1; error('all varargin arguments must come in pairs'); end
                assert(~obj.showElapsed, 'progress bar can show only one of ''time'' or ''elapsed''');
                obj.showTime = varargin{pos+1};
                assert(isscalar(obj.showTime) && islogical(obj.showTime), 'showTime must be a scalar bool');
                varargin([pos, pos+1]) = [];
            end

            if numel(varargin) > 0
                unusedArgs = strjoin(varargin(1:2:end), ',');
                warning('unused args given in input: %s', unusedArgs);
            end
    
            if obj.maxLen > 0
                warning('Progress Bar is already initialised. Use method ''.finish'' in future. Re-initialising anyway...');
            end
            
            obj.text          = text;
            obj.maxLen        = maxLen;
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
            elseif obj.showElapsed
                printOut  = sprintf('(%s) %s', obj.elapsedTime, obj.text);
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