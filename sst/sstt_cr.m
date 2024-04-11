clear
close all

%% 1. import data from ERA5 files and set variables
filename = 'data/ct5km_sst-trend-7d_v3.1_20240328.nc';
county_borders = m_shaperead('../borders/ne_10m_admin_2_counties');
country_borders = m_shaperead('../borders/ne_10m_admin_0_countries');
state_borders = m_shaperead('../borders/ne_110m_admin_1_states_provinces');

ncdisp(filename);

% read in latitude and longitude (resolution is 2.5)
lat = ncread(filename,'lat');
lon = ncread(filename,'lon');
sst = ncread(filename,'trend');

% ensure longitude is sorted in ascending order and wrap data
xlon = wrapTo180(lon); % wrap data to [-180,180]

% sort wrapped data in ascending order/store with indices
[xlonSorted, xlonOrder] = sort(xlon(:));
xsst = sst(xlonOrder,:); % sort plot data

%% 2. create figure and plot data on map
% create figure and set position
f = figure('Units','inches','Position',[.5,.5,15,10]);
hold on

% create custom color map
customsstt = customcolormap([0, .16, .24, .32, .4, .48, .56, .64, .72, .8, .88, 1],...
    {'#640064','#6400fa','#0050ff','#0078ff','#00ffff','#0ba062','#ffff00','#ffbe00','#ff5000','#dc0000','#960000','#640000'});

% select colormap and color scheme from the toolbox
colormap(flip(customsstt));
% colormap(flip(othercolor('RdBu10')));

% create map projection and set lat/lon boundary region
m_proj('miller','lon',[-180 180],'lat',[-60 60]); % Adjusted for Africa

% create shading and contour plots from data
CI = -10:.5:10;
m_contourf(xlonSorted,lat,xsst',CI,'linestyle','none');

set(gca,'fontsize',20,'clim',[-5 5])
plot_borders('country', country_borders, 'state', state_borders);

% create colorbar with variable name and units
cb = colorbar('FontSize',12);
ylabel(cb,'SSTT (°C)','FontSize',20,'Rotation',270);

% label latitude and longitudes on map
m_grid('tickdir','in','linewi',2,'fontsize',14,...
    'xtick',-180:20:180,'ytick',-60:10:60); % Adjusted for Africa

% create title for plot
ttl = title({'Sea Surface Temperature Trend (data from NOAA Coral Reef)',...
    '{\fontsize{14} March 21 - 28, 2024}'},'fontsize',16);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

exportgraphics(f,'images/sstt_coralreef.jpg');