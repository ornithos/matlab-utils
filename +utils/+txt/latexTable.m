function out = latexTable(A, rowlabels, collabels, prec, doPrint)
% out = latexTable(A, rowlabels, collabels);
%   Creates a text-based representation of a matrix A with (optional)
%   row labels and column labels. The output is formatted with ampersands and
%   line breaks for rendering in Latex.
%
%   Row and column labels must be cell string or numeric.
%
% out = latexTable(A, [], [], prec);
%   Configures precision to print numbers at. Numeric will give decimal
%   places, but printf strings are possible for greater flexibility.
%
% ***** RECOMMEND SUPPRESSING OUTPUT WITH SEMICOLON ********************
% (will return cell str as well as the on-screen print-out).
%
% By default will print table to console, but can be switched off with
% doPrint argument.
%
% Use utils.struct.writeCell(c, formatSpec, filename, verbose, nmCell, header)
% to write output to file.
%

    assert(ismatrix(A), 'A is not a matrix!');
    assert(isnumeric(A), 'This function only built for numeric matrices');
    [m,n] = size(A);
    
    % deal with column label inputs.
    if nargin < 3 || isempty(collabels)
        collabels = [];
    else
        if size(collabels, 2) == 1; collabels = collabels'; end
        assert(all(size(collabels)==[1,n]), 'col labels are not conformable to matrix');
        if ~isnumeric(collabels) && ~iscellstr(collabels)
            error('col labels must be either numeric or cell string');
        end
        % convert numeric to cell string
        if ~iscell(collabels)
            collabels = arrayfun(@num2str, collabels, 'unif', 0);
        elseif isnumeric(collabels{1})
            collabels = cellfun(@(x){num2str(x)}, collabels);
        end
    end
    
    % deal with row label inputs
    if nargin < 2 || isempty(rowlabels)
        rowlabels = [];
    else
        if size(rowlabels, 1) == 1; rowlabels = rowlabels'; end
        assert(all(size(rowlabels)==[m,1]), 'row labels are not conformable to matrix');
        if ~isnumeric(rowlabels) && ~iscellstr(rowlabels)
            error('row labels must be either numeric or cell string');
        end
        if ~iscell(rowlabels)
            rowlabels = arrayfun(@num2str, rowlabels, 'unif', 0);
        elseif isnumeric(rowlabels{1})
            rowlabels = cellfun(@(x){num2str(x)}, rowlabels);
        end
    end
    
    if nargin < 4 || isempty(prec)
        prec    = 8;
        special = false;
    elseif numel(prec) == 1
        special = false;
    elseif ismatrix(prec) 
        if numel(prec) == n && min(size(prec))==1
            special = true;
            prec    = arrayfun(@(x) sprintf('%%.%df', x), prec, 'Un', 0);
        else
            error('prec must either be one dimensional or have the same number of columns as A');
        end
    elseif numel(prec) > 1
        assert(numel(prec) == n, 'prec must either be one dimensional or have the same number of columns as A');
        special = true;
    end
    
    if nargin < 5 || isempty(doPrint)
        doPrint = true;
    else
        assert(isscalar(doPrint) && islogical(doPrint), 'doPrint must be scalar bool');
    end
        
    %% Generate latex table
    if ~isempty(rowlabels)
        out = rowlabels;
        for jj = 1:m
            out{jj} = [out{jj}, ' & '];
        end
    else
        out = repmat({''}, m, 1);
    end
    
    colincr = 0;
    if ~isempty(collabels)
        tmp = strjoin(collabels, ' & ');
        if ~isempty(rowlabels)
            tmp = ['& ', tmp];
        end
        out = [{[tmp, ' \\']} ; out];
        colincr = 1;
    end
    
    % Main output
    if ~special
        % same formatting per column
        for ii = 1:m
            out{ii + colincr} = [out{ii + colincr}, utils.base.numjoin(A(ii,:), ' & ', prec), ' \\'];
        end
    else
        for ii = 1:m
            cur = out{ii + colincr};
            for jj = 1:n
                cur = [cur, sprintf(prec{jj}, A(ii,jj)), ' & '];
            end
            cur               = cur(1:end-3);  % remove final ampersand
            out{ii + colincr} = [cur, ' \\'];
        end
    end
    
    if doPrint
        utils.txt.printCellStr(out);
    end
end