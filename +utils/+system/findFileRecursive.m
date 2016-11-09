function out = findFileRecursive(folderName, fileName, varargin)
    % out = findFileRecursive(folderName, fileName)
    % Returns cell string of all files in (sub)folders on working directory
    %
    % out = findFileRecursive(folderName, fileName, 'returnFolderOnly', true)
    % Returns cell string of all (sub)folders on working directory
    % containing fileName (does not return list of files).
    
    % parse varargin
    p = inputParser;
    p.addOptional('returnFolderOnly',false,@(x) isscalar(x) && islogical(x));
    p.parse(varargin{:});
    
    assert(ischar(folderName), 'folderName must be a character string');
    assert(ischar(fileName), 'fileName must be a character string');
    assert(numel(regexp(folderName, '^[A-Za-z]:([\/\\][^\/\\]+)+[\/\\]?$'))>0, 'folderName is not an absolute filepath');
    
    pwdObj.str      = pwd;
    pwdObj.drive    = regexp(pwdObj.str, '^([A-Za-z]+):', 'tokens');
    assert(iscell(pwdObj.drive) && numel(pwdObj.drive), 'Unexpected output from working directory: multiple drives?');
    pwdObj.drive    = pwdObj.drive{1};
    
    dstObj.str      = folderName;
    dstObj.drive    = regexp(dstObj.str, '^([A-Za-z]+):', 'tokens');
    assert(iscell(dstObj.drive) && numel(dstObj.drive), 'Unexpected output from folderName: multiple drives?');
    dstObj.drive    = pwdObj.drive{1};

    
    % ensure return to working directory on exit
    C = onCleanup(@() cd(pwdObj.str));
    cd(folderName)
    
    % get list of subfolders and files
    [status, list]   =  system(['dir /s "', fileName, '"']);
    if status
        error('No files matching %s found in %s', fileName, folderName);
    end
    
    dirMatches.str  = regexp(list, '([A-Za-z]:([\/\\][^\n\r\/\\]+)+[\/\\]?)', 'tokens');
    dirMatches.num  = regexp(list, '([A-Za-z]:([\/\\][^\n\r\/\\]+)+[\/\\]?)');
    out             = cell(numel(dirMatches.num ), 1);
    
    for ii = 1:numel(dirMatches.num)
            out{ii} = dirMatches.str{ii}{1};
    end
        
    if ~p.Results.returnFolderOnly
        % interpret shell expansions for regex use
        fileName = regexprep(fileName, '\.', '\\\.');
        fileName = regexprep(fileName, '\*', '[^\\d]*');  % this is a bit of a shocker...
        
        fileMatches.str = regexp(list, ['(',fileName,')'], 'tokens');
        fileMatches.num = regexp(list, fileName);
        
        dd = 1;
        fileOut = cell(numel(fileMatches.num),1);
        for ii = 1:numel(fileMatches.num)
            while dd < numel(dirMatches.num) && fileMatches.num(ii) >= dirMatches.num(dd+1)
                dd = dd+1;
            end
            fileOut{ii} = fullfile(out{dd}, strtrim(fileMatches.str{ii}{1}));
        end
        out = fileOut;
    end
end
    
    
    