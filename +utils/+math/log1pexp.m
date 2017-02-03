function f = log1pexp(x)
    % f = log1pexp(x)
    % Computes the value log(1+ exp(x)).
    % This function is numerically badly behaved in finite precision
    % arithemtic. The value approaches exp(x) for moderate-sized negative
    % x, and approaches x for moderate-sized positive x. The following
    % thresholds were calculated by Sachin Shanbhag: see
    % http://sachinashanbhag.blogspot.co.uk/2014/05/numerically-approximation-of-log-1-expy.html
    
    f       = x;
    
    % Thresholds
    xSmall  = x < -10;
    xOK     = ~(xSmall) & x <= 35;
    
    % vectorised if-else
    f(xSmall) = exp(x(xSmall));
    f(xOK)    = log(1 + exp(x(xOK)));
end