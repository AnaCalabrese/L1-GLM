function fig = test_glm(EstParams, Data)
    % inputs:
    %   EstParams: parameter estimates
    %   Data: stimuli and actual responses
    
    %% define some parameters
    test_stim = 1;                              % test stimulus (not includded in training set)
    tbin      = 3;                              % time bin in ms
    dt         = tbin * 0.001;                  % time step
    fsubsample = 3;                             % frequency subsampling    
    ntrials    = length(Data(test_stim).trial); % number of trials
    bias       = EstParams.bias;
    if isempty(EstParams.shist)
        model = 'ln';
    else
        model = 'glm';
    end
        
    fig = figure;
    
    % get high-res strf and plot it
    strf = EstParams.strf;
    strfUP = UpsampleGLM(strf,3);
    subplot (6, 2, [1 3]);
    imagesc(strfUP);axis xy
    caxis([-max(abs(strfUP(:))) max(abs(strfUP(:)))]);
    set(gca,'YTick',[15 30 45 60]);
    set(gca,'YTickLabel',{'2';'4';'6';'8'});
    ylabel('Frequency (kHz)');
    xlabel('Time before spike (ms)');
    text(50,56, 'learned STRF');
    
    
    % get and process the test stimulus
    stim = get_test_stim(Data,test_stim, fsubsample);
  
    switch model
        case 'ln'   
            % compute model response
            [lambda_model, r_model] = sample_resp_lnp(stim, bias, strf, dt, ntrials);
            
        case 'glm'
            % plot spike history term
            h_filter = EstParams.shist;
            subplot (6,2, [2 4]);
            plot(exp(h_filter(end:-1:1)), '.-');
            xlim([1 5]);
            set(gca,'XTick',[1 2 3 4 5]);
            set(gca,'XTickLabel',{'3';'6';'9';'12';'15'});
            xlabel('Time after spike (ms)');
            ylabel('Gain');
            text(1.4,1.4, 'learned post-spike filter');
         
            % compute model response
            [lambda_model, r_model] = sample_resp_glm(stim, bias, strf, h_filter, dt, 100);                   
    end
    
    % get actual psth for test stim 
    psth = get_psth(test_stim, Data);
    
    % get model prediction
    model_psth    = sum(r_model,1) / 100;
    
    % smooth PSTHs 
    smooth        = round(5/3);  % use a 5 ms smoothing window
    model_psth_sm = convn(model_psth, hanning(smooth)','same');
    psth_smoothed = convn(psth,hanning(smooth)','same');
    
    % compute correlation btw model prediction and actual response
    cc      = corrcoef(model_psth_sm(round(1000/3):end), psth_smoothed(round(1000/3):end));
    CC      = cc(1,2);
    
    % plot traces
    subplot(6,2,[7 8]);
    plot(psth_smoothed(200:end),'Color',[0.5 0.5 0.5],'LineWidth',1);
    hold on;
    plot(model_psth_sm(200:end),'Color',[0.5 0 0],'LineWidth',1);
    xlim([1 length(psth_smoothed)-200]);
    ylim([0 max(psth_smoothed)+0.1]);
    set(gca,'XTickLabel',{});
    legend('recorded','predicted','Location', 'NorthWest');
    text(300,0.8, ['prediction corr coef =' num2str(CC)]);
    title('Time varying firing rate for a novel stimulus');   
   
    % plot rasters
    plot_rasters(Data, test_stim, r_model(1:10,:));

end