function check = checkStruct(s, fields, bExhaustive, bError)
%checkStruct(s, fields, bError)
% checks a struct contains required fields.
% INPUTS
% s           - an arbitrary struct object
% fields      - a cell of required field strings
% bExhaustive - (optional) the specified fields are an exhaustive
%               description of the contents of the struct. No other fields
%               are permitted. DEFAULT = FALSE
% bError      - (optional) create error (stop execution) if check fails.
%               Otherwise return value is false. DEFAULT = TRUE
%
% OUTPUTS
% check       - boolean return value if checks passed.

% defaults
narginchk(2,4);
if nargin < 4; bError = true; end;
if nargin < 3; bExhaustive = false; end;
check      = true;
structName = inputname(1);

% error checking
err = true;
if iscell(fields) 
    if ischar(fields{1})
        err = false;
    end
end
if err; error('fields must be a cell of strings'); end;
assert(isstruct(s), 's is not a struct');

structfields   = fieldnames(s);
reqdfields     = ismember(fields, structfields);

if any(~reqdfields)
    check = false;
    badfields = fields(~reqdfields);
    if bError
        error('(%s) required fields not found: %s', structName, strjoin(badfields(:)',', '));
    else
        warning('(%s) required fields not found: %s', structName, strjoin(badfields(:)',', '));
    end
end

if bExhaustive
    extrafields     = ~ismember(structfields, fields);
    if any(extrafields)
        check = false;
        badfields = structfields(extrafields);
        if bError
            error('additional fields found: %s', strjoin(badfields(:)',', '));
        else
            warning('additional fields found: %s', strjoin(badfields(:)',', '));
        end
    end
end
end

