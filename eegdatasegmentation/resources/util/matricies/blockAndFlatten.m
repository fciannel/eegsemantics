function [ out ] = blockAndFlatten(M, blocksize)
%BLOCKANDFLATTEN Summary of this function goes here
%   Detailed explanation goes here

out = zeros(0, blocksize*size(M,2));

start = 1;
stop = blocksize;

while(stop <= size(M,1))
    tmp = M(start:stop, :);
    out = vertcat(out, tmp(:)');
    start = stop + 1;
    stop = start +blocksize - 1;
end

end

