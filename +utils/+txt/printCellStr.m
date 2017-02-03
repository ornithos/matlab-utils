function printCellStr(C)
    % printCellStr(C)
    % prints a (1D) cell string array in the console without quotes (for
    % ease of copy + paste)
    %
    
    assert(iscellstr(C), 'C is not a cell string');
    [m,n] = size(C);
    assert(min(m,n) == 1, 'function only configured to print 1D arrays at present');
    
    for ii = 1:numel(C)
        fprintf('%s\n', C{ii});
    end
end