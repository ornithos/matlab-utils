classdef bspline
    % bspline object 
    %   bspline(k, t)
    %    -- create bspline object of degree k, and knots -- possibly coin-
    %       cident. Constructor will assume discontinuity at boundaries.
    %
    %   bspline(k, t, 'boundaries', bb)
    %    -- as above, but constructor will adapt continuity at the
    %    boundaries: bb = k     => discontinuity
    %                bb = k - a => discontinuity in a'th derivative.
    %   
    %
    % with methods
    %   * obj.basisEval(X)
    %
    % follows de Boor - A Practical Guide to Splines (1978 / 2001).
    %
    
    properties
        k        % degree of each piecewise polynomial
        n        % total number parameters = k*l - sum_i(nu_i)
        t        % knots; breakpoints
        bdknots  % number of knots at boundaries
        alpha    % coefficients of basis for current function.
    end
    methods
        function obj = bspline(k, t, varargin)
            
            % defaults and arg processing
            optsDefault             = struct;
            optsDefault.boundaries  = k;

            opts      = utils.base.processVarargin(varargin, optsDefault);
            
            assert(utils.is.scalarint(k, 0), 'k must be a non-negative scalar integer');
            assert(isvector(t) && isnumeric(t) && isreal(t), 't must be a (real) numeric vector');
            assert(issorted(t), 't must be given in ascending order');
            assert(numel(unique(t)) > 1, 'must have at least 2 distinct breakpoints');
            
            t         = t(:)';
            
            obj.k     = k;
            bdknots   = opts.boundaries;
            
            if bdknots > 0
                assert(bdknots <= k, 'boundary discontinuity cannot be of greater degree than k');

                % start
                ii = 1;
                while t(ii+1) == t(1)
                    ii = ii + 1;
                end
                numaddl = max(0, bdknots - ii);
                t       = [repmat(t(1), 1, numaddl), t];
                % end
                ii = numel(t);
                while t(ii-1) == t(end)
                    ii = ii - 1;
                end
                numaddl = max(0, bdknots - (numel(t) - ii + 1));
                t       = [t, repmat(t(end), 1, numaddl)];                    
            end
            
            obj.t       = t';
            obj.bdknots = bdknots;
        end
       
        function B = basisEval(obj, X, doLoop)
            % evaluate the given basis at positions X = [x1, x2, ..., xm].
            %
            % Uses recurrence B_{jk} = w_{jk} B_{j,degk-1} + (1-w_{jk}) B_{j+1,degk-1}
            
            assert(isnumeric(X) && isvector(X), 'X must be a numeric vector');
            N               = numel(X);
            if nargin < 3 || isempty(doLoop)
                doLoop = N < 100;
            end
            
            X               = X(:);
   
            % recurrence assumes nondecreasing input sequence. Ensure this
            % is so. (cf James Ramsay)
            if min(diff(X)) < 0 
                [X, isrt] = sort(X); 
                reordered = 1;
            else
                reordered = 0;
            end
            nt              = numel(obj.t);
%             ix   = utils.base.findInterval(X, obj.t, 'type', 'logical', 'ties', 'all');
            
            nbasis          = nt - (obj.bdknots);
            degk            = obj.k;
            knotslower      = obj.t(1:nbasis);
            [~,index]       = sort([knotslower', X']);
            pointer         = find(index > nbasis) - (1:N);
            left            = max([pointer; degk*ones(1,N)]);  

            b               = repmat([1, zeros(1, degk)], N, 1);
            
            % recursion directly from de Boor (and James Ramsay).
            for jj = 1:degk
                saved = zeros(N, 1);
                for r = 1:jj
                    leftpr    = left + r;
                    tr        = obj.t(leftpr) - X;
                    tl        = X - obj.t(leftpr-jj);

                    term      = b((1:N), r)./(tr+tl);
                    b(1:N,r)  = saved + tr.*term;
                    saved     = tl.*term;
                end
                b(1:N, jj+1)    = saved;
            end
            
            % now each end column in b corresponds to B_{i-degk+1,degk}, ..., B_{ik}
            % for each i, where i corresponds to the knot to the left of
            % the interval in which each x falls. So to place them all in
            % the same (comparable matrix, we need to shift the columns
            % about.
            
            % this loop is a lot slower than the method used by James
            % Ramsay - but it is *much* more intuitive!
            if doLoop
                B = zeros(N, numel(obj.t) - obj.bdknots+1);
                for nn = 1:N
                    B(nn, (left(nn)-degk+1):left(nn)+1) = b(nn,:);
                end
            else
                % James Ramsay version
                ns    = nt - obj.bdknots + 1;
                nbasis= nt - obj.bdknots*2 + degk + 1;
                nx    = N;
                nd    = 1;  % derivative num + 1
                onenb = ones(degk+1,1);
                onenx = ones(N, 1);
                onens = ones(ns, 1);
                
                width = max([ns,nbasis]) + degk + degk;
                
                cc    = zeros(nx*width,1);
                index = (1-nx:0).'*onenb' + ...
                        nx*((left+1).'*onenb' + onenx*(-degk:0));
                cc(index) = b(nd*(1:nx),:);
                % (This uses the fact that, for a column vector  v  and a matrix  A ,
                %  v(A)(i,j)=v(A(i,j)), all i,j.)
                B     = reshape(cc((1-nx:0).'*onens' +  nx*onenx*((1:ns))), nx, ns);
            end
            
            % if reordered elements if they were not monotonically increasing, put back in original
            if reordered
                temp = B;
                B(isrt,:) = temp;
            end
        end
        
        function out = functionEval(obj, X, coeffs)
            % Evaluate function with respect to coeffs at positions X. Each
            % *row* of X must correspond to a point to evaluate.
            % function is flatlined outside of specified knot iterval.
            
            N     = size(X,1);
            assert(ismatrix(X), 'X must be a matrix, not a tensor');
            [m1, m2] = size(coeffs);
            T     = numel(obj.t);
            
            if m1 ~= T-2
                if m2 == T-2     % transpose if required, and swap dims
                    coeffs   = coeffs';
                    [m1, m2] = deal(m2, m1);
                else
                    error('coeffs are not conformable to the number of knots (%d)', T);
                end
            end
            
            ltK = X < obj.t(1);
            gtK = X > obj.t(end);
            X(ltK | gtK) = obj.t(1);
            
            out = zeros(size(X));
            for ii = 1:N
                B   = obj.basisEval(X(ii,:));
                out(ii,:) = B*coeffs(:,min(ii,m2));
            end
            out(ltK) = coeffs(1);
            out(gtK) = coeffs(end);
        end
    end
    
    %% Internals
    methods (Hidden=true, Access=public)
        function w = wjk(x, j, k)
            w = bsxfun(@minus, x, obj.t(j))./(obj.t(j+k-1) - obj.t(j));
        end
    end
end