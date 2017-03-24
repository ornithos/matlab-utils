function U = questionUser(txtString, usrOptions, varargin)
    % U = questionUser(txtString, usrOptions)
    % Ask question txtString to user, until one of options (usrOptions)
    % pressed.
    %
    % U = questionUser(..., 'caseSensitive', false)
    % case insensitive variant
    %
    % U = questionUser(..., 'regex', true)
    % usrOptions can be a list of possible regex strings to match. IF THE
    % CLIENT WISHES TO MATCH THE ENTIRE STRING, BE SURE TO INCLUDE '^', '$'
    % IDENTIFIERS IN EACH REGEX.
    
    optsDefault.caseSensitive = true;
    optsDefault.regex         = false;
    opts        = utils.base.processVarargin(varargin, optsDefault);
    
    assert(ischar(txtString), 'txtString should be a character string');
    assert(iscell(usrOptions), 'usrOptions should be a cell array of strings');
    assert(islogical(opts.caseSensitive) && isscalar(opts.caseSensitive), 'caseSensitive must be a scalar logical');
    
    txtOptions = strjoin(usrOptions,'/');
    origOptions= usrOptions;
    
    U          = '';
    
    if ~opts.regex
        if ~opts.caseSensitive
            usrOptions = upper(usrOptions);
        end
    
        while ~(ismember(U, usrOptions))
            U = input(sprintf('%s: (%s)?', txtString, txtOptions), 's');
            if ~opts.caseSensitive
                U = upper(U);
            end
        end
        U = origOptions{strcmp(U, usrOptions)};
        
    else
        caseType = 'matchcase';
        if ~opts.caseSensitive; caseType = 'ignorecase'; end
        while true
            mtch = false;
            for kk = 1:numel(usrOptions)
                mtch = mtch || ~isempty(regexp(U, usrOptions{kk}, caseType));
            end
            if mtch; break; end
            U = input(sprintf('%s: ?', txtString), 's');
        end
    end
    
end

