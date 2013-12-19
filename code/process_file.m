function [C, power_all, target_all, classMap] = process_file(e)

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

[N, ~] = count_trials(e);
C = cell(N,1);
counter = 0;


for subj_idx = 1:length(e.Subject)
    for trial_idx = 1:length(e.Subject(subj_idx).Trial)
    
        trial = e.Subject(subj_idx).Trial(trial_idx);
        trial_features = [];
        if ~isempty(trial.Special) & strcmp(trial.Condition,'good')
            counter = counter + 1;
            
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
            C{counter} = trial_features;
            % add trial_features to CELL!!!!!!!!!!!!!!!!
        end
    end
end


end








