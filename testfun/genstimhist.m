function X = genstimhist(M,x)
% X = genstimhist(M,x)
% Given the stimulus x, genstimhist
% generates an N x M stimulus history matrix, X.
% x should be a PXN matrix.
% M is the length of the filter h.  
%
% X is constructed so that 
% y = Xh
% is the convolution of h with x.

[P N] = size(x);
X = zeros(N,M*P);
if N<M
    for tau =1:N
        % legal values in convolution sum j
        j0 = max(1,tau+1-M);
        jmax = min(tau,N);
        j = jmax:-1:j0;
        X(tau,1:length(j)) = x(j);
    end
else
    for p=0:M-1
        X(p+1:end,P*p+1:P*(p+1)) = x(:,1:end-p).';
    end
end
