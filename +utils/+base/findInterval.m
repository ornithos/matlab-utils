function [k, outside] = findInterval(x, I, varargin)
    % [k, outside] = findInterval(x, I)
    %   I specifies a monotonically increasing interval of 1D values 
    %   [i1, i2, ..., ir]. findInterval returns the index 1, ..., r-1 of the
    %   interval in which x falls. Interval s is defined as [i_s, i_{s+1}).
    %   The interval is closed on the right only when s = r-1.
    %
    %   If x does not lie between any intervals specified by I, then the
    %   value NaN is returned, and the second output 'outside' will be -1 if
    %   x < i_1, and +1 if x > i_s.
    %
    % findInterval(..., 'type', 'logical')
    %   as above, but returns a logical vector (1-of-(r-1)) corresponding to
    %   the index of x. This is (slightly) faster than the usual variant.
    %
    % findInterval(..., 'ties', 'error')
    %   default 'strategy' if tied values in I is to error. Other
    %   strategies are to return the first interval matching the query
    %   points in x ('first'), the last interval ('last'), or all the
    %   intervals ('all'). 'all' must be specified with 'type', 'logical'.
    %
    
    assert(isvector(x) && isnumeric(x), 'x must be a numeric scalar/vector');
    assert(isvector(I) && isnumeric(I), 'I must be a numeric vector');
    assert(issorted(I), 'I must be in ascending order');
    assert(numel(I) > 1, 'I must contain at least 2 values');
    
    optsDefault.type = 'find';
    optsDefault.ties = 'error';
    opts             = utils.base.processVarargin(varargin, optsDefault);
    
    assert(ischar(opts.type), 'type must be a character string ''find'',/''logical''');
    assert(any(strcmpi(opts.type, {'find','logical'})), 'type must be a character string ''find'',/''logical''');
    if strcmpi(opts.type, 'logical')
        returnlogical = true;
    else
        returnlogical = false;
    end

    ties = 0;
    switch lower(opts.ties)
        case 'error'
            assert(all(~(I(2:end)==I(1:end-1))), 'I must contain distinct values (specify ''ties'' strategy to change)');
        case {'first', 'last', 'all'}
            Iorig = I;
            Iidx  = utils.data.rownumber(I, 'denserank');
            I     = unique(I);
            ties  = find(strcmpi(opts.ties, {'first', 'last', 'all'}));
            switch ties
                case 1
                    % first
                    % this is screwed. Try utils.base.findInterval(1:0.25:2, [1 1 1 1.5 1.5 2], 'ties', 'first')
%                     map = containers.Map(1:Iidx(end), [1, find(diff(Iidx)>0)+1]);
                    map2 = [1, find(diff(Iidx)>0)+1];
                    map = [1, zeros(1,numel(I)-2)];
                    kk  = 2;
                    for jj = 2:numel(Iidx)
                        if Iidx(jj) ~= Iidx(jj-1); map(kk) = jj; kk = kk+1; end
                    end
                case 2
                    % last
%                     map = containers.Map(1:Iidx(end), [find(flip(diff(flip(Iidx))<0)), numel(Iorig)]);
                    map2 = [find(flip(diff(flip(Iidx))<0)), numel(Iorig)];
                    map = [zeros(1,numel(I)-1),numel(Iidx)];
                    kk  = numel(map)-1;
                    for jj = numel(Iidx)-1:-1:1
                        if Iidx(jj) ~= Iidx(jj+1); map(kk) = jj; kk = kk-1; end
                    end
                    assert(all(map==map2), 'shortcut doesn''t work');
                case 3
                    % all
                    assert(strcmpi(opts.type, 'logical'), '''type'', ''logical'' must be specified for ''ties'', ''all''');
                    map = cell(numel(I), 1);
                    for kk = 1:numel(I)
                        map{kk} = Iorig == I(kk);
                    end
            end
        otherwise
            error('Unknown ''ties'' strategy: should be ''first''/''last''/''all''/''error''. Received: %s', opts.ties);
    end
    
    
    %% Perform interval find
    [n, p] = size(x);
    [m, r] = size(I);
    if p>1; x = x'; n = p; end
    if r == 1; I = I'; [m, r] = deal(r, m); end
    
    ixvector = bsxfun(@ge, x, I(1:r-1)) & bsxfun(@lt, x, I(2:r));
    outside = (x < I(1)).*(-1) + (x > I(end)).*(+1) ;
    ixvector(x == I(end), r-1) = 1;
    
    % deal with ties strategies
    if ties > 0
        ixvectorOrig = bsxfun(@ge, x, Iorig(1:end-1)) & bsxfun(@lt, x, Iorig(2:end));
        ixvectorOrig(x == I(end), numel(Iorig)-1) = 1;
        
        % do not get the end for 'last' since due to the right-closed 
        % interval last stage - this will go wrong.
        if ties ~= 2
            tied         = find(ismember(x, I(1:end)));
        else
            tied         = find(ismember(x, I(1:end-1)));
        end
        ixvectorOrig(tied,:) = 0;
        [~,cols]     = find(ixvector(tied,:));
        if ties < 3
            for ii = 1:numel(tied)
                ixvectorOrig(tied(ii), map(cols(ii))) = true;
            end
        else
            for ii = 1:numel(tied)
                ixvectorOrig(tied(ii), map{cols(ii)}) = true;
            end
            ixvectorOrig(x == I(end), end) = 1;
        end
        
        ixvector = ixvectorOrig;
        
%         if ties < 3
%             % first, last
%             map          = map(1:end-1);   % changeup for differencing
%             ixvectorOrig = ixvector;
%             ixvector     = false(n, numel(Iorig)-1);
%             ixvector(:,map) = ixvectorOrig;
%         else
%             % ties == 3, ('all')
%             ixvector = repelem(ixvector, ones(numel(I),1), utils.base.contiguousCount(Iorig));
%         end
    else
        ixvector(x == I(end), r-1) = 1;
    end
        
    %% Manipulate output for return
    if ~returnlogical
        k = NaN(n,1);
        for ii = (find(~outside)')
            k(ii) = find(ixvector(ii,:));
        end
    else
        k = ixvector;
    end
    
    if p>1
        k = k'; 
        outside  = outside';
    end
            
end