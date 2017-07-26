function [ data_out, positions ] = breakup_data( data, chans, window, offset)
%BREAKUP_DATA Summary of this function goes here
%   Detailed explanation goes here

% Count number of data sections
n = 0;
for i=1:length(data.segments);
    for j=1:length(data.segments{i});
        n = n + floor((size(data.segments{i}{j},1)-window)/offset);
    end
end

data_out = zeros(n, window, length(chans));
positions = zeros(n,4);

curr = 0;
for i=1:length(data.segments);
    for j=1:length(data.segments{i});
        start = 1;
        stop = window;
        while( stop < size(data.segments{i}{j}, 1))
            curr = curr + 1;
            
            data_out(curr, :,:) = data.segments{i}{j}(start:stop,chans);
            positions(curr,:) = [i,j,start,stop];
            
            start = start + offset;
            stop = stop+offset;
        end
    end
end

end

