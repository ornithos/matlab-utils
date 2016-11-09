function out = parse_argumentlist(args, defaults)
    % out = parse_argumentlist(args, defaults)
    % fills in values of default object struct with any present in args.
    % checks to see if type is the same of the matching arguments and
    % removes any extraneous fields.
    
    assert(isstruct(args), 'args should be a struct');
    assert(isstruct(defaults), 'defaults should be a struct');
    
    out   = utils.struct.structCoalesce(args, defaults, true);
    fds   = fieldnames(out);
    
    for ii = 1:numel(fds)
        assert(isa(out.(fds{ii}), class(defaults.(fds{ii}))), 'args.%s of a different type to default', fds{ii});
    end
end