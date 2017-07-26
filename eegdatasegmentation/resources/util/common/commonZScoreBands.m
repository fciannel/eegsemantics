function [ data ] = commonZScoreBands( data, nbands)
%COMMONZSCOREBANDS Summary of this function goes here
%   Detailed explanation goes here

ndata = length(data)
nchannels = size(data{1}, 2)-1;


for i=1:ndata
    for b=1:nbands
        data{i}(:,[b:nbands:nchannels]) = ...
            zscore(data{i}(:,[b:nbands:nchannels]),[], 2);    
    end
end

