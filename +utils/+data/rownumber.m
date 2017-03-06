function out = rownumber(x, type)
% SQL-like ROWNUMBER() function for MATLAB vectors
%
% INPUTS:
%  x      - a numeric vector
%  type   - a string in {'rownumber'*, 'rank', 'dense_rank'}
%
%
% out = rownumber(x)
%    Returns the row number of each element of x when it is sorted
%    ascending. May also be seen as the reverse mapping of 
%                 f:x->y,  [~,y] = sort(x).
%
% out = rownumber(x, 'rank')
%    As for rownumber(x), except each equal elements is given the same
%    number (mapped to smallest rownumber). Example
%    
%    x    |    rank
%   ------------------
%    4    |     6
%    4    |     6
%    5    |     8
%    1    |     3
%    1    |     3
%    1    |     3
%    0    |     1
%    0    |     1
%
% out = rownumber(x, 'dense_rank')
%    As for rownumber(x, 'rank'), except rank is now returned as
%    consecutive digits, e.g.
%
%    x    |    rank
%   ------------------
%    4    |     3
%    4    |     3
%    5    |     4
%    1    |     2
%    1    |     2
%    1    |     2
%    0    |     1
%    0    |     1

%% Input checking / processing
assert(isnumeric(x) && isvector(x), 'x must be a numeric vector');
if nargin < 2 || isempty(type)
    type = 0;
elseif isnumeric(type) && utils.is.scalarint(type) && type >=0 && type <= 2
    %  ok
else
    assert(ischar(type), 'type must be a character string (or a number in {0,1,2}');
    lkp  = find(strcmpi({'rank', 'dense_rank', 'denserank'}, type));
    assert(numel(lkp) > 0, 'type must be a character string in {''rank'', ''dense_rank'', ''denserank''}');
    type = min(lkp, 2);
end

%% Function

n          = numel(x); 
[sx, I]    = sort(x);
% get reverse mapping to original order
revI       = [(1:n)', I(:)];
revI       = sortrows(revI, 2);
revI       = revI(:,1);

if isrow(x)
    revI = revI';
end
    
if type == 0
    out = revI;
else
    out        = zeros(size(x));
    if type == 1
        ix         = 1;
        out(1)     = ix;
        for ii = 2:n
            if sx(ii) > sx(ii-1)
                ix = ii;
            end
            out(ii) = ix;
        end
    elseif type == 2
        ix         = 1;
        out(1)     = ix;
        for ii = 2:n
            if sx(ii) > sx(ii-1)
                ix = ix + 1;
            end
            out(ii) = ix;
        end
    end
    out = out(revI);
end

end

