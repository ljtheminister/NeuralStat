function [ freq_list ] = power_values ( LFP )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



overlap = 156; %overlap in ms
window = 100 + overlap; %window length in ms (100 ms + overlap)

sampling_rate = 2000;
len_window = window/1000 * sampling_rate; %number of elements in window
len_overlap = overlap/1000 * sampling_rate; %number of elements in overlap

freq_list = zeros(257,1);





end

