function writeStruct(s, formatSpec, filename, verbose)
    % writeStruct(s, formatSpec, filename)
    %   write a structure as a dlm file to disk, according to formatSpec.
    %   Actually just a wrapper for writeCell.
    
    if nargin < 4 || isempty(verbose); verbose = true; end
    
    nmStruct = inputname(1);
    fn       = fieldnames(s);
    D        = numel(fn);
    printFrq = 1E6;         % print every () lines.
    
    % get number of elements, and ensure same for all fields in struct
    n        = numel(s.(fn{1}));
    for ii = 1:numel(fn);
        assert(n == numel(s.(fn{ii})), sprintf('Field %s is a different length to %s', fn{ii}, fn{1}));
    end
    
    % error checking formatSpec
    fSubs    = regexp(formatSpec, '(^|(?<=[^%]))%[^%]');
    if numel(fSubs) ~= D
        error('different number of substitutions (%d) to struct fields (%d)', numel(fSubs), D);
    end 
    assert(numel(regexp(formatSpec, '\\n$'))==1, 'formatSpec does not end in new line character');
    
    % coerce struct to cell
    %   (because cellstruct = table2cell(struct2table(s)) is insanely slow)
    if verbose
        fprintf('(%s) ----- Struct to cell conversion ...\n', datestr(now, 'HH:MM:SS'));
    end
    
    cellstruct = cell(n, D);
    for jj = 1:D
        if iscell(s.(fn{jj}))
            cellstruct(:,jj) = s.(fn{jj});
        else
            cellstruct(:,jj) = num2cell(s.(fn{jj}));
        end
    end
    
    % Write to file
    evfutils.struct.writeCell(cellstruct, formatSpec, filename, verbose, nmStruct);
end

