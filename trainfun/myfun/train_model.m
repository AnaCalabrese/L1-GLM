function EstParams = train_model(Data)
    % Estimates model parameters: 
    %     - bias (sets the baseline firing rate)
    %     - STRF
    %     - post-spike filter
    % INPUT: Data structure containing stimuli (spectrograms) and responses 
    % (spike trains, 10 trials for each stimulus) for a single unit. The
    % strutcture contains 30 stimuli (10 ml-noise and 20 zf songs)
    % Spectrograms and responses are computed with a 3 ms bin.
    % OUTPUT: Structure containing the estimates 
    
    % Strucutre where results will be stored
    EstParams = struct('strf',[],'bias',[],'shist',[]);
    
    % Preprocess stimuli and responses
    stim = get_longStim(Data); 
    resp = get_long_resp(Data);
    
    % Subsample the frquency dimension of the stimulus
    stim = stim(1:3:60,:);

    % Define some additional parameters
    tbin    = 3;                % time bin in ms
    dt      = tbin * 0.001;     % time step for simulations (in s)
    ntstrf  = 60/tbin;          % total length in time of the STRF in ms     
    ntshist = 5;                % number of steps back in time to include
    
    if ntshist ~= 0
        model = 'glm';    
    else model = 'ln';
    end
    
    % Initialize parameters: set all parameters to be initially 0
    [f N]= size(stim);   
    nVariables = 1 + ntstrf * f + ntshist;
    w_init = zeros(nVariables, 1);

    % solve the optimization problem
    switch model      
        case 'ln'
            % Construct augmented matrix    
            X = [ones(N,1) genstimhist(ntstrf, stim)]; 

            % represent x as a stim history matrix
            StimHist = zeros(length(stim(1, :)), ntstrf, length(stim(:, 1)));
            for i = 1 : length(stim(:, 1))
                StimHist(:, :, i) = genstimhist(ntstrf, stim(i,:));
            end

            % Set penaliztion to apply to the STRF (higher values yield 
            % more regularization/sparsity)
            C = 800; 

            % Penalize all variables except bias
            CVect = [0 ; C * ones(nVariables-1, 1)];

            % Use default options
            global_options = [];

            % Define loss function
            loss = @loglike;

            % Set arguments for the loss function
            lossArgs = {X,stim,resp,dt,ntstrf,ntshist,StimHist};

            % Optimize using a smooth approximation of the L1 norm
            optimFunc = @L1GeneralUnconstrainedApx;
            options = global_options;
            options.solver = 2; % 2nd-Order short-cut method

            wSmoothL1sc = optimFunc(loss,w_init,CVect,options,lossArgs{:});

            bias_e  = wSmoothL1sc(1);
            strf_e  = wSmoothL1sc(2 : ntstrf*f+1);
            strf_e  = reshape(strf_e, f, ntstrf);
        
        case 'glm'
            % Construct augmented stimulus matrix including spike history
            History = zeros(N, ntshist);
            for j = 1 : ntshist
                 History(:, j) = [zeros(ntshist-j+1, 1)' resp(1:length(resp)-(ntshist-j+1))]; 
            end
            X = [ones(N,1) genstimhist(ntstrf, stim) History];

            % Represent X as a stim history matrix
            StimHist = zeros(length(stim(1, :)), ntstrf, length(stim(:, 1)));
            for i = 1 : length(stim(:, 1))
                StimHist(:, :, i) = genstimhist(ntstrf, stim(i,:));
            end

            % Set penalty for STRF (and optionally) post-spike filter 
            C = 500; % penalty for the STRF
            Ch = 1;  % penalty for the post-spike filter
            
            % Penalize all variables except bias
            CVect = [0 ; C * ones(nVariables-1-ntshist, 1) ; Ch*ones(ntshist, 1)];
            
            % Use default options
            global_options = [];

            %define loss function
            loss = @loglike_glm;

            % set arguments for the loss function
            lossArgs = {X,stim,resp,dt,ntstrf,StimHist};

            % optimize using a smooth approximation of the L1 norm
            optimFunc = @l1generalunconstrainedapx;
            options = global_options;
            options.solver = 2; % 2nd-Order short-cut method

            wSmoothL1sc = optimFunc(loss,w_init,CVect,options,lossArgs{:});

            bias_e  = wSmoothL1sc(1);
            strf_e  = wSmoothL1sc(2 : ntstrf*f+1);
            strf_e  = reshape(strf_e, f, ntstrf);
            shist_e = wSmoothL1sc(ntstrf*f+2 : end);
            
            EstParams.shist = shist_e;    
    end

    % Store results 
    EstParams.strf = strf_e;
    EstParams.bias = bias_e;
        
end