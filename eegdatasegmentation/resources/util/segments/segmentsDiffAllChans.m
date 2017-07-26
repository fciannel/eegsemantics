function [ segs_diff_out ] = segmentsDiffAllChans( segs )
%SEGMENTSDIFFALLCHANS Summary of this function goes here
%   Detailed explanation goes here


nmarkers = length(segs{1});
nchans = size(segs{1}{1},2);
nsegs = length(segs);
segs_diff = cell(1,nmarkers);

parfor s=1:nsegs
    segs_diff{s} = cell(1,nmarkers);
    for m=1:nmarkers
        tic
        segs_diff{s}{m} = diffAllChans(segs{s}{m});
        toc;
    end
end

segs_diff_out = cell(1,nmarkers);

for m=1:nmarkers
    segs_diff_out{m} = cell(1,nsegs);
    for s=1:nsegs
        segs_diff_out{m}{s} = segs_diff{s}{m};
    end
end

end

