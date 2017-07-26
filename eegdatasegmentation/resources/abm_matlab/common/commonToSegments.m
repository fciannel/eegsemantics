function [ segmented ] = commonToSegments( data, chans, markers )
%COMMONTOSEGMENTS Summary of this function goes here
%   Detailed explanation goes here

ndata = length(data);
nmarkers = length(markers);
segmented.chans = chans(1:end-1);
segmented.markers = markers;
segmented.segments = cell(1, nmarkers);

for i=1:ndata
    for m=1:nmarkers
        m_inds = find(data{i}(:,end) == markers(m))';
        for m_i=m_inds
            % find next marker
            next = min(find(data{i}(m_i+1:end,end) > 0));
            segmented.segments{m}{end+1} = data{i}(m_i:m_i+next-1,1:end-1);
        end
    end
end

end

