function stim = get_test_stim(Data, test_stim, fsubsample)

    % get the test stimulus
     stim = Data(test_stim).spectrogram;
    
    % subsample the stimulus: method 1    
    stim = stim(1:fsubsample:60,:);    
    
end