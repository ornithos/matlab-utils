function out = groupify(X, G)
    % out = groupify(data, G)
    %  Groups data from matrix into a cell for each unique element in G. G is
    %  the index variable defining how the matrix 'data' should be split.
    
    assert(isnumeric(X), 'X must be a numeric matrix');
    assert(size(X,1) == numel(G), 'G is not conformable to input X');
    
    uqg    = unique(G);
    ng     = numel(uqg);
    
    out    = cell(ng, 1);
   
    for ii = 1:ng
        ix        = G == uqg(ii);
        out{ii}   = X(ix,:);
        %out(ii,:) = [];
    end
end