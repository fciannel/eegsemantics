OB# eegsemantics
You need to copy the directory coming from the eeg system into the DataFiles.

This is for instance how the directory DataFiles looks like

======================================================================================================================================
data  data_raw

./data:
fciannel

./data/fciannel:
data.mat  data_processed_diff.mat

./data_raw:
0610_1

./data_raw/0610_1:
061001201.ebs                                061001201Decon.ebs          061001201_Events.edf      061001201_accelerometer.bin
061001201.ebs_15_23_515                      061001201_Actigraphy.csv    061001201_HR_beat.csv     061001201_missed_blocks.csv
061001201.ebs_16_31_984                      061001201_Artifact.csv      061001201_HR_epoch.csv    061001201_third_party_data.bin
061001201.ebs_19_33_0                        061001201_ArtifactInfo.csv  061001201_Ref_Class.csv   0610_1.rar
061001201.ebs_19_33_0_impedance_results.csv  061001201_Diff_Class.csv    061001201_Ref_Raw.csv
061001201.edf                                061001201_Diff_Raw.csv      061001201_ZScore_PSD.csv
======================================================================================================================================

To create the data files data.mat and data_processed_diff.mat you need to run the file run_music_exp.m