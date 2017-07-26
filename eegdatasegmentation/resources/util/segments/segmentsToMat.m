function [ out ] = segmentsToMat( segments, sampleLengths )
%SEGMENTSTOMMAT Summary of this function goes here
%   Detailed explanation goes here

nmarkers = length(segments.markers);
nchans = length(segments.chans);

out.chans = segments.chans;
out.markers = segments.markers;
out.segments = cell(1, nmarkers);

for i=1:nmarkers
    out.segments{i} = zeros(sampleLengths(i), nchans, 0);
end

for i=1:nmarkers
    for j=1:length(segments.segments{i})
        out.segments{i} = cat(3, out.segments{i},...
            segments.segments{i}{j}(1:sampleLengths(i),:));
    end
end


end

