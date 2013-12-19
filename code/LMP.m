function [lmp] = LMP( power_window, freqs )
lmp = dot(power_window, freqs);
end

