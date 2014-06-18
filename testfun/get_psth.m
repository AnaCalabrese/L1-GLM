function psth = get_psth(i, Data) 
     
    n = length(Data(i).trial);
    
    n_spk = zeros(1,length(Data(i).trial(1).spikes));
    for k = 1 : n
        spks = Data(i).trial(k).spikes;
        n_spk = n_spk + spks;    
    end 
    psth = n_spk ./ n;
 

end

