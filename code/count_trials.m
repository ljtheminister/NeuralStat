function [num_trials, num_neurons_list] = count_trials (e)

num_trials = 0;
num_neurons_list = [];

for subj_idx = 1:length(e.Subject)
    for trial_idx = 1:length(e.Subject(subj_idx).Trial)
        trial = e.Subject(subj_idx).Trial(trial_idx);
        if ~isempty(trial.Special) & strcmp(trial.Condition,'good')
            num_trials = num_trials + 1;
%             num_neurons = 0;
%             for neuron_idx = 1:length(trial.Neuron)
%                 neuron = trial.Neuron(neuron_idx);
%                 if ~isempty(neuron.LFP)
%                     num_neurons = num_neurons + 1;
%                 end
%             end
%             num_neurons_list = [num_neurons_list; num_neurons];
        end
    end
end
end