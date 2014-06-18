function plot_rasters(Data, k, r_model)
    
    % actual response
    subplot(5,2, [7 8]);
    d = 0;
    for i = 1 : length(Data(k).trial)
        t = find(Data(k).trial(i).spikes);
        spk = 0.1 * ones(1, length(t));
        spk = spk + d;
        plot(t, spk * 10,'.','Color',[0.5 0.5 0.5]);
        d = d + 0.1;
        hold on;
    end
    xlim([200 length(Data(k).spectrogram)]);
    set(gca,'XTickLabel',{});
    ylabel('trial #');

    % glm response
    subplot(5,2,[9 10]);
    
    d = 0;
    for i = 1 : length(r_model(:,1))
        t = find(r_model(i, :));
        spk = 0.1 * ones(1, length(t));
        spk = spk + d;
        plot(t, spk * 10,'.','Color',[0.5 0 0]);
        d = d + 0.1;
        hold on;
    end
    xlim([200 length(Data(k).spectrogram)]);
    set(gca,'XTickLabel',{'-330','-30','270','570','870','1170', '1470', '1770', '2070'});
    xlabel('time after stimulus onset (ms)');
     
end