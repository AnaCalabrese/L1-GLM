

function [strf shist bias] = t2f(theta, nfreq, ntstrf, ntshist)
%[strf shist bias] = t2f(theta,dims)
%theta to filters: takes in theta and returns filters

bias  = theta(1);
strf  = theta(2 : 1+nfreq*ntstrf);
shist = theta(2+nfreq*ntstrf : end);

strf = reshape(strf, nfreq, ntstrf);

