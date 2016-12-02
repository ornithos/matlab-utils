function [status, err, outfile] = rscript(RscriptFileName, args, Rpath)
    % [status, txt, outfile] = rscript(RscriptFileName, args, Rpath)
    % Run R script from MATLAB.
    %
    % INPUTS:
    % RscriptFileName  - the name of the R script
    % args             - a cell of string arguments to be supplied to the
    %                     R function (note the R function must contain the
    %                     line:
    %                         args <- commandArgs(trailingOnly = TRUE)
    %                     and can access them as args[1], args[2] etc.
    % Rpath            - the path of .../bin/ for R. Default is given for mac.
    %
    % OUTPUTS:
    % status           - success or failure from command line (0 = success)
    % err              - command line error message if any
    % outfile          - the contents of the R output (if any) as a cell.

    if nargin < 2 || isempty(args)
        args = {''};
    end
    
    if nargin < 3 || isempty(Rpath)
        % where it is on my computer!
        Rpath  = '/Library/Frameworks/R.framework/Resources/bin';
    end
    
    if ischar(args)
        args = {args};
    end
    
    % check arguments are not going to cause problems
    assert(iscell(args), 'args must be cell array of string arguments');
    nargs         = numel(args);
    badidx        = false(nargs,1);
    for jj = 1:nargs
        if ~ischar(args{jj})
            badidx(jj) = 1;
        end
    end
    if any(badidx)
        dispEl = find(badidx);
        if numel(dispEl) > 5
            dispEl = [utils.base.numjoin(dispEl(1:5), ','),', ...'];
        else
            dispEl = utils.base.numjoin(dispEl, ',');
        end
        error('Element(s) %s of arguments are not strings', dispEl);
    end
    
    args = strjoin(args, ' '); % space delimited
    
    %% Run R script
    sep          = filesep;
    [p,~,~]      = fileparts(RscriptFileName);
    tmpOutFN     = utils.system.nextAvailableFileName('runR.out', p);

    RscriptCMD   = [Rpath, sep, 'Rscript']; % note Rscript.exe on windows
    allCMD       = [RscriptCMD, ' ', RscriptFileName, ' ', args, ' > ', tmpOutFN];
    
    [err,status] = system(allCMD);
    
    if nargout > 2
        outfile = utils.system.readFileIntoCell(tmpOutFN, '%s', [], '\n');
    end
    
    % since ensured no naming conflict above, we can delete output safely.
    delete(tmpOutFN);
    
end
