function [ data_out, chans ] = abm_to_common(data, events, chans)
%ABM_TO_COMMON Summary of this function goes here
%   Detailed explanation goes here

chan_inds = indexOfStrCell(chans, data{1}.VHeader.Names);
if length(find(chan_inds < 1)) > 0
    error 'Invalid channel names. Not contained in data'
end

nchans = length(chan_inds);
ndata = length(data);
chans{end+1} = 'events';

data_out = cell(1,ndata);
for i=1:ndata
    nsamples = length(data{i}.Sout(1).Signal);
    data_out{i} = zeros(nsamples, length(chan_inds)+1);

    for c=1:nchans
        data_out{i}(:,c) = data{i}.Sout(c).Signal';
    end
    
    % Place markers
    ts_ind = index_of_str(data{i}.VHeader.Names, 'ESU Time Stamp');
    if ts_ind < 0
        error 'File data does not contain ESU timestamp signal'
    end
    ts_signal = data{i}.Sout(ts_ind).Signal;
    
    event_inds = arrayfun(@(ts) min(find(ts_signal >ts)), events{i}.timestamps);
%     event_inds = arrayfun(@(ts) min(find(ts_signal >ts)), events{i}.timestamps, 'UniformOutput', false);
%     event_inds = events{i}.timestamps;    
    data_out{i}(event_inds,end) = events{i}.markers;
end

end

