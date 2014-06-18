%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script fits a generalized linear model (GLM) to responses to zebra 
% finch song recorded from a single auditory midbrain neuron.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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