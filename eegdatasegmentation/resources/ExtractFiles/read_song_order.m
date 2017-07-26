function [ order ] = read_song_order( stim_path, total_songs_trial, num_trials )
% Reads the order of songs played from the given stim file.
% Takes in a file name, total number of songs per trial, number of trials
% per set

    %generate a matrix large enough to hold all songs
    order = cell(1,total_songs_trial*num_trials);

    %follow the provided stim path
    f = fopen(stim_path, 'r');
    
    %read the first line
    line = fgets(f);
    
    n = 0;
    
    while ischar(line)
        temp = strsplit(strtrim(line),' ');
        
        %if we encounter something other than 'Trial' such as 'length'
        %or 'reflection time' that signals completion of loop through
        %trials
        if(strcmp(temp(1),'Trial') ~= 1) 
            break;
        end
        
        %explanation of for loop: a +3 is added to account for the first 3
        %inputs read as 'Trial' '1' 'sequence: ' followed by the stim
        %song numbers
        for i = (1+3):(total_songs_trial+3)  
                order{n+i-3} = temp{i};
        end
        
        %increment to access the next line
        n = n+total_songs_trial;
        line = fgets(f);
             
    end

end