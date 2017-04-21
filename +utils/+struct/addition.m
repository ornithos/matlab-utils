function s1 = addition(s1, s2)
    % s1 = addition(s1, s2)
    %
    % Adds the contents of two structs s1 and s2, assuming each field is
    % numeric. Function is recursive, so will handle nested structs, but
    % will fail for non-numeric or non-conformable field values.
    %
    
    assert(isstruct(s1), 's1 must be a struct');
    if isempty(s2)
        return;
    end
    assert(isstruct(s2), 's2 must be a struct');
    if isempty(fieldnames(s2))
        return
    end
    
    sfnms     = fieldnames(s1);
    for ii = 1:numel(sfnms)
        if isstruct(s1.(sfnms{ii}))
            s1.(sfnms{ii}) = utils.struct.addition(s1.(sfnms{ii}), s2.(sfnms{ii}));
        else
            s1.(sfnms{ii}) = s1.(sfnms{ii}) + s2.(sfnms{ii});
        end
    end
    
end