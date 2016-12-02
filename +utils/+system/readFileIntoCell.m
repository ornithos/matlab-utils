function [data, head] = readFileIntoCell(filename, pattern, headerLines, delim, outputType)
    % c = readFileIntoCell(filename, pattern)
    % eg. readFileIntoCell('/Users/x/file.txt', '%s, %s, %u, %u')
    % 
    % * If the file contains a header, this may be specified in the third
    % argument as:
    %
    %     c = readFileIntoCell(filename, pattern, true)
    %
    % The header (first line) will be read separately to the rest of the text.
    % Multiple header lines (say n) can be specfied as
    %
    %     c = readFileIntoCell(filename, pattern, n) 
    %
    % * If the delimiter is not explicitly specified in the pattern as above, the
    % delimiter may be specified in the third argument:
    %
    %     c = readFileIntoCell('/Users/x/file.txt', '%s %s %u %u', [], ';')
    %
    % OUTPUT:
    %  c     - a cell where each element corresponds to a column of the text.
    %  head  - a cell where each element is a string corresponding to the
    %          column header (hasHeader = TRUE)

    assert(ischar(filename), 'filename must be character string');
    assert(ischar(pattern), 'pattern must be character string');

    if nargin < 5
        outputType = 'cell';
    end
    
    if nargin < 4
        delim = [];
    end
    if nargin < 3 || isempty(headerLines)
        headerLines = 0;
    else
        assert(utils.is.int(headerLines), 'headerLines must be an integer');
    end

    assert(ismember(lower(outputType), {'cell', 'table', 'matrix'}), 'outputType must be ''cell'',''table'' or ''matrix''');
    
    %% File operations
    % try-catch to ensure the file is always released
    try
        fileID               = fopen(filename);

        % Textscan does virtually all of the work
        if isempty(delim)
            data     = textscan(fileID,pattern,'HeaderLines',headerLines);
        else
            data     = textscan(fileID,pattern,'HeaderLines',headerLines,'Delimiter',delim);
        end

        % Get header if exists and user asks for it.
        if headerLines > 0 && (nargout > 1 || strcmpi(outputType, 'table'))
            patternHeader = utils.txt.regexprep2(pattern, '%[A-Za-z0-9]*\.?[A-Za-z0-9]*', '%s');
            head = {};
            frewind(fileID);
            for jj = 1:headerLines
                fline      = fgets(fileID);
                if isempty(delim)
                    headLine   = textscan(fline,patternHeader);
                else
                    headLine   = textscan(fline,patternHeader,'Delimiter',delim);
                end
                head       = [head; headLine];  %#ok (assume that headerLines is small)
            end 
            head      = cellfun(@(x) x{1}, head, 'UniformOutput', false);   % remove layer of cell indexing.
        end
    catch ME
        if ~strcmp(ME.identifier, 'MATLAB:FileIO:InvalidFid')
            fclose(fileID);
        else
            error('Invalid file specified.');
        end
        rethrow(ME);
    end
    
    % clear up
    fclose(fileID);
    
    % output as table / matrix?
    switch lower(outputType) 
        case 'table'
            output = table(data{1}, 'VariableNames', {'V1'});
            for ii = 2:numel(data)
                output.(['V', num2str(ii)]) = data{ii};
            end
            data = output;
            if headerLines > 0 && size(head,1) == 1
                data.Properties.VariableNames = head;
            end
        case 'matrix'
            try
                tmp    = cell2mat(data);
                data   = tmp;
            catch ME
                if strcmp(ME.identifier, 'MATLAB:cell2mat:MixedDataTypes')
                    warning('Unable to convert cell to matrix: invalid format types. Returning cell.');
                    warning(['Original error: ', ME.message]);
                else
                    rethrow(ME);
                end
            end 
    end
    
end