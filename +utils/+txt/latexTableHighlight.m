function C = latexTableHighlight(C, rr, cc, prefix, postfix)
    % out = latexTableHighlight(C, rr, cc, prefix, postfix)
    %   Input: cellstring formatted as latex table (1 & 2 & .. \\ etc.)
    %
    %   Highlights specific cells based on the (row, column)s specified in
    %   arrays (rr, cc).
    %
    %   Currently assumes highlighting math (uses mathbf). Is not dynamic
    %   depending on input.
    
    assert(iscellstr(C), 'input is not of form cellstring');
    assert(numel(strfind(C{1}, '&'))>0 && numel(strfind(C{1}, '\\'))>0, ...
        'first row does not look like table (no ''&''; no ''\\'')');
    assert(numel(rr)==numel(cc), 'specified # rows is different to specified # cols');
    assert(min(size(rr))==1 && min(size(cc))==1, 'rr and cc must both be one dim arrays');
    
    if nargin < 5 || isempty(postfix)
        postfix = '}';
    end
    
    if nargin < 4 || isempty(prefix)
        prefix = '\mathbf{';
    end
    
    for ii = 1:numel(rr)
        row = rr(ii);
        col = cc(ii);
        cur = C{row};
        
        curSplit = regexp(cur, '&', 'split');
        element  = strtrim(curSplit{col});

        % make sure we don't highlight past EOL
        els      = regexp(element, '\\\\', 'split');
        els{1}   = [' ', prefix, strtrim(els{1}), postfix, ' '];
        curSplit{col}  = strjoin(els, '\\\\');

        C{row} = strjoin(curSplit, '&');
    end
end
