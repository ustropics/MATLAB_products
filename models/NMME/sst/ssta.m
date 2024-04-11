clear
close all

%% 1. import data from ERA5 files and set variables
filename = 'netcdf/yycompos.4manzoXqbM.nc';
ncdisp(filename);

% read in latitude and longitude (resolution is 2.5)
lat = ncread(filename,'lat');
lon = ncread(filename,'lon');
sst = ncread(filename,'sst');

% ensure longitude is sorted in ascending order and wrap data
xlon = wrapTo180(lon); % wrap data to [-180,180]

% sort wrapped data in ascending order/store with indices
[xlonSorted, xlonOrder] = sort(xlon(:));
xsst = sst(xlonOrder,:); % sort plot data

%% 2. create figure and plot data on map
% create figure and set position
figure('Units','inches','Position',[.5,.5,15,10]);
hold on

% select colormap and color scheme from the toolbox
colormap(othercolor('BuDRd_18',200));

% create map projection and set lat/lon boundary region
m_proj('miller','lon',[-180 180],'lat',[-60 60]); % Adjusted for Africa

% create shading and contour plots from data
CI = -1:.2:1;
m_contourf(xlonSorted,lat,xsst',CI,'linestyle','none');

set(gca,'fontsize',20,'clim',[-1 1])
m_coast('color','k','linewidth',1.5);

% create colorbar with variable name and units
cb = colorbar('FontSize',12);
ylabel(cb,'SSTA (°C)','FontSize',20,'Rotation',270);

% label latitude and longitudes on map
m_grid('tickdir','out','linewi',2,'fontsize',14,...
    'xtick',-180:20:180,'ytick',-60:10:60); % Adjusted for Africa

saveas(gca,'images/ssta_reanalysis.jpg');