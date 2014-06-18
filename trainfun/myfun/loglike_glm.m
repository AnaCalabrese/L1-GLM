% objective function for the optimization
function [llneg g H] = loglike_glm(w,X, x, r, dt, m, StimHist)
    % takes a stim x, response r, time bin size dt, strf history m, filter theta
    % returns log likelihood ll, gradient g, hessian h
    
    [f N] = size(x);
    bias  = w(1);
    strf  = w(2 : m*f+1);
    strf  = reshape(strf, f, m);
    shist = w(m*f+2:end);
    
    lambda_rate = exprate_glm(x, r, bias, strf, shist, StimHist);
    
    %calculate the negative of the log likelihood
    llneg = -(-sum(lambda_rate) * dt + r * log(lambda_rate'));
    
    % if number of outputs is greater than 1, calcualte gradient
    if nargout > 1
          g = (-1) *  ((r-lambda_rate*dt) * X)';
          g = g(:);  
    end

    %also, if number of outputs is greater than 2, calculate hessian
    if nargout > 2
        L = repmat(lambda_rate'*dt, 1, f*m+1+length(shist));
        H = X.' * (L .* X);
    end
end
