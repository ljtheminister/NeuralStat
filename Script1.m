e1 = load('./Data/Flint_2012_e1.mat')
e2 = load('./Data/Flint_2012_e2.mat')
e3 = load('./Data/Flint_2012_e3.mat')
e4 = load('./Data/Flint_2012_e4.mat')
e5 = load('./Data/Flint_2012_e5.mat')



e2_1 = e2.Subject(1)


overlap = 156 %overlap in ms
window = 100 + overlap %window length in ms (100 ms + overlap)

sampling_rate = 2000
len_window = window/1000 * sampling_rate %number of elements in window
len_overlap = overlap/1000 * sampling_rate %number of elements in overlap


freq_list = zeros(257,1)


for subj_idx = 1:length(e2.Subject)

    subject = e2.Subject(subj_idx)


    for trial_idx = 1:length(subject.Trial)

        trial = subject.Trial(trial_idx);

        for neuron_idx = 1:length(trial)

            neuron = trial.Neuron(neuron_idx);

            fft_mat = fftLFP(neuron.LFP, len_window, len_overlap);


            for window_idx = 1: size(fft_mat, 2)
                fft_mat_col = fft_mat(:,window_idx);
                len = length(fft_mat_col);
                NFFT = 2^nextpow2(len);
                f = sampling_rate/2*linspace(0,1,NFFT/2+1);
                freqs = 2*abs(fftCol(1:NFFT/2+1));
                freq_list = freq_list + freqs;


            end

        end
    end

end







%fft_mat = fftLFP(lfp, len_window, len_overlap)
