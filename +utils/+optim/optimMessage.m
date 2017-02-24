function [msg, iserr] = optimMessage(code, varargin)
    % optimMessage(code) returns the output message of a MATLAB solver and
    % whether it resulted in an error. This allows a solver to be used
    % without dirtying the console, but can catch errors if needed.
    %
    % optimMessage(code, 'onlyErrors', true);
    % will only return a msg if message is an error.
    %
    % optimMessage(code, 'onlySuccesses', true);
    % will only return a msg if optimisation message corr. to a success.
    %
    
    assert(isscalar(code) && isnumeric(code));
    
    % name-value inputs
    opts        = struct;
    optsDefault = struct('onlyErrors', false, 'onlySuccesses', false);
    
    narargin    = numel(varargin);
    assert(mod(narargin,2)==0, 'arguments to optimMessage must come in name-value pairs');
    for kk = 0:(narargin/2-1)
        assert(ischar(varargin{2*kk+1}), 'odd numbered arguments must be names (character strings)');
        opts.(varargin{2*kk+1}) = varargin{2*kk+2};
    end
    opts        = utils.base.parse_argumentlist(opts, optsDefault);
    
    %%
    iserr    = code < 0;
    msg      = '';
    code     = int32(code);
    
    msgs     = containers.Map('KeyType', 'int32', 'ValueType', 'char');
    msgs(4)  = 'Local minimizer found.';
    msgs(3)  = 'Change in objective function too small.';
    msgs(0)  = 'Maximum number of iterations exceeded.';
    msgs(-2) = 'No feasible point found.';
    msgs(-3) = 'Problem is unbounded.';
    msgs(-4) = 'Current search direction is not a descent direction; no further progress can be made.';
    msgs(-7) = ['Magnitude of search direction became too small; no further ', ...
                'progress can be made. The problem is ill-posed or badly conditioned.'];
    
    if iserr && opts.onlySuccesses
        return
    end
    
    if ~iserr && opts.onlyErrors
        return
    end
    
    if ~(ismember(code, cell2mat(msgs.keys())))
        warning('no lookup found for optimMessage with code %d', code);
        msg      = '';
    else
        msg      = msgs(code);
    end
    
end