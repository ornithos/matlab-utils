function s = rename(s, oldName, newName)
    % s = rename(s, oldName, newName)
    % rename a (possibly set of) field(s) in a struct.
    
    assert(nargin == 3, 'must have 3 arguments: s = rename(s, oldName, newName)');
    assert(ischar(oldName) || iscellstr(oldName), 'oldName must be a character vector or a cellstring');
    assert(ischar(newName) || iscellstr(newName), 'newName must be a character vector or a cellstring');
    if iscellstr(oldName) || iscellstr(newName)
       assert(iscellstr(oldName) && iscellstr(newName), 'if either oldName or newName is a cellstring, both must be');
       assert(numel(oldName) == numel(newName), 'different number of names in oldName and newName');
    end
    
    if iscellstr(oldName)
        n = numel(oldName);
    else
        n = 1;
    end
    
    sFieldNames  = fieldnames(s);
    nameInStruct = ismember(oldName, sFieldNames);
    assert(all(nameInStruct), 'name(s) %s not found in struct', strjoin(sFieldNames(~nameInStruct), ', '));
    
    oldContents  = cell(n,1);
    if iscellstr(oldName)
        for ii = 1:n
            oldContents{ii} = s.(oldName{ii});
            s               = rmfield(s, oldName{ii});
        end
        
        for ii = 1:n
            s.(newName{ii})  = oldContents{ii};
        end
    else
        oldContents{1} = s.(oldName);
        s              = rmfield(s, oldName);
        s.(newName)    = oldContents{1};
    end
    
end
    