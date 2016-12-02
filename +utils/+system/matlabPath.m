function path = matlabPath(varargin)
    % path = matlabPath
    % (Absolute) Set your MATLAB working folder once here, and re-use
    % elsewhere using this function
    %
    % path = matlabPath('folder', 'subfolder', ...)
    % Works like fullfile, only with the matlab path pre-pended.
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

