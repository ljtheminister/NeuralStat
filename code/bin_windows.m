function [ binned_data ] = bin_windows(bin_map, freqs, power_window)

lmp = LMP( power_window, freqs);
keys = bin_map.keys();
len_keys = length(keys);

binned_data = zeros(len_keys+1,1);

for i = 1:len_keys
    
    indices = bin_map(keys{i});
    
    pwr = 0;
    for j = 1:length(indices)
        pwr = pwr + power_window(indices(j));
    end

    binned_data(i) = pwr;
end

binned_data(i+1) = lmp;
end




% k = {'0-4', '7-20', '70-200', '200-300'};
% 
% v1 = find(freqs>=0 & freqs <=4);
% v2 = find(freqs>=7 & freqs <=20);
% v3 = find(freqs>=70 & freqs <=200);
% v4 = find(freqs>=200 & freqs <=300);
% 
% v = {v1, v2, v3, v4};
% 
% bin = containers.Map(k,v)