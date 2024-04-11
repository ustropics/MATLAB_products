clear
close all

%% 1. Read in data
filename = '../data/prate_2006_JJA.nc';
borders = m_shaperead('../../Borders/ne_110m_admin_1_states_provinces');
borders2 = m_shaperead('../../Borders/ne_10m_admin_0_countries');
ncdisp(filename);

% Get information about the NetCDF file
info = ncinfo(filename);

% read in data for (lat, lon, prate)
lat = ncread(filename, 'lat');
lon = ncread(filename, 'lon');
prate = ncread(filename, 'prate');

% ensure longitude is sorted in ascending order and wrap data
xlon = wrapTo180(lon); % wrap data to [-180,180]

% sort wrapped data in ascending order/store with indices
[xlonSorted, xlonOrder] = sort(xlon(:));
xprate = prate(xlonOrder,:); % sort plot data

%% 3. Extract values from global attributes 
% Attribute name
attributeName = 'history';

% Extracting attribute value
historyValue = ncreadatt(filename, '/', attributeName);

month = extractMonthFromHistory(historyValue);
% disp(['Month: ', month]);

years = extractYearsFromHistory(historyValue);
year = strjoin(years, ', ');
% disp(['Years: ', strjoin(years, ', ')]);

%% 4. create figure and plot data on map
% create figure and set position
f= figure('Units','inches','Position',[.5, .5, 15, 10]);
hold on

% select colormap and color scheme from the toolbox
colormap(othercolor('BrBG5', 30))

% create map projection and set lat/lon boundary region
% m_proj('miller','lon',[-180 180],'lat',[-60 60]); % global map projection
m_proj('miller','lon',[-130 0],'lat',[-10 60]); % North Atlantic map projection

% create shading and contour plots from data
CI = -7:.02:7;
m_contourf(xlonSorted,lat,xprate',CI,'linestyle','none');
set(gca,'fontsize',20,'clim',[-2 2])

% m_coast('patch',[.9 .9 .9],'edgecolor','k');
m_coast('line','color','k');

%% 5. set colorbar, title, and grid labels
cb = colorbar();
ylabel(cb, 'Precipitation Rates (inches)','FontSize',12,'Rotation',270);
cb.FontSize = 10;

% label latitude and longitudes on map
m_grid('tickdir','out','ticklength',.005,'linewi',1,'fontsize',10,...
    'xtick',-160:20:160,'ytick',-60:10:60);

% plot state borders
for k=1: length(borders.ncst)
    m_plot(borders.ncst{k}(:,1), borders.ncst{k}(:,2),'color','#3d3d5c','linewidth',1);
end

for k=1: length(borders2.ncst)
    m_plot(borders2.ncst{k}(:,1), borders2.ncst{k}(:,2),'color','#3d3d5c','linewidth',1);
end

% Define your title string with LaTeX formatting for the years
titleString = sprintf(['Surface Precipitation Rate Anomalies (1991 - 2020 climo)' ...
    '\n{\\fontsize{14}%s to %s %s}'], month{1}, month{2}, year);

% Create and format the title
ttl = title(titleString, 'fontsize', 18);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

exportgraphics(f,sprintf('../../images/prate_%s%s_%s%s.jpg', month{1},year,month{2},year))