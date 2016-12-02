function U = questionUser(txtString, usrOptions, caseSensitive)
    % U = questionUser(txtString, usrOptions)
    % Ask question txtString to user, until one of options (usrOptions)
    % pressed.
    %
    % U = questionUser(txtString, usrOptions, true)
    % Ask question txtString to user, until one of options (usrOptions)
    % pressed (case sensitive).
    
    if nargin < 3 || isempty(caseSensitive)
        caseSensitive = false;
    end
    
    assert(ischar(txtString), 'txtString should be a character string');
    assert(iscell(usrOptions), 'usrOptions should be a cell array of strings');
    assert(islogical(caseSensitive) && isscalar(caseSensitive), 'caseSensitive must be a scalar logical');
    
    txtOptions = strjoin(usrOptions,'/');
    origOptions= usrOptions;
    
    if ~caseSensitive
        usrOptions = upper(usrOptions);
    end
    
    U          = '';
    
    while ~(ismember(U, usrOptions))
        U = input(sprintf('%s: (%s)?', txtString, txtOptions), 's');
        if ~caseSensitive
            U = upper(U);
        end
    end
    
    U = origOptions{strcmp(U, usrOptions)};
end

