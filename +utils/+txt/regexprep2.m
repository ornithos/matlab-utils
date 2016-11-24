function out = regexprep2(expression, str, replace, varargin)
    % out = regexprep2(expression, str, replace, varargin)
    % Like regexprep, but handles group matches in a more intuitive way.
    % For example, regexprep('example_text_', '_([A-Za-z]+)_', '!')
    %   will return 'example!', whereas replacing the group match should
    %   result in example_!_.
    %
    % For all I know this may be possible with regexprep, but I couldn't
    % find out how.
    %
    % **** NOTE ****
    %  This function assumes a single expression, NOT a cell array of
    %  strings.
    
    tks = regexp(expression, str, varargin{:}, 'tokenExtents');
    cExp = expression;
    len = 0;
    lenR = numel(replace);
    
    for ii = 1:numel(tks)
        ix    = tks{ii};
        ix    = ix + (ii-1)*lenR - len;
        cExp  = [cExp(1:ix(1)-1), replace, cExp(ix(2)+1:end)];
        len   = len + diff(ix) + 1;
    end
    
    out = cExp;
    