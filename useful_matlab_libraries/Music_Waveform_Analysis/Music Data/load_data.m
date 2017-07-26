% Load Randall's music clips 

% Pick the audioread frequecy
%Fs = 44100;

% Save current folder
current_folder = pwd;

cd('../../../../Music-Files-Randall/Worst');

disp('obtaining Worst music data files...')
    
files = dir('*.wav');

addpath(genpath(pwd));

for i = 1:length(files)
    filename = files(i).name;
    out_name = strrep(s, '.wav', '');
    out_name = genvarname(out_name);
    [getvarname(out_name),Fs] = audioread(filename);
end