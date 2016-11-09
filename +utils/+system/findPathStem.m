function stem = findPathStem(path, folder, caseInsensitive, breakties)
    % findPathStem(path, folder)
    % Recursively moves up the file path specified until a folder named
    % 'folder' is discovered. This stem is returned.
    %
    % caseInsensitive  - (optional) (bool) specifies whether the folder
    %                    comparison should be case Insensitive. [False].
    % breakTies        - (optional) (numeric) if multiple folders found on
    %                    path with the specified name, (+1) specifies the
    %                    maximum tree depth (last match), and (-1) the
    %                    minimum. [+1].

    if nargin < 4; breakties = +1; end;
    if nargin < 3; caseInsensitive = false; end;
    if ~islogical(caseInsensitive); error('caseInsensitive must be a bool'); end;
    if ~isnumeric(breakties); error('breakties must be numeric'); end;
    
    parts  = regexp(path, '[\\/]', 'split');
    
    if ~caseInsensitive
        isFolder = strcmp(folder, parts);
    else
        isFolder = strcmpi(folder, parts);
    end
    
    if ~any(isFolder)
        error('folder %s not found on specified path (%s)', folder, path);
    end
    
    whichPart = find(isFolder);
    if breakties(1) > 0   % (1) in case a vector specified.
        whichPart = whichPart(end); % choose highest level.
    else
        whichPart = whichPart(1);
    end
    
    parts  = parts(1:whichPart);
    stem = strjoin(parts, '/');
end

