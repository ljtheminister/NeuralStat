function [extract_cols] = best_mvmt_windows(HandVel, mvmt_idx, start_offset, end_offset, worst)
%Look at HandVel vector to determine which 700 ms windows are best for
%extracting around the arm movement

%comparing 2-norm of HandVel - choose 700ms window taking into account more
%velocity aka movement

if nargin < 1
    error('HandVel missing') 
end
if nargin < 2
    error('mvmt_idx missing')
end
if nargin < 3
    start_offset = -20;
end
if nargin < 4
    end_offset = 50;
end
if nargin<5
   worst = 1; 
end


len_bin = end_offset - start_offset;
num_windows = len_bin/10;
%compare HandVelocity sums

floor_idx = max(floor(mvmt_idx/10) * 10, 1);
ceiling_idx = ceil(mvmt_idx/10) * 10;

floor_sum = sum(HandVel(floor_idx : floor_idx + num_windows, :).^2);
ceiling_sum = sum(HandVel(ceiling_idx : ceiling_idx + num_windows, :).^2);

if floor_sum * worst > ceiling_sum
    extract_cols = floor_idx/10: floor_idx/10 + num_windows - 1; 
else
    extract_cols = ceiling_idx/10: ceiling_idx/10 + num_windows - 1;
end
end

