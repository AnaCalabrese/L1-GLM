function stim = get_longStim(Data)
    % creates one big stimulus matrix concatenating the individual matrices
    % for each of the songs (or ml-noise) included in the training set. 
    
    longStim = [];

    for i = 2:10 % stimui used for training the model
        longStim = [longStim Data(i).spectrogram]; 
    end
    stim = [];
    for j = 1 : length(Data(1).trial)
        stim = [stim longStim]; 
    end
end