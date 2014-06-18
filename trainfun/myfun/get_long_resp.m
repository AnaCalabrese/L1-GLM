function response = get_long_resp(Data)
    % creates one big response matrix concatenating the individual response 
    % matrices for each of the songs (or ml-noise) included in the training set. 

     
    for k = 1 : length(Data(1).trial)
        longresp = [];
            
        for i = 2:10 % responses used to train the model
         longresp = [longresp Data(i).trial(k).spikes];
        end
        resp(k, :) = longresp;
    end
    
    response = [];
    for k = 1 : length(resp(:,1))
        response = [response resp(k, :)]; 
    end
end