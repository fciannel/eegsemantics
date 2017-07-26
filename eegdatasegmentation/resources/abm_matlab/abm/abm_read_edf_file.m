function [out]= abm_read_edf_file(FilePath,...
    FileName, Option)

% *********************************************************************** %
%   BRIEF: Function that opens files in the European Data Fomat (EDF),    %
%   such as the ARES EDF files.                                           %
% **********************************************************************  %
%   LAST MODIFIED: 08/13/2012                                             %
%   BY:            Dr. Djordje Popovic                                    %
% *********************************************************************** %
% SYNTAX:
%   [Sout,FHeader,VHeader,Outcome] = read_edf_file(PathName,FileName, Option)
%
% As usual with MATLAB, all output arguments except for the first one (S) 
% can be omitted.
% *************************************************************************
% INPUT ARGUMENTS:                                                         
% -------------------------------------------------------------------------
%       PathName -  a string containing an ABSOLUTE path to the requested 
%                   file.                                                 
%       FileName -  a string containing either the full name (name.ext)or  
%                   only the proper name (no extension) of the requested  
%                   file. If the extension differs from 'edf', a warning  
%                   is issued, but the function will attempt to open the  
%                   file. If no extension is specified, the function will 
%                   append '.edf' to the specified file name.
%       Option   -  optional argument that specifies what data is returned
%                   by the function.  Option = 'HEADER' returns only the
%                   fixed and variable headers (useful for a quick check).
%                   If option is a an integer between 1 and N (where N is
%                   the total number of signals in the file), the function
%                   returns only the specified channel.  If this argument
%                   is missing or contains unrecognized values, all signals
%                   are returned by the function in its Sout argument.
% ------------------------------------------------------------------------- 
% OUTPUT ARGUMENTS:                                                        
% -------------------------------------------------------------------------
%       Sout    -   an 1 x N structure, where each of the N elements has a 
%                   single field named 'Signal'. If a specific channel has 
%                   been requested (by assigning the Option an integer), 
%                   then Sout is a simple array of type double.
%       FHeader -   a structure conveying the information from the file's 
%                   fixed header . It has these fields:                                               
%                   'Version' - version of the EDF file (out of the
%                   official versions recognized by the format designers)
%                   'LocalPatientID','LocalRecordID' - strings, self-explanatory.
%                   'StartDate'  - a string, containing the date of the 
%                   data acquisition, as DD.MM.YY
%                   'StartTime'  - a string, containing the time of the 
%                   start of the acquisition, as HH.MM.SS  
%                   'NoBytes' -  an integer that specifies the number of 
%                    bytes in each record (see EDF specs for clarification).                                         
%                   'Reserved By' - string, self-explanatory.
%                   'NoRecords' - number of records in the file
%                   'DurationRecords' - time period covered with one record
%                    (in seconds)
%                   'NoSignals' - number of signals/channels in the file.   
%       VHeader -   a structure conveying the information from the file's 
%                   variable header . It has these fields (each as an N x 1
%                   array, where N is the number of signals in the file):                                               
%                   'Names' - names of the signals/channels
%                   'Transducers' - sensors/transducers used to acquire the
%                    signals
%                   'Units' - units (e.g. uV, bpm) for each of the signals
%                   'PhysMin' - the lowest possible value of the signal
%                   'PhysMax' - the largest possible value of the signal
%                   'DigMin' - digital value that corresponds to the lowest 
%                    possible value of the signal
%                   'DigMax' - digital value that corresponds to the largest 
%                    possible value of the signal
%                   'Filters' - information about filtering that was applied
%                    to the signals prior to their storage
%                   'NSamp' -   sampling rates for each of the signals
%       Outcome -   a structure denoting whether the file has been read   
%                   successfully. The structure has two fields:           
%                  'Success' - a flag. It is set to 1 if the file was     
%                   read successfully, and to 0 otherwise.
%                  'Message' - a warning (if Success=1) or error message  
%                   (if Success=0).                                       
%    
% ************************************************************************* 
% EXAMPLES:
%
% [S,FHEADER,VHEADER,OUTCOME]=read_edf_file('C:\Test Folder','Test File.edf')
%       -   opens the file named Test File located in the folder named Test 
%       Folder, and returns all signals contained in it
%
% [S,FHEADER,VHEADER,OUTCOME]=read_edf_file('C:\Test Folder','Test File','header');   
%       -   opens the file named Test File located in the folder named Test 
%       Folder, and reads and returns only its fixed and variable headers.
%
% [S,FHEADER,VHEADER,OUTCOME]=read_edf_file('C:\Test Folder','Test File',4);  
%       -   opens the file named Test File located in the folder named Test 
%       Folder, and returns only the forth signal in it (plus the headers).
%
% *************************************************************************
% MORE INFORMATION: http://www.edfplus.info/
%
% *************************************************************************

%**************************************************************************
%*          Opening the file                                              *
%**************************************************************************
% Error messages
M0=['Error while reading file ' FileName ': '];
M1=['Not enough input arguments when calling "read_edf_file"!'...
   'Both path and filename should be specified.'];
% Warning messages
Mw1='The extension of the specified file is not typical for EDF files.';
% Expected extensions (currently, only one - EBS)
cExtensions={'edf'};
error_flag = 0;
FHeader=struct('Version','','LocalPatientID','','LocalRecordID','',...
    'StartDate','','StartTime','','NoBytes',0,...
    'ReservedBy','','NoRecords',0,'DurationRecords',0,...
    'NoSignals',0);

Outcome=struct('Success',1,'Message','');

% Do the mandatory arguments (path and filename) exist?
% -----------------------------------------------------------------
if nargin<2                     % NO - return with an error msg
   Outcome.Message=[M0 M1];
   error_flag=1;
   
% If they exist:
% -----------------------------------------------------------------
else 
    
    % 1) Make sure the ultimate filename includes an extension
    % ---------------------------------------------------------
    k=strfind(FileName,'.');    % Find all dots in the filename
    
    % If there is at least one dot ...
    if ~isempty(k)
        % Extension = everything past the last dot in the file name
        Ext=FileName(k(length(k))+1:length(FileName));
        
        % Assume that it is not among the expected extensions
        Outcome.Message=Mw1;             % Warning 
        
        % Cycle through the expected extensions ...
        for i=1:length(cExtensions)
            % ... and if Ext is among them, cancel the warning message
            if length(Ext)==length(cExtensions{i}) && ... 
                    prod(double(lower(Ext)==cExtensions{i}))
                Outcome.Message='';
            end;
        end;
        
    % ... otherwise (no dots), append the default extension (EBS).
    else
        FileName=[FileName '.' cExtensions{1}];
    end;
    % ----------------------------------------------------------
end

if ~error_flag
% open a read-only file with a floating-point data format with bigendian 
% byte ordering
%--------------------------------------------------------------------------
    try
        fid = fopen([FilePath filesep FileName],'r','b');
    
        % ... if failed with returned fid, abort.
        if fid<0
            error_flag=1;
            Outcome.Message=[M0 Message];
        end
    catch ME
        % ... if failed without returned fid, abort.
        % -----------------------------------------------------------------
        Outcome.Message=[M0 ME.message];
        error_flag=1;
    end
end

if ~error_flag
% determine the file's length
%-------------------------------------------------------------------------
fseek(fid,0,1);				        % Go to end of file
TotalBytes = ftell(fid);	        % Read position
fseek(fid,0,-1);				    % Go to beginning of file
%--------------------------------------------------------------------------

