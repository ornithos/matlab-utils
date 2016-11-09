function out = structColFn(s, arg, op, verbose)
% structColFn(s, arg, op, bInfo)
% Performs column functions on structures (or more precisely functions
% analogous to column functions on dataframe/datatable structures.
% Currently implemented are DROP, KEEP, WHERE.
%
% INPUTS:
% s       - input structure
% arg     - arguments for operation. For the case of DROP/KEEP, this should
%           be a cell string of field names to drop or keep.
% op      - (char) currently either 'DROP', 'KEEP', 'WHERE', 'SORT-ASC/DESC'; 
%           KEEP drops the complement of the fields specified. WHERE keeps 
%           the rows where arg is true. SORT-ASC or SORT-DESC sorts all
%           columns on field arg in asc/desc order respectively.
% verbose - (bool) displays warning message regarding the fields dropped.

    narginchk(3,4);
    if nargin < 4; verbose = false; end;
    if ~isstruct(s); error('s must be a struct'); end;
    if ~ischar(op); error('op must be a character string'); end;
    if ~islogical(verbose); error('bInfo must be a scalar bool'); end;

    fn      = fieldnames(s);
    lowerop = lower(op);
    
    switch lowerop
        case {'keep', 'drop'}
            if ~iscell(arg); error('keep/drop args must be a cell of strings'); end;
            
            % test for add'l arguments
            unused  = ~ismember(arg, fn);
            if any(unused)
                strUnused = ['''', strjoin(arg(unused), ''','''), ''''];
                warning('%s not found in current structure', strUnused);
            end
            
            % get keep vector
            keep    = ismember(fn, arg);
            if strcmp(lowerop, 'drop'); keep = ~keep; end;
            
            % print info if client requested
            if verbose
                orangify    = @(x) ['[\b', x, ']\b'];  % orange hack
                [currStack, currIdx] = dbstack(0);
                if numel(currStack) > 1   % has a calling function
                    currStack   = currStack(currIdx+1);  % get calling function
                    currFn      = [currStack.name, ' (', num2str(currStack.line), ')'];
                else
                    currFn      = '(console)';
                end
                structName  = inputname(1);
                strDropping = ['''', strjoin(fn(~keep)', ''','''), ''''];
                fprintf(orangify('>>> Dropping fields %s from struct %s.\nWithin function: %s\n'), ...
                        strDropping, structName, currFn);
            end
            
            % perform drop/keep (based on new struct if dropping more than
            % half of elements).
            if mean(keep) <= 0.5
                out  = struct;
                for kk = find(keep')
                    out.(fn{kk}) = s.(fn{kk});
                end
            else
                out = rmfield(s, fn(~keep));
            end

        case 'where'
            % remove rows corresponding to arg == false
            assert(islogical(arg), 'arg must be of type logical indicating rows to keep');
            %assert(numel(arg) == numel(s.(fn{1})), 'arg must be same length as struct');

            for ii = 1:numel(fn)
                tmp           = s.(fn{ii});
                out.(fn{ii})  = tmp(arg);
            end
        
        case {'sort-asc', 'sort-desc'}
            % sort all rows on field specified in arg
            lowerfn = cellfun(@lower, fn, 'UniformOutput', false);
            assert(ischar(arg), 'arg must be a character string of field to sort on');
            assert(ismember(lower(arg), lowerfn), 'arg must be a field name of s');
            
            kk      = find(ismember(lowerfn,lower(arg)));
            dir     = op(6:end);
            
            assert(min(size(s.(fn{kk}))) == 1, 'array to be sorted is multidimensional');
            if ~iscell(s.(fn{kk}))
                [z, ix] = sort(s.(fn{kk}), [dir, 'end']);
            else
                [z, ix] = sort(s.(fn{kk}));
                % ...?? MATLAB won't sort a cell of strings in desc order..
                if strcmp(dir, 'desc'); 
                    z    = flip(z);
                    ix   = flip(ix);
                end
            end
            for ii = 1:numel(fn)
                if ii == kk
                    out.(fn{ii}) = z;
                else
                    tmp          = s.(fn{ii});
                    out.(fn{ii}) = tmp(ix);
                end
            end

        otherwise
            error('Unknown operation type %s', op);
    end
end