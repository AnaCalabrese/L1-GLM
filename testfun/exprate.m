function lambda = exprate(stim, bias, strf)
% This function uses an exponential nonlinearity to create lambda from
% the filter and spikes  

[stimd1 stimd2]  = size(stim);
[strfd1 strfd2] = size(strf);

% convolve stimulus and filter ...
pred = zeros(1, stimd2);
for i = 1 : stimd1
    X     = genstimhist(strfd2,stim(i,:));
    ptemp = X * (strf(i,:)).';
    pred  = pred + ptemp.';
end

% compute lambda
%lambda = exp(pred + bias);
lambda = exp(min(pred + bias, 100));

