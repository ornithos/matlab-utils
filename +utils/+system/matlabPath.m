function path = matlabPath(varargin)
    % path = StoreOrderingDevelopmentPath
    % (Absolute) Network path for SO network drive. This is trying to get
    % around different users who have different drive mappings set up.
    %
    % path = StoreOrderingDevelopmentPath('folder', 'subfolder', ...)
    % Works like fullfile, only with the SO path pre-pended.
    %
    
    try
        path = utils.system.findPathStem(mfilename, 'MATLAB', true);
    catch
        path = '/Users/alexbird/Documents/MATLAB';
        if ~exist(path, 'file')
            error('Unable to find base MATLAB path - please fix in matlabPath file');
        end
    end
    
    nargs = numel(varargin) ;
    if nargs > 0
        for ii = 1:nargs
            assert(ischar(varargin{ii}), sprintf('Argument %d is not a character string!', ii));
            path = fullfile(path, varargin{ii});
        end
    end
end

