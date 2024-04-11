clear
close all

%% 1. read in data from netcdf file

filename = 'data/IBTrACS.NA.v04r00.nc';
ncdisp(filename);

% read in data from netcdf
year = ncread(filename,'season');
cyclone_number = ncread(filename,'number');
cyclone_name = ncread(filename,'name');
longitude = ncread(filename,'lon');
latitude = ncread(filename,'lat');

% swap dimensions and convert to string
cyclone_name = cellstr(cyclone_name');


% combine year and cyclone into one file
cyclones = [num2cell(year), num2cell(cyclone_number)];
cyclone_names = [num2cell(year), num2cell(cyclone_number), strtrim(cyclone_name)];


% %% 2. create figure and plot data on map
% % create figure and set position
% figure('Units','inches','Position',[.5,.5,15,10]);
% hold on
% 
% m_proj('miller','lon',[-180 180],'lat',[-60 60]); % Adjusted for Africa
% 
% set(gca,'fontsize',20,'clim',[-4 4])
% m_coast('color','k','linewidth',1.5);
% 
% % label latitude and longitudes on map
% m_grid('tickdir','in','linewi',2,'fontsize',14,...
%     'xtick',-180:20:180,'ytick',-60:10:60); % Adjusted for Africa
% 
% waypoints = [12.5,92.5;  12.6 91.8; 13,90.7; 13.4,89.6; 13.6,89.2; 13.7,88.7; 14,88.2; 14.2,87.8; 14.4,87.6; 14.8,87.1; 15.4,86.9; 15.9,86.5; 16,85.8; 16,85.2; 16.3,84.8; 16.6,84.6; 17.2,84.2; 17.5,83.5; 18,82.9];
% 
% [lttrk,lntrk] = track('rh',waypoints,'degrees');
% 
% geoshow(lttrk,lntrk,'DisplayType','line','color','r')
% xlabel('Longitude');ylabel('Latitude');title('Hudhud Cyclone 2014');