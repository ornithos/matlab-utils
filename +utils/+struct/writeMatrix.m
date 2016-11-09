function writeMatrix(X, formatSpec, filename, verbose, nmMatrix)
    %  writeMatrix(X, formatSpec, filename, verbose, nmMatrix)
    %   write a matrix as a dlm file to disk, according to formatSpec.
    
    if nargin < 4 || isempty(verbose); verbose = true; end
    if nargin < 5 || isempty(nmMatrix); nmMatrix   = inputname(1); end
    
    [n,~]    = size(X);
    printFrq = 1E6;         % print every () lines.
    
    %% Write to file
    if verbose
        fprintf('(%s) ----- Writing %s ----> %s ...', datestr(now, 'HH:MM:SS'), nmMatrix, filename);
        if n > printFrq
             fprintf(' (updates every %d records)', printFrq);
        end
        fprintf(' ----\n');
    end

    % actually do the data dump!
    fid      = fopen(filename,'w');
    for ii = 1:n
        fprintf(fid, formatSpec, X(ii,:));
        if verbose && mod(ii,printFrq) == 0
            fprintf('--%s (%2.0f%%) %d lines written to disk\n', datestr(now, 'HH:MM:SS'), 100*ii/n, ii);
        end
    end

    fclose(fid);

    if verbose
        fprintf('(%s) ----- Done!\n', datestr(now, 'HH:MM:SS'));
    end
    
end