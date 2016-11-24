function out = parse_argumentlist(args, defaults, warnings)
    % out = parse_argumentlist(args, defaults)
    % fills in values of default object struct with any present in args.
    % checks to see if type is the same of the matching arguments and
    % removes any extraneous fields.
    
    if nargin < 3
        warnings = true;
    end
    
    assert(isstruct(args), 'args should be a struct');
    assert(isstruct(defaults), 'defaults should be a struct');
    assert(isscalar(warnings) && (isnumeric(warnings) || islogical(warnings)), 'warnings should be scalar boolean');
    
    out   = utils.struct.structCoalesce(args, defaults, true, warnings);
    fds   = fieldnames(out);
    
    for ii = 1:numel(fds)
        assert(isa(out.(fds{ii}), class(defaults.(fds{ii}))), 'args.%s of a different type to default', fds{ii});
    end
end