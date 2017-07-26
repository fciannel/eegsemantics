function [ out ] = combineSegments( segs )
%COMBINESEGMENTS Summary of this function goes here
%   Detailed explanation goes here

nsegs = length(segs);

out.chans = segs{1}.chans;
out.markers = segs{1}.markers;

nmarkers = length(out.markers);
out.segments = cell(1,nmarkers);

for i=1:nmarkers
    out.segments{i} = {};
end

for i=1:nsegs
    for j=1:nmarkers
        for k=1:length(segs{i}.segments{j})
            out.segments{j}{end+1} = segs{i}.segments{j}{k};
        end
    end
end

end

