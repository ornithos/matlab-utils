function [ext, f] = getFileExtension(fname)
% ext = getFileExtension(fname)
%
% trivial function to extract the extension from a filename. If two outputs
% are specified, it also returns the first part of the filename without the
% extension.
%
% eg.    getFileExtension('\Users\a\temp\temp_37823.out')
% will return the string 'out'.
%
% eg.    getFileExtension('\Users\a\temp\temp.37823.out')
% will also return the string 'out'.
%
% If no '.' in fname, or ends in '.', the function will return an empty
% string.

    strSpl   = strsplit(fname, '.', 'CollapseDelimiters', false);
    
    % note that strsplit will always return at least 2 elements if the
    % filename contains a '.', since the null space before and after is
    % still used.
    
    if numel(strSpl) > 1
        % filename contained a '.'
        
        ext = strSpl{end};
        
        % check that the dot is not part of a directory specifier (./..)
        if ~isempty(strfind(ext, '/')) || ~isempty(strfind(ext, '\\'))
            ext = '';
            f   = fname;
            return
        end
        
        if nargout > 1
            f = strjoin(strSpl(1:end-1), '.');
        end
    else
        % filename did not contain a '.'
        ext = '';
        f   = fname;
    end
    
end