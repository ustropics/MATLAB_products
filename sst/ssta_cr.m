clear
close all

%% 1. import data from ERA5 files and set variables
filename = 'data/ct5km_ssta_v3.1_20240328.nc';
county_borders = m_shaperead('../borders/ne_10m_admin_2_counties');
country_borders = m_shaperead('../borders/ne_10m_admin_0_countries');
state_borders = m_shaperead('../borders/ne_110m_admin_1_states_provinces');
ncdisp(filename);

% read in latitude and longitude (resolution is 2.5)
lat = ncread(filename,'lat');
lon = ncread(filename,'lon');
sst = ncread(filename,'sea_surface_temperature_anomaly');
time = ncread(filename,'time');

% ensure longitude is sorted in ascending order and wrap data
xlon = wrapTo180(lon); % wrap data to [-180,180]

% sort wrapped data in ascending order/store with indices
[xlonSorted, xlonOrder] = sort(xlon(:));
xsst = sst(xlonOrder,:); % sort plot data

%% 2. create figure and plot data on map
% create figure and set position
f = figure('Units','inches','Position',[.5,.5,15,10]);
hold on

% select colormap and color scheme from the toolbox
colormap(othercolor('BuDRd_18',40));

% create map projection and set lat/lon boundary region
m_proj('robinson','lon',[-180 180],'lat',[-60 60]); % Adjusted for Africa

% create shading and contour plots from data
CI = -5:1:5;
m_contourf(xlonSorted,lat,xsst',CI,'linestyle','none');

set(gca,'fontsize',20,'clim',[-4 4])
plot_borders('country', country_borders, 'state', state_borders);

% create colorbar with variable name and units
cb = colorbar('FontSize',12);
ylabel(cb,'SSTA (°C)','FontSize',20,'Rotation',270);

% label latitude and longitudes on map
m_grid('tickdir','in','linewi',2,'fontsize',14,...
    'xtick',-180:20:180,'ytick',-60:10:60); % Adjusted for Africa

% create title for plot
ttl = title({'Sea Surface Temperature Anomalies (data from NOAA Coral Reef)',...
    '{\fontsize{14}5km data from March 28th, 2024}'},'fontsize',16);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

exportgraphics(f,'images/ssta_coralreef.jpg')