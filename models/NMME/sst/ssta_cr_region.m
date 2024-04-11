clear
close all

%% 1. import data from ERA5 files and set variables
filename = 'data/ct5km_ssta_v3.1_20240409.nc';
county_borders = m_shaperead('../borders/ne_10m_admin_2_counties');
country_borders = m_shaperead('../borders/ne_10m_admin_0_countries');
state_borders = m_shaperead('../borders/ne_110m_admin_1_states_provinces');
ncdisp(filename);

% read in latitude and longitude (resolution is 2.5)
lat = ncread(filename,'lat');
lon = ncread(filename,'lon');
sst = ncread(filename,'sea_surface_temperature_anomaly');
time = ncread(filename,'time');

% calculate date from initial time
reference_date = datetime(1981,1,1,00,0,0, ...
    'Format','yyyy-MM-dd HH:mm:ss','TimeZone','UTC');

init_date = reference_date + seconds(time);

init_month = datestr(datenum(0, month(init_date), 1), 'mmmm');
init_day = day(init_date);
init_year = year(init_date);

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
% m_proj('robinson','lon',[-180 180],'lat',[-60 60]); % Adjusted for Africa
m_proj('miller','lon',[-100 0],'lat',[0 60]); % Adjusted for Africa
hexColor = '#aaaaaa'; % Your hexadecimal color code
rgbColor = sscanf(hexColor(2:end),'%2x%2x%2x',[1 3])/255;
m_coast('patch', rgbColor, 'edgecolor', 'k');

% create shading and contour plots from data
CI = -10:.5:10;
m_contourf(xlonSorted,lat,xsst',CI,'linestyle','none');

set(gca,'fontsize',20,'clim',[-4 4])
plot_borders('country', country_borders, 'state', state_borders);

% create colorbar with variable name and units
cb = colorbar('FontSize',12);
ylabel(cb,'SSTA (°C)','FontSize',20,'Rotation',270);

% label latitude and longitudes on map
m_grid('tickdir','in','linewi',2,'fontsize',14,...
    'xtick',-180:20:180,'ytick',-60:10:60); % Adjusted for Africa

% Set the title
% create subtitle for plot
date_subtitle = sprintf('{\\fontsize{14}5km data from %s %d, %d}', init_month, init_day, init_year);
ttl = title({'Sea Surface Temperature Anomalies (data from NOAA Coral Reef)', date_subtitle},'fontsize',16);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

% Create the dynamic date string
base_filename = 'ssta_coralreef';
date_string = sprintf('%02d%02d%d', month(init_date), init_day,init_year);
full_filename = sprintf('images/%s_%s.jpg', base_filename, date_string);
exportgraphics(f, full_filename);