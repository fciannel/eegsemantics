function [ data_out ] = keepChans( data, chans )
%KEEPCHANS Summary of this function goes here
%   Detailed explanation goes here
ndata = length(data);
data_out = cell(1,ndata);
markerchan = size(data{1},2);

for i=1:ndata
    data_out{i} = data{i}(:, [chans markerchan]);
end

