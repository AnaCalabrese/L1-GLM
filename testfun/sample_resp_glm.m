
function [lambda, r] = sample_resp_glm(stim, bias, strf, shist, dt, ntrials)

T = length(stim(1,:));
h = length(shist);

% initial lambda = lambda from the 'LNP model'
flambda = exprate(stim, bias, strf);
lambda = min(flambda, 1/dt);
lambda(lambda<0) = 0;
lnp_lambda = lambda;

r_lnp = zeros(ntrials,T);
for i = 1 : ntrials
    r_lnp(i,:) = binornd(1, lnp_lambda*dt);
end

% for t = 1 : 10 sample from poisson 
r = zeros(ntrials,T);
for i = 1 : ntrials
    r(i,1:h) = binornd(1, lambda(1:h)*dt);
end


for i = 1:ntrials
    %disp(['predicting trial number: ' num2str(i)]);
    lambda_mod = lambda;
    for t = h+1 : T
        
        % update lambda
        r_hist = r(i,t-h:t-1);
        hist_term = r_hist * shist;
        lambda_mod(t) = lambda_mod(t) * exp(hist_term);
        lambda_mod(t) = min(lambda_mod(t),1/dt);
                % sample the response at time t

        r(i, t) = binornd(1, lambda_mod(t)*dt);
        
    end
end

