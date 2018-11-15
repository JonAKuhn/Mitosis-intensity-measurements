clear

filename=input('What is the Movie analyzed? ','s');
filename=[filename '.mat'];
cd 'C:\Users\kuhnj\Documents\Stuff For Backup\Matlab\Hec1-9D analysis\Movies'
openSTKorTIFandGetTimeTubTrackSIR
cd 'C:\Users\kuhnj\Documents\Stuff For Backup\Matlab\Hec1-9D analysis\Tracks'
Tracksname=uigetfile;
Tracks=xlsread(Tracksname);
%Tracks(1,:)=[];
bounds=[min(Tracks(:,4)) max(Tracks(:,4))]; 
PoleData=NEBDPoledistSIR(imframes,bounds);

[BGData]=NEBDBGSIR(imframes,bounds,1);

Tracks=formatoldtracks(Tracks);

clearvars -except PoleData filename MadMax TubMax BGData Tracks
cd 'C:\Users\kuhnj\Documents\Stuff For Backup\Matlab\Hec1-9D analysis\Tracking Workspaces'


save(filename);