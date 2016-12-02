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
    %
    % BUG:
    % regexp tokenExtents seems to exhibit volatile behaviour. It has
    % literally stopped working in one session. Replaced with simpler code
    % using ''split''.
    
    out = regexp(expression, str, varargin{:}, 'split');
    out = strjoin(out, replace);
end