function struct1 = structCat(struct1, struct2, catDim)
    % Concatenate 2 structs (tables) vertically.
    
    fld1 = fieldnames(struct1);
    fld2 = fieldnames(struct2);
    assert(numel(setxor(fld1, fld2)==0, 'Structs do not have the same fields');
    
    for ii = 1:length(fld1)
        f1           = fld1{ii};
        idx2         = strcmpi(f1, fld2);
        struct1.(f1) = cat(catDim, struct1.(f1), struct2.(fld2{idx2}));
    end
    
end

