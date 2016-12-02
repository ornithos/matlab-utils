function cartesian_prod = table_cartesian(A, B)
    % cartesian_prod = table_cartesian(A, B)
    % Cartesian product of two tables A and B. Unlike SQL, MATLAB wants a
    % key in every join, so we make up a dummy one here. There are
    % certainly more efficient ways of doing this, but this is a quick one.

    dummyname = 'dummy844A35BB2D1';  % hope to avoid conflict!
    A.(dummyname) = ones(size(A(:,1)));
    B.(dummyname) = ones(size(B(:,1)));

    cartesian_prod  = outerjoin(A, B, 'MergeKeys', true, 'Keys', {dummyname});
    cartesian_prod.(dummyname) = [];
end