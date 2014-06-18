function [lnp_lambda, r_lnp] = sample_resp_lnp(stim, bias, strf, dt, ntrials)

    T = length(stim(1,:));

    lnp_lambda = exprate(stim, bias, strf);

    r_lnp = zeros(ntrials,T);
    for i = 1 : ntrials
        r_lnp(i,:) = binornd(1, lnp_lambda * dt);
    end

end

