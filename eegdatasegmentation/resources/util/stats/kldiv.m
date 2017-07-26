function [ kpq, kqp, densities, sampled] = kldiv( dataP, dataQ, samplePoints, epsilon)
%KLDIV Summary of this function goes here
%   Detailed explanation goes here

nchannels = size(dataP,2);
kpq = zeros(1, nchannels);
kqp = zeros(1, nchannels);

densities = zeros(samplePoints, 2, nchannels);
sampled = zeros(nchannels, samplePoints);

parfor c=1:nchannels
    [~,xi] = ksdensity(vertcat(dataP(:,c),dataQ(:,c)), 'npoints', samplePoints);
    [fP,xiP] = ksdensity(dataP(:,c),xi);
    [fQ,~] = ksdensity(dataQ(:,c),xi);
    
    fP = fP + epsilon;
    fQ = fQ + epsilon;
    
    kpq(1,c) = sum(log(fP./fQ).*fP); % might get a div zero error!
    %{
    [fQ,xiQ] = ksdensity(dataQ(:,c),xi);
    [fP,~] = ksdensity(dataP(:,c),xi);
    
    fP = fP + epsilon;
    fQ = fQ + epsilon;
    %}
    
    kqp(1,c) = sum(log(fQ./fP).*fQ); % might get a div zero error!
    
    densities(:,:,c) = [fP;fQ]';
    sampled(c,:) = xi;
end


end