%**************************************************************************
%*          Reading fixed header                                          *
%**************************************************************************
FHeader.Version = char(fread(fid,8,'char')');                    % Version Code
FHeader.LocalPatientID = char(fread(fid,80,'char')');            % Patient ID
FHeader.LocalRecordID = char(fread(fid,80,'char')');             % Data Encoding ID
FHeader.StartDate = char(fread(fid,8,'char')');                  % Start Date
FHeader.StartTime = char(fread(fid,8,'char')');                  % Start Time
FHeader.NoBytes = str2num(char(fread(fid,8,'char')'));           % No of bytes per record
FHeader.ReservedBy = fread(fid,44,'char')';                      % Any other information
FHeader.NoRecords = str2num(char(fread(fid,8,'char')'));         % No of Records
FHeader.DurationRecords = str2num(char(fread(fid,8,'char')'));   % Time period covered with a record
if isempty(FHeader.DurationRecords)
    FHeader.DurationRecords=1;
end;
FHeader.NoSignals = str2num(char(fread(fid,4,'char')'));         % No of recorded signals


%**************************************************************************
%*          Reading variable header                                       *
%**************************************************************************

    % reading channels' names
Temp=fread(fid,FHeader.NoSignals*16,'char');
VHeader.Names=cellstr(char(reshape(Temp,16,FHeader.NoSignals)'));

    % reading transducers' types
Temp=fread(fid,FHeader.NoSignals*80,'char');
VHeader.Transducers=char(reshape(Temp,80,FHeader.NoSignals)');

    % reading units
Temp=fread(fid,FHeader.NoSignals*8,'char');
VHeader.Units=cellstr(char(reshape(Temp,8,FHeader.NoSignals)'));

    % Physical minima and maxima
Temp=fread(fid,FHeader.NoSignals*8,'char');
VHeader.PhysMin=str2num(char(reshape(Temp,8,FHeader.NoSignals)'));
if isempty(VHeader.PhysMin)
  %  VHeader.PhysMin=zeros(FHeader.NoSignals,1);
  %  for i=1:FHeader.NoSignals
  %      VHeader.PhysMin(i,1)=str2num(char(Temp((i-1)*8+1:i*8))');
  %  end;
end;
Temp=fread(fid,FHeader.NoSignals*8,'char');
VHeader.PhysMax=str2num(char(reshape(Temp,8,FHeader.NoSignals)'));
if isempty(VHeader.PhysMax)
   % VHeader.PhysMax=zeros(FHeader.NoSignals,1);
   % for i=1:FHeader.NoSignals
   %     VHeader.PhysMax(i,1)=str2num(char(Temp((i-1)*8+1:i*8))');
   % end;
end;

    % Digital minima and maxima for each channel
Temp=fread(fid,FHeader.NoSignals*8,'char');
VHeader.DigMin=str2num(char(reshape(Temp,8,FHeader.NoSignals)'));
if isempty(VHeader.DigMin)
   % VHeader.DigMin=zeros(FHeader.NoSignals,1);
   % for i=1:FHeader.NoSignals
   %     VHeader.DigMin(i,1)=str2num(char(Temp((i-1)*8+1:i*8))');
   % end;
end;
Temp=fread(fid,FHeader.NoSignals*8,'char');
VHeader.DigMax=str2num(char(reshape(Temp,8,FHeader.NoSignals)'));
if isempty(VHeader.DigMax)
  %  VHeader.DigMax=zeros(FHeader.NoSignals,1);
  %  for i=1:FHeader.NoSignals
  %      VHeader.DigMax(i,1)=str2num(char(Temp((i-1)*8+1:i*8))');
  %  end;
end;

    % Information about analog filtering for each channel, if applicable
Temp=fread(fid,FHeader.NoSignals*80,'char');
VHeader.Filters=cellstr(char(reshape(Temp,80,FHeader.NoSignals)'));

    % Number of samples per one record per channel
Temp=fread(fid,FHeader.NoSignals*8,'char');
VHeader.NSamp=str2num(char(reshape(Temp,8,FHeader.NoSignals)'));
if isempty(VHeader.NSamp)
    VHeader.NSamp=zeros(FHeader.NoSignals,1);
    for i=1:FHeader.NoSignals
        VHeader.NSamp(i,1)=str2num(char(Temp((i-1)*8+1:i*8))');
    end;
end;

    % RESERVED 32 BYTES PER CHANNEL
Temp=fread(fid,FHeader.NoSignals*32,'char');


%**************************************************************************
%*                      READING THE DATA                                  *                  
%**************************************************************************

if (nargin==2)||~strcmpi(Option,'header')
FHeader.NoRecords = floor((TotalBytes - ftell(fid))/(2*sum(VHeader.NSamp)));

% initialization of the output variable
%--------------------------------------------------------------------------
    for i=1:FHeader.NoSignals
       S(i).Signal=zeros(1,FHeader.NoRecords*FHeader.DurationRecords*VHeader.NSamp(i,1));
    end;
%--------------------------------------------------------------------------

% reading the recorded signals
%--------------------------------------------------------------------------
    for i=1:FHeader.NoRecords-1
        Temp=fread(fid,2*FHeader.DurationRecords*sum(VHeader.NSamp),'uint8')';
        Record=Temp(1:2:length(Temp))+256*Temp(2:2:length(Temp));
        for j=1:FHeader.NoSignals
            if strcmp(VHeader.Names{j},'ESU Time Stamp')
                a=1;
            end
            S(j).Signal((i-1)*FHeader.DurationRecords*VHeader.NSamp(j,1)+1:i*FHeader.DurationRecords*VHeader.NSamp(j,1))=Record(sum(VHeader.NSamp)-sum(VHeader.NSamp(j:FHeader.NoSignals,1))+1:sum(VHeader.NSamp)-sum(VHeader.NSamp(j:FHeader.NoSignals,1))+VHeader.NSamp(j,1));
        end;
    end;
    %---------------------------------------------------------------------------
    for i=1:FHeader.NoSignals
        S(i).Signal=(S(i).Signal<32768).*S(i).Signal+(S(i).Signal>=32768).*(S(i).Signal-65535);
        if strcmp(VHeader.Names(i), 'ESU Time Stamp')
            bottom = S(i).Signal(1:2:end);
            bottom(bottom<0) = bottom(bottom<0)+2^16;

            top = S(i).Signal(2:2:end);
            S(i).Signal = bottom+top*2^16;

            VHeader.NSamp(i) = VHeader.NSamp(i)/2;
        end
    end;

end;

% close the file
%---------------------------------------------------------------------------
fclose(fid);


%**************************************************************************
%*                 CREATING OUTPUT                                        *
%**************************************************************************

if nargin == 2
    Sout=S;
elseif (isnumeric(Option) && Option~=0)
    Sout=S(Option).Signal;
else
    Sout=0;
end;

out.Sout = Sout;
out.FHeader = FHeader;
out.VHeader = VHeader;
out.Outcome = Outcome;

end
