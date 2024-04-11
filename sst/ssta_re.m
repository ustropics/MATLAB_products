clear
close all

%% 1. Read in data
filename = 'data/yycompos.hq2GweujzZ.nc';
ncdisp(filename);

% Get information about the NetCDF file
info = ncinfo(filename);

% read in data for (lat, lon, sst)
lat = ncread(filename, 'lat');
lon = ncread(filename, 'lon');
sst = ncread(filename, 'sst');

% ensure longitude is sorted in ascending order and wrap data
xlon = wrapTo180(lon); % wrap data to [-180,180]

% sort wrapped data in ascending order/store with indices
[xlonSorted, xlonOrder] = sort(xlon(:));
xsst = sst(xlonOrder,:); % sort plot data

%% 3. Extract values from global attributes 
% Attribute name
attributeName = 'history';

% Extracting attribute value
historyValue = ncreadatt(filename, '/', attributeName);

month = extractMonthFromHistory(historyValue);
% disp(['Month: ', month]);

years = extractYearsFromHistory(historyValue);
% disp(['Years: ', strjoin(years, ', ')]);

%% 4. create figure and plot data on map
% create figure and set position
f= figure('Units','inches','Position',[.5, .5, 15, 10]);
hold on

% select colormap and color scheme from the toolbox
colormap(othercolor('BuDRd_12', 200))

% create map projection and set lat/lon boundary region
m_proj('miller','lon',[-180 180],'lat',[-60 60]);

% create shading and contour plots from data
CI = -4:.1:4;
m_contourf(xlonSorted,lat,xsst',CI,'linestyle','none');

set(gca,'fontsize',20,'clim',[-2 2])
m_coast('patch',[.9 .9 .9],'edgecolor','k');


%% 5. set colorbar, title, and grid labels
cb = colorbar();
ylabel(cb, 'Sea Surface Temperature Anomaly (^oC)','FontSize',14,'Rotation',270);

% label latitude and longitudes on map
m_grid('tickdir','in','linewi',2,'fontsize',14,...
    'xtick',-160:20:160,'ytick',-60:10:60);

% Define your title string with LaTeX formatting for the years
titleString = sprintf('%s to March SSTA from NOAA OI SST (1991 - 2020 climo) for El Nino Years \n%s', month, ...
    ['{\fontsize{16}', strjoin(years, ', '), '}']);

% Create and format the title
ttl = title(titleString, 'fontsize', 20);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

exportgraphics(f,sprintf('images/SSTA_%s_el_nino_comp.jpg', month))