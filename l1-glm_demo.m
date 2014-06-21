% This script fits an L1-regularized generalized linear model (L1-GLM) to
% to neuronal spike train responses of a single auditory neuron probed with 
% bird songs. The learned model is then used to predict the response of this 
% neuron to a novel stimulus. Please see the manuscript included in this 
% directory (L1-GLM.pdf) for details about the method and notation.
% Use this code at your own risk but please reference our work.

% add all the necessary functions to the path
addpath(genpath(pwd));

% train model
tic;
disp('Estimating model parameters ...')
load Data.mat
K = train_model(Data);

% test model and plot results
disp('Predicting response ...')
fig =  test_glm(K, Data);
toc;