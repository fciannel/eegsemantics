function [ out_segs ] = segmentsBreakup( segs, nbreaks )
%SEGMENTSMEAN Summary of this function goes here
%   Detailed explanation goes here

ndata = length(segs);
out_segs = cell(1,ndata);
nchans = size(segs{1}{1}, 2);


for i=1:ndata;
    n = length(segs{i});
    out_segs{i} = cell(1,n);
    for j=1:n
        len = floor(size(segs{i}{j}, 1)/nbreaks);
        out_segs{i}{j} = zeros(len,nchans*nbreaks);
        for m=1:nbreaks
            out_segs{i}{j}(:,(m-1)*nchans+1:m*nchans) = ...
                segs{i}{j}((m-1)*len+1:m*len,:);
        end
    end
    
end

