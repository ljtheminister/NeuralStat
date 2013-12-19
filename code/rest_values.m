function [ rest_cols ] = rest_values ( HandVel, idx_1, idx_2 )

%len = length(LFP);

if idx_1 >= 70 % find rest before mvmt
    rest_cols = 1:7;
    
else % find rest after mvmt
    rest_idx = 15 + idx_2;
    rest_cols = best_mvmt_windows(HandVel, rest_idx, 0, 70, -1);
end

