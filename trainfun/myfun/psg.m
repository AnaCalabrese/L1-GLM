
function [r, lambda] = PSG(stim, theta, ntstrf, dt, nsamp)
% r = PSG(stim, theta, ntstrf, dt)
% a poisson spike generator that convolves the stim with theta
% pass in number of time bins for strf and dt

nfreq   = size(stim, 1);
ntshist = length(theta) - 1 - ntstrf * nfreq;

[strf shist bias] = t2f(theta, nfreq, ntstrf, ntshist);

lambda = exprate(stim, bias, strf);

if any(lambda*dt > 1)
    warning('Lambda * dt > 1.');
end

for i = 1 : nsamp
    r(i, :) = binornd(1, lambda*dt);
end
