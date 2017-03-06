function out = structarray2struct(sa)
    % out = structarray2struct(sa)
    % Converts structarrays to struct.
    %
    % I *HATE* struct arrays in MATLAB. They seem to be some weird halfway
    % house between tables and structs. If you want to recycle elements of
    % an array or table, it should not be difficult to use repmat or
    % similar. Maybe use two different data structures - one for the
    % changing elements, one for the constant ones? But this would not
    % matter if it were not for the fact that MATLAB forces structs with
    % scalar and cell inputs into structarrays with no options that I have
    % found to convert back into the intended object. Since I use structs
    % to pass options around, I find this a massive bugbear. Thus this is a
    % kludge to convert back.
    %
    % Note that this is slow. However, since I don't know the internals of
    % MATLAB's parsing of struct calls, it is difficult to code up a more
    % optimised variant at present. Also I want to spend as little time on
    % this as possible.
    %
    % One can avoid making struct arrays by accident by enclosing all cell
    % inputs in double curly parentheses, viz.
    %
    % s   = struct('a', 'foo', 'b', {'z', 'x', 'y'});     %--> structarray
    % s   = struct('a', 'foo', 'b', {{'z', 'x', 'y'}});   %--> struct
    %
    % THIS IS NOT UNIT CHECKED, AND VERY FEW INPUT STRUCTURES HAVE BEEN
    % CHECKED. CAVEAT EMPTOR!
    
    assert(isstruct(sa), 'sa is not a struct');
    n = numel(sa);
    [nn, mm] = size(sa);
    
    if n == 1
        out = sa;
        return
    end
    
    fields  = fieldnames(sa);
    isconst = true(n,1);
    
    out = sa(1);
    
    for jj = 1:numel(fields)
        fv = sa(1).(fields{jj});
        for kk = 2:n
            if ~isequal(fv, sa(kk).(fields{jj}))
                isconst(jj) = false;
                break
            end
        end
    end
    
    for jj = 1:numel(fields)
        if ~isconst(jj)
            out.(fields{jj}) = {out.(fields{jj})};
            for kk = 2:n
                out.(fields{jj}) = [out.(fields{jj}), sa(kk).(fields{jj})];
            end
            out.(fields{jj}) = reshape(out.(fields{jj}), nn, mm);
        end
    end
end
        
    
    