function out = softmax(x)
    % softmax(x)
    % Computes softmax := exp(x_i)./(\sum_j exp(x_j)) avoiding underflow
    % / overflow problems
    
    x     = x - max(x);
    x     = exp(x);
    out   = x./sum(x);
    
end

