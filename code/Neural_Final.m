e1 = load('./data/Flint_2012_e1.mat');
e2 = load('./data/Flint_2012_e2.mat');
e3 = load('./data/Flint_2012_e3.mat');
e4 = load('./data/Flint_2012_e4.mat');
e5 = load('./data/Flint_2012_e5.mat');

e2_1 = e2.Subject(1);


overlap = 156; %overlap in ms
window = 100 + overlap; %window length in ms (100 ms + overlap)

sampling_rate = 2000;
len_window = window/1000 * sampling_rate; %number of elements in window
len_overlap = overlap/1000 * sampling_rate; %number of elements in overlap

freq_list = zeros(257,1);

trial = e3.Subject(4).Trial(4);
idx_1 = find(~isnan(trial.TargetPos(:,1)), 1, 'first');
idx_2 = find(~isnan(trial.TargetPos(:,1)), 1, 'last');

[~, index] = ismember(trial.TargetPos(idx_1,1), trial.TargetPos(:,1));


mvmt_idx = detect_Movement(trial.HandVel, index+1);

% FIGURE OUT WHAT MATRIX COLUMNS TO USE FOR FFT


start_offset = -20;
end_offset = 50;

window_beg = mvmt_idx + start_offset;
window_end = mvmt_idx + end_offset -1;

% LFP data
LFP_beg = 1 + (window_beg - 1)*20;
LFP_end = 1 + (window_end - 1)*20;

% for each neuron
% LFP_data = neuron.LFP(LFP_beg:LFP_end)
% bin the LFP_data

%%% Aggregate all the data
freq_all = zeros(257,1);
for subj_idx = 1:length(e.Subject)
    
    for trial_idx = 1:length(e.Subject(subj_idx).Trial)
    
        trial = e.Subject(subj_idx).Trial(trial_idx);
        
        if trial.Special & strcmp(trial.Condition,'good')
     
        
        
        
 
            for neuron_idx = 1:length(trial.Neuron)
            
                neuron = trial.Neuron(neuron_idx);
        
                fft_mat = fftLFP(neuron.LFP, len_window, len_overlap);
                
                plotFFT(fft_mat(:,1), 512, 2000)
                
                
                len = 512;
                Fs = 2000;
                NFFT = 2^nextpow2(len); % Next power of 2 from length of y
                f = Fs/2*linspace(0,1,NFFT/2+1);
                for col = 1:size(fft_mat,2)
                    plot(f,2*abs(fft_mat(1:NFFT/2+1, col))) 
                    %hist(2*abs(fft_mat(col, 1:NFFT/2+1)), 1000)
                end
            
            end
            
        end    
            
        
        
        
    end
    
    
end


%%% Feature Extraction



%%% Dimension Reduction via Principal Components Analysis


%%% Classification
            
