datapath = '../../../Data/Bebop2 step response velocity/With time (200 Hz)/Front-Back-nooptitrack';
datatype = '.txt';
delimiter = ',';
data = extractDelimitedFile(datapath,datatype,delimiter);
header = data.Properties.VariableNames;


figure;
hold on;
plot(data{:,'time'});