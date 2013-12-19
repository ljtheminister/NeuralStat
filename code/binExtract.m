function [features, power_all, target_all, classMap] = binExtract(e)

overlap = 156; %overlap in ms
window = 100 + overlap; %window length in ms (100 ms + overlap)

sampling_rate = 2000;
len_window = window/1000 * sampling_rate; %number of elements in window
len_overlap = overlap/1000 * sampling_rate; %number of elements in overlap

NFFT = 2^nextpow2(len_window); % Next power of 2 from length of y
freqs = sampling_rate/2*linspace(0,1,NFFT/2+1);

%start_offset = -20;
%end_offset = 50;

power_all = zeros(257,1);
target_all = [];

k = {'NW', 'N', 'NE', 'W', 'E', 'SW', 'S', 'SE'};
v = {1,2,3,4,5,6,7,8};
classMap = containers.Map(k,v);

k = {'0-4', '7-20', '70-200', '200-300'};

v1 = find(freqs>=0 & freqs <=4);
v2 = find(freqs>=7 & freqs <=20);
v3 = find(freqs>=70 & freqs <=200);
v4 = find(freqs>=200 & freqs <=300);

v = {v1, v2, v3, v4};

bin_map = containers.Map(k,v);



%[N, ~] = count_trials(e);
%C = cell(N,1);
%C_rest = cell(N,1);
%counter = 0;

features = [];


for subj_idx = 1:length(e.Subject)
    for trial_idx = 1:length(e.Subject(subj_idx).Trial)
    
        trial = e.Subject(subj_idx).Trial(trial_idx);
        trial_features = [];
        %trial_rest_features = [];
        if ~isempty(trial.Special) & strcmp(trial.Condition,'good')
            %counter = counter + 1;
            target_all = [target_all; classMap(trial.Special.TargDir)];


            % Feature Extraction - mvmt analysis/which columns to use
            idx_1 = find(~isnan(trial.TargetPos(:,1)), 1, 'first');
            idx_2 = find(~isnan(trial.TargetPos(:,1)), 1, 'last');

            [~, index] = ismember(trial.TargetPos(idx_1,1), trial.TargetPos(:,1));
            if idx_2 == index %if there is only one TargetPos
                mvmt_idx = detect_Movement(trial.HandVel, idx_1);
            else
                mvmt_idx = detect_Movement(trial.HandVel, index+1);
            end
            % FIGURE OUT WHICH COLUMNS!!!!!!!!!
            extract_cols = best_mvmt_windows(trial.HandVel, mvmt_idx);
            rest_cols = rest_values(trial.HandVel, idx_1, idx_2);    
            % COMBINE ALL OF NEURONS FOR EACH TRIAL
        
            for neuron_idx = 1:length(trial.Neuron)
                neuron = trial.Neuron(neuron_idx);
                neuron_features = [];
                neuron_rest_features = [];
                if ~isempty(neuron.LFP)
                    fft_mat = fftLFP(neuron.LFP, len_window, len_overlap);
                    % aggregate all power levels for each neuron per trial
                    for col_idx = 1:size(fft_mat,2)
                        power_window = FFT_magnitude(fft_mat(:, col_idx), len_window);
                        binned_window = bin_windows(bin_map, freqs, power_window);
                        
                        power_all = power_all + power_window;
                        
                        if ismember(col_idx, extract_cols)
                            neuron_features = [neuron_features binned_window'];
                        end %close if 
                    
                        if ismember(col_idx, rest_cols)
                            neuron_rest_features = [neuron_rest_features binned_window'];
                        end
                        
                    end % close fft_mat col loop
                relative_features = neuron_features - neuron_rest_features;
                trial_features = [trial_features relative_features];
                end % close LFP if block
            end %close neuron for loop
            features = [features; trial_features];
        end
    end
end


end


