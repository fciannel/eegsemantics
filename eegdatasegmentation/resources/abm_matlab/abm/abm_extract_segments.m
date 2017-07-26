function [ data ] = abm_extract_segments(file_data, chans, events, extract_markers)
%EXTRACT_SEGMENTS Summary of this function goes here
%   Detailed explanation goes here


ts_ind = index_of_str(file_data.VHeader.Names, 'ESU Time Stamp');
if ts_ind < 0
    error 'File data does not contain ESU timestamp signal'
end
ts_signal = file_data.Sout(ts_ind).Signal;

%convert channels into indicies
nchans = length(chans);
chan_inds = zeros(1,nchans);
for i=1:nchans
    chan_inds(i) = index_of_str(file_data.VHeader.Names, chans{i});
    if chan_inds(i) < 0
        error(['Channel name at index [' i '] not found']);
    end
end

%find marker ranges
nmarkers = length(extract_markers);
segments = cell(1,nmarkers);
for m=1:nmarkers
    event_inds = find(events.markers == extract_markers(m));
    segments{m} = cell(1, length(event_inds));
    for e=1:length(event_inds)
        seg_range = min(find(ts_signal > events.timestamps(event_inds(e)))):...
                    min(find(ts_signal > events.timestamps(event_inds(e)+1)));
        segments{m}{e} = zeros(length(seg_range),nchans);
        for c=1:nchans
            segments{m}{e}(:,c) = file_data.Sout(c).Signal(seg_range)';
        end
    end
end

data.segments = segments;
data.markers = extract_markers;
data.chans = chans;
end

