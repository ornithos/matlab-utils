function outName = nextAvailableFileName(nameStub, filepath, isFolder)
    % nextAvailableFileName(nameStub, filepath, isFolder)
    % find next available file name in filepath found by nameStub + number.
    % Useful for writing files to disk - ensure not overwriting anything.
    %
    % nameStub   - (char) Name of file prefix
    % filepath   - (char) Folder to look in
    % isFolder   - (bool) (optional) search for folders not files (False).
    
    if nargin < 3 || isempty(isFolder)
        isFolder = false;
    end
    
    assert(ischar(nameStub), 'nameStub must be a character string');
    assert(ischar(filepath), 'filepath must be a character string');
    
    % split string
    if ~isFolder
        splitStr   = regexp(nameStub, '([^.]+)(\\..*)?', 'match');
    else
        splitStr   = {nameStub};
    end
    
    if numel(splitStr) == 1
        numFileNm  = @(y) [splitStr{1}, num2str(y)];
    elseif numel(splitStr) == 2
        numFileNm  = @(y) [splitStr{1}, num2str(y), '.', splitStr{2}];
    end
    
    tryNum = 1;
    while true
        retval = exist(fullfile(filepath,numFileNm(tryNum)), 'file');
        
        if retval == 0
            break
        end
        tryNum = tryNum + 1;
    end
    
    outName = numFileNm(tryNum);
end

