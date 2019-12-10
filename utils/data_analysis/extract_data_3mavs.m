% Data file names for exp with three drones
datafile18_44 = 'IP18_44_3.txt';
datafile44_18 = 'IP44_18_3.txt';
datafile22_44 = 'IP22_44_3.txt';
datafile44_22 = 'IP44_22_3.txt';

% Detail (estimate)
startt  = 100;
endt    = 300;
delay22 = 4; % Follower 1, with 4 second delay from leader
delay18 = 8; % Follower 2, with 8 second delay from leader

% Get data
datafile22_44 = fullfile(datapath,datafile22_44); % Follower 1 to leader
datafile44_22 = fullfile(datapath,datafile44_22); % Leader to follower 1
datafile18_44 = fullfile(datapath,datafile18_44); % Follower 2 to leader
datafile44_18 = fullfile(datapath,datafile44_18); % Leader to follower 2

data22    = extractDelimitedFile(datafile22_44); % Follower 1
data18    = extractDelimitedFile(datafile18_44); % Follower 2
data44_22 = extractDelimitedFile(datafile44_22); % Leader to follower 1
data44_18 = extractDelimitedFile(datafile44_18); % Leader to follower 2

% Synch data
[syncdata22, syncdata44_22,tm1,tm2] = syncData(data22, data44_22, 'Range', 'time');
[syncdata18, syncdata44_18,  ~,  ~] = syncData(data18, data44_18, 'Range', 'time');
t22 = syncdata22{:, 'time'};
t18 = syncdata18{:, 'time'};

% Cut pre and post flight data
[cutdata22,  cutdata44_22,  newt22,  newt44_22]  = cutOutData(syncdata22, syncdata44_22, startt, endt, startt, endt, 'time');
[cutdata22d, cutdata44_22d, newt22d, newt44_22d] = cutOutData(syncdata22, syncdata44_22, startt, endt, startt-delay22, endt-delay22, 'time');
[cutdata18,  cutdata44_18,  newt18,  newt44_18]  = cutOutData(syncdata18, syncdata44_18, startt, endt, startt, endt, 'time');
[cutdata18d, cutdata44_18d, newt18d, newt44_18d] = cutOutData(syncdata18, syncdata44_18, startt, endt, startt-delay18, endt-delay18, 'time');

header1 = data18.Properties.VariableNames;
header2 = data44_18.Properties.VariableNames;