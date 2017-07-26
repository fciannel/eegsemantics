function [ data] = smoothAll( data, span )
%SMOOTHALL Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(data,2)
    data(:,i) = smooth(data(:,i), span);
end


end

