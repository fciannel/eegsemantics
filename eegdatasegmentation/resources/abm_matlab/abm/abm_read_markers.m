function [ events ] = abm_read_markers( bin_fname, first_marker)
%ABM_READ_MARKERS Reads the *_third_party_data.bin 
%   file associated with a run on an experiment and
%   outputs a list of marker valeus and a corresponding
%   list of timestamps

fid = fopen(bin_fname);
data = fread(fid);
nbytes = length(data)

current = 1;

markers = zeros(0,1);
timestamps = zeros(0,1);

while(current < nbytes)
    current = current + 3;
    
    % Read timestamp
    
    ts = data(current)*2^24;
    current = current + 1;
    ts = ts + data(current)*2^16;
    current = current + 1;
    ts = ts + data(current)*2^8;
    current = current + 1;
    ts = ts + data(current);
    
    
    % Read packet length
    current = current+1;
    packet_len = data(current)*2^8 + data(current+1);
    
    current = current+2;
    
    m = data(current+packet_len-2); % This is a hack?
   
    current = current+packet_len;
    if length(markers) == 0 && m ~= first_marker
        continue
    end
    markers(end+1) = m;
    timestamps(end+1) = ts;
    
end

events.markers = markers;
events.timestamps = timestamps;

end

