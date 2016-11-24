function out = structCoalesce(s1, s2, doDrop, warnings)
    % structCoalesce(s1, s2) returns s1 unchanged if all fields in s2 appear in
    % s1. Otherwise, all fields in s2 which are unavailable in s1 are copied
    % over.
    %
    % structCoalesce(s1, s2, true)
    % as above, but drops any additional fields in s1 that are not in s2.
    
    assert(isstruct(s2));
    assert(isstruct(s2));
    if nargin < 4 || isempty(warnings)
        warnings = false;
    end
    if nargin < 3 || isempty(doDrop)
        doDrop = false;
    end
    assert(islogical(doDrop));
    assert(islogical(warnings));
    
    out = s1;
    reqdfields = fieldnames(s2);
    currfields = fieldnames(s1);
    for ii = 1:numel(reqdfields)
        f = reqdfields{ii};
        if ~ismember(f,currfields)
            out.(f) = s2.(f);
        end
    end
    
    if doDrop
        extraFields = setxor(fieldnames(out), reqdfields);
        if ~isempty(extraFields)
            if warnings; warning('the following fields have been ignored: %s', strjoin(extraFields, ', ')); end
            out = utils.struct.structColFn(out, extraFields, 'drop');
        end
    end

end