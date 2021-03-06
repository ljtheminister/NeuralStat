e = load('../data/Flint_2012_e1.mat');
e = load('../data/Flint_2012_e2.mat');
e = load('../data/Flint_2012_e3.mat');
e = load('../data/Flint_2012_e4.mat');
e = load('../data/Flint_2012_e5.mat');


overlap = 156; %overlap in ms
window = 100 + overlap; %window length in ms (100 ms + overlap)

sampling_rate = 2000;
len_window = window/1000 * sampling_rate; %number of elements in window
len_overlap = overlap/1000 * sampling_rate; %number of elements in overlap

NFFT = 2^nextpow2(len_window); % Next power of 2 from length of y
freqs = sampling_rate/2*linspace(0,1,NFFT/2+1);


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
power_all = zeros(257,1);
target_all = [];


%%% CELL FOR FEATURES OF EACH TRIAL

% THIS SHOULD FUNCTION FOR EACH FILE

%C = cell(length(e.Subject), 1);

for subj_idx = 1:length(e.Subject)
end

k = {'NW', 'N', 'NE', 'W', 'E', 'SW', 'S', 'SE'};
v = {1,2,3,4,5,6,7,8};
classMap = containers.Map(k,v);


subj_idx = 1;
%trial_idx = 4;
counter = 0;







for subj_idx = 1:length(e.Subject)
    
    for trial_idx = 1:length(e.Subject(subj_idx).Trial)
    
        trial = e.Subject(subj_idx).Trial(trial_idx);
        
        if ~isempty(trial.Special) & strcmp(trial.Condition,'good')
            target_all = [target_all; classMap(trial.Special.TargDir)];


            % Feature Extraction - mvmt analysis/which columns to use
            %trial.Special.TargDir
            trial_idx
            %trial
            %trial.HandVel
            idx_1 = find(~isnan(trial.TargetPos(:,1)), 1, 'first');
            idx_2 = find(~isnan(trial.TargetPos(:,1)), 1, 'last');

            [~, index] = ismember(trial.TargetPos(idx_1,1), trial.TargetPos(:,1));
            if idx_2 == index
                mvmt_idx = detect_Movement(trial.HandVel, idx_1);
            else
                mvmt_idx = detect_Movement(trial.HandVel, index+1);
            end
            % FIGURE OUT WHICH COLUMNS!!!!!!!!!
            extract_cols = best_mvmt_windows(trial.HandVel, mvmt_idx);

            trial_features = [];
                
                % COMBINE ALL OF NEURONS FOR EACH TRIAL
        
            for neuron_idx = 1:length(trial.Neuron)
            
                neuron = trial.Neuron(neuron_idx);
                if ~isempty(neuron.LFP)

                    fft_mat = fftLFP(neuron.LFP, len_window, len_overlap);
                    % aggregate all power levels for each neuron per trial
                    for col_idx = 1:size(fft_mat,2)
                        power_window = FFT_magnitude(fft_mat(:, col_idx), len_window);
                        power_all = power_all + power_window;
                        
                        if ismember(col_idx, extract_cols)
                            trial_features = [trial_features; power_window'];
                        end %close if 
                    end % close fft_mat col loop
                end % close LFP for loop
            end %close neuron for loop
        
            trial_features
            % add trial_features to CELL!!!!!!!!!!!!!!!!
        
        end
    end
end

%%% Dimension Reduction via Principal Components Analysis


%%% Classification
            
