function parent = pathParent(path, levels)
    % pathParent(path)
    % Returns string of parent folder of specified path.
    %
    % pathParent(path, levels)
    % Returns string of (levels)*parent folder of specified path.
    if nargin < 2
        levels = 1;
    end
    parts  = regexp(path, '[\\/]', 'split');
    parts  = parts(1:end-levels);
    parent = strjoin(parts, '/');
end

