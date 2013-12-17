function [idx] = detect_Movement(HandVel, start_idx, end_idx, mvmt_threshold)

%find index in HandVel vector where movement is detected

if nargin < 1
    error('detect_Movement: HandVel vector is required input')
end

if nargin < 2
    start_idx = 1;
end

if nargin < 3
    end_idx = length(HandVel);
end

if nargin < 4
    mvmt_threshold = .1^2 + .05^2;
end
    

for idx = start_idx : end_idx
   if sum(HandVel(idx,:).^2) > mvmt_threshold
       return
   end
end
%error('detect_Movement: no movement detected!')
idx = -1;

end

