function j = jaccard(X,Y)
    % j = jaccard(X,Y)
    % Jaccard similarity between two sets X and Y: this is the quotient:
    %  |{X n Y}|
    %  ---------
    %  |{X u Y}|
    % Since j in [0, 1], it can be converted to a distance with 1 - j.
    % We have taken the convention that j = 0 if both sets are empty. This
    % is purely a practical argument.
    %
    % INPUTS: X and Y are both cells

    if ~iscell(X) 
        if isempty(X)
            X = [];
        else
            X = {X};
        end
    else
        X = X(:);
    end
    if ~iscell(Y)
        if isempty(Y)
            Y = [];
        else
            Y = {Y};
        end
    else
        Y = Y(:);
    end
    
    nunion = numel(union(X,Y));

    if nunion == 0
        j = 0;
    else
        j = numel(intersect(X, Y))/nunion;
    end

end