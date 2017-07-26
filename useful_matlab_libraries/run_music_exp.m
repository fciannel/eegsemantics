function run_music_exp( subject_name )
% Overall code for Summer 2016 musicality experiment
% Annabelle Lee
%
% Please note: working directory should be "yl&mc" located here:
%   MusicEEGResearch/MATLAB/yl&mc
%
%   Calls the following:
%       - extract_raw_data.m in resources/extract files
%           this requires you to manually input all participant names,
%           ID numbers and experiment size before doing any extraction
%
% Example run: run_music_exp('haowang')
    MATLABBASEDIR = 'C:\Users\Francesco Ciannella\Box Sync\Documents\Homeworks\NC-15686\NCProject\MusicEEGResearch\MATLAB';

    %set up datapaths
    addpath(genpath([MATLABBASEDIR '\resources']));
    addpath(genpath([MATLABBASEDIR '\DataFiles']));
    
    fprintf(['RUNNING EXPERIMENT FOR PARTICIPANT: ' subject_name '\n\n']);
    
    %extract EEG data, channels, order, and participant's manual responses
    fprintf('1. EXTRACTING RAW DATA...\n');
    extract_raw_data(subject_name);
    
    %preprocess data:
    fprintf('2. PREPROCESSING DATA...\n');
    preprocess_data(subject_name);
    
    %run test
    fprintf('4. RUNNING THE TEST...\n');
    dir = [MATLABBASEDIR '\DataFiles\data\' subject_name];
    run_test;
    
    
    
    disp('program complete');
end

