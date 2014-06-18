function [strfUP] = UpsampleGLM(strf, binsize)
%Upsample a GLM strf in frequency and time using a cubic spline


%% Do a 3x upsampling with a cubic spline
for j = 1:size(strf,1),
    strf2(j,:) = spline(1:size(strf,2),strf(j,:),1:1/binsize:(size(strf,2)+(binsize-1)/binsize));
end
for j = 1:size(strf2,2),
    strfUP(:,j) = spline(1:size(strf2,1),strf2(:,j),1:1/binsize:(size(strf2,1)+(binsize-1)/binsize));
end

%% Get rid of border effects
nf = length(strfUP(:,1));
nt = length(strfUP(1,:));

strfUP(1:2,:)      = zeros(2, nt);
strfUP(nf-1:nf,:)  = zeros(2, nt);
strfUP(:,1:2)      = zeros(nf, 2);
strfUP(:,nt-1:nt)  = zeros(nf, 2);
