function outName = nextAvailableFileName(nameStub, filepath, isFolder)
    % nextAvailableFileName(nameStub, filepath, isFolder)
    % find next available file name in filepath found by nameStub + number.
    % Useful for writing files to disk - ensure not overwriting anything.
    %
    % nameStub   - (char) Name of file prefix
    % filepath   - (char) (optional) Folder to look in. Otherwise specify
    %                 in namestub as full path.
    % isFolder   - (bool) (*DEPRECATED*) search through folders not files.
    %                 Acutally just ignores the extension: this has been
    %                 handled better using getFileExtension, so no need.
    
    if nargin == 3
        warning('isFolder specified: no longer necessary. Will be removed in future release');
    end
    
    if nargin < 2
        filepath = '';
    end
    
    assert(ischar(nameStub), 'nameStub must be a character string');
    assert(ischar(filepath), 'filepath must be a character string');
    
    fend       = '';
    
    % split file from extension (if relevant)
    [ext,f]    = utils.system.getFileExtension(nameStub);
    if ~isempty(ext)
        % is file
        ext = ['.',ext];
    else
        % possibly folder
        if strcmp(f(end), '/') || strcmp(f(end), '\\')
            fend = f(end);
            f    = f(1:end-1);
        end
    end
    
%     % try given name first
%     retval  = exist(fullfile(filepath,nameStub), 'file');
%     if retval == 0
%         outName = nameStub;
%         return
%     end
    
    % else increment a number at the end
    numFileNm      = @(y) [f, num2str(y), ext];
    
    tryNum = 1;
    while true
        retval = exist(fullfile(filepath,numFileNm(tryNum)), 'file');
        
        if retval == 0
            break
        end
        tryNum = tryNum + 1;
    end
    
    outName = [numFileNm(tryNum), fend];
end

