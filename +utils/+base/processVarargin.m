function args = processVarargin(vars, defaults)
    % args = processVarargin(vars, defaults)
    % Processes varargins of functions: allows specification of arguments 
    % either as name-value pairs or struct inputs. If both, the structs
    % must come first. The defaults struct must contain all the possible
    % fields the user may pass in, and will give a warning otherwise.
    %
    % OUTPUTS: args    -  struct containing name-value lookup
    %
    
    opts = struct;
    if numel(vars) > 1
        while ~isempty(vars)
            if isstruct(vars{1})
                opts = utils.struct.structCoalesce(vars{1}, opts);
                vars(1) = [];
            else
                break
            end
        end
    end
    
    % name-value inputs
    narargin = numel(vars);
    if mod(narargin,2) ~= 0
        ME = MException('processVarargin:nopair','arguments to expLogJoint must come in name-value pairs.');
        throwAsCaller(ME);
    end
    
    for kk = 0:(narargin/2-1)
        if ~ischar(vars{2*kk+1})
            ME = MException('processVarargin:oddStrings','odd numbered arguments must be names (character strings)');
            throwAsCaller(ME);
        end
        opts.(vars{2*kk+1}) = vars{2*kk+2};
    end
    args        = utils.base.parse_argumentlist(opts, defaults);
end