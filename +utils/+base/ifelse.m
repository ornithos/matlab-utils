function out = ifelse(query, a, b)
    % out = ifelse(query, a, b)
    % Vectorised if-else statement.

    assert(islogical(query), 'query must be a logical expression');
    
    % scalar case - allow different length return values;
    if numel(query) == 1
        if query
            out = a;
        else
            out = b;
        end
        return
    end
    
    assert(isequal(size(a), size(query)), 'query is not same size as ''a''');
    assert(isequal(size(b), size(query)), '''a'' is not same size as ''b''');

    out     = query.*a + (1-query).*b;
    
end
