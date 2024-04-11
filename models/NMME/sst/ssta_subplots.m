clear
close all

filename_2011 = 'data/yycompos.fi2OM6FOoI.nc';
filename_2010 = 'data/yycompos.xhEMa_SMRE.nc';
filename_2005 = 'data/yycompos.y5J3v8qoI5.nc';
filename_2000 = 'data/yycompos.kpttPEelBv.nc';

% read in data for (lat, lon, sst)
lat = ncread(filename_2010, 'lat');
lon = ncread(filename_2010, 'lon');

% ensure longitude is sorted in ascending order and wrap data
xlon = wrapTo180(lon); % wrap data to [-180,180]

sst_2011 = ncread(filename_2011, 'sst');
sst_2010 = ncread(filename_2010, 'sst');
sst_2005 = ncread(filename_2005, 'sst');
sst_2000 = ncread(filename_2000, 'sst');

%% 2. create figure
% create figure and set position
f= figure('Units','inches','Position',[.5, .5, 15, 10]);
tiledlayout(2,2,'TileSpacing','compact','Padding','compact')
hold on 

%% 3. create subplot 1
nexttile
hold on

% select colormap and color scheme from the toolbox
colormap(othercolor('BuDRd_12', 200))

% create map projection and set lat/lon boundary region
m_proj('miller','lon',[-140 -10],'lat',[0 50]);

% create shading and contour plots from data
CI = -4:.1:4;
m_contourf(xlon,lat,sst_2011',CI,'linestyle','none');

set(gca,'fontsize',10,'clim',[-2 2])
m_coast('patch',[.9 .9 .9],'edgecolor','k');

cb = colorbar();
ylabel(cb, 'SSTA (^oC)','FontSize',10,'Rotation',270);

% label latitude and longitudes on map
m_grid('tickdir','out','linewi',2,'fontsize',10,...
    'xtick',-160:20:160,'ytick',-60:10:60);

titleString = sprintf('2011 Jan - March SSTA from NOAA OI SST (1991 - 2020 climo)');

% Create and format the title
ttl = title(titleString, 'fontsize', 12);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

%% 4. create subplot 2
nexttile
hold on

% select colormap and color scheme from the toolbox
colormap(othercolor('BuDRd_12', 200))

% create map projection and set lat/lon boundary region
m_proj('miller','lon',[-140 -10],'lat',[0 50]);

% create shading and contour plots from data
CI = -4:.1:4;
m_contourf(xlon,lat,sst_2010',CI,'linestyle','none');

set(gca,'fontsize',10,'clim',[-2 2])
m_coast('patch',[.9 .9 .9],'edgecolor','k');

cb = colorbar();
ylabel(cb, 'SSTA (^oC)','FontSize',10,'Rotation',270);

% label latitude and longitudes on map
m_grid('tickdir','out','linewi',2,'fontsize',10,...
    'xtick',-160:20:160,'ytick',-60:10:60);

titleString = sprintf('2010 Jan - March SSTA from NOAA OI SST (1991 - 2020 climo)');

% Create and format the title
ttl = title(titleString, 'fontsize', 12);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';


%% create subplot 3
nexttile
hold on

% select colormap and color scheme from the toolbox
colormap(othercolor('BuDRd_12', 200))

% create map projection and set lat/lon boundary region
m_proj('miller','lon',[-140 -10],'lat',[0 50]);

% create shading and contour plots from data
CI = -4:.1:4;
m_contourf(xlon,lat,sst_2005',CI,'linestyle','none');

set(gca,'fontsize',10,'clim',[-2 2])
m_coast('patch',[.9 .9 .9],'edgecolor','k');

%% 5. set colorbar, title, and grid labels
cb = colorbar();
ylabel(cb, 'SSTA (^oC)','FontSize',10,'Rotation',270);

% label latitude and longitudes on map
m_grid('tickdir','out','linewi',2,'fontsize',10,...
    'xtick',-160:20:160,'ytick',-60:10:60);

titleString = sprintf('2005 Jan - March SSTA from NOAA OI SST (1991 - 2020 climo)');

% Create and format the title
ttl = title(titleString, 'fontsize', 12);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

exportgraphics(f,'images/SSTA_GOM.png')

%% create subplot 4
nexttile
hold on

% select colormap and color scheme from the toolbox
colormap(othercolor('BuDRd_12', 200))

% create map projection and set lat/lon boundary region
m_proj('miller','lon',[-140 -10],'lat',[0 50]);

% create shading and contour plots from data
CI = -4:.1:4;
m_contourf(xlon,lat,sst_2000',CI,'linestyle','none');

set(gca,'fontsize',10,'clim',[-2 2])
m_coast('patch',[.9 .9 .9],'edgecolor','k');

%% 5. set colorbar, title, and grid labels
cb = colorbar();
ylabel(cb, 'SSTA (^oC)','FontSize',10,'Rotation',270);

% label latitude and longitudes on map
m_grid('tickdir','out','linewi',2,'fontsize',10,...
    'xtick',-160:20:160,'ytick',-60:10:60);

titleString = sprintf('2000 Jan - March SSTA from NOAA OI SST (1991 - 2020 climo)');

% Create and format the title
ttl = title(titleString, 'fontsize', 12);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

exportgraphics(f,'images/SSTA_GOM.png')