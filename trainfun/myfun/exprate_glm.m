function lambda = exprate_glm(stim, r, bias, strf, shist, StimHist)
% This function uses an exponential nonlinearity to create lambda from
% the filter and spikes  

[stimd1 stimd2]  = size(stim);
[strfd1 strfd2] = size(strf);

% convolve stimulus and filter ...
pred = zeros(1, stimd2);
for i = 1 : stimd1
    ptemp = StimHist(:, :, i) * (strf(i,:)).';
    pred  = pred + ptemp.';
end

% convolve hist filter and response
histerm = zeros(1, length(r));
for k = 1 : length(r)
    aux = 0;
    for j = 1 : length(shist)
        if k-j > 0
            aux = aux + shist(j) * r(k-j);
        else 
            aux = aux + 0;
        end
    end
    histerm(k) = aux;
end

% compute lambda
lambda = exp(min(pred + bias + histerm, 100));


