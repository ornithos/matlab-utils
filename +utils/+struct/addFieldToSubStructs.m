function s = addFieldToSubStructs(s, fname, val)
    % s = addFieldToSubStructs(s, fname, val)
    %
    % add field fname with value val to all structs *within* s.
    %
    % eg.   s = struct('a', struct('foo', 1), 'b', struct('bar', {'qqq'}));
    %       s = addFieldToSubStructs(s, 'newfield', 100);
    %       assert(s.a.newfield == 100);   % true
    %       assert(s.b.newfield == 100);   % true
    %
    
    assert(isstruct(s), 's must be a struct');
    assert(ischar(fname), 'fname must be a character string');
    
    sfnms     = fieldnames(s);
    for ii = 1:numel(sfnms)
        cStrct     = s.(sfnms{ii});
        if isstruct(cStrct)
            s.(sfnms{ii}).(fname) = val;
        end
    end
    
end