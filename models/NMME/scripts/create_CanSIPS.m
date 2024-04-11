clear
close all

%% 1. read in data
CanCM4_file = '../data/netcdf4/CanCM4i.prate.202303.ENSMEAN.anom.nc';
GEM5_file = '../data/netcdf4/GEM5_NEMO.prate.202303.ENSMEAN.anom.nc';

ncdisp(CanCM4_file);
% ncdisp(GEM5_file);

[month, year] = extractDate(CanCM4_file);
month_str = convertMonthStr(month);

month1 = 4;
month2 = 5;
month3 = 6;

month1_str = convertMonthStr(month + month1-1);
month3_str = convertMonthStr(month + month3-1);

% get lon and lat values
lon = ncread(CanCM4_file,'lon');
lat = ncread(CanCM4_file,'lat');

% extract fcst 3D data
CANCM4_fcst = ncread(CanCM4_file,'fcst');
GEM5_fcst = ncread(GEM5_file,'fcst');

% squeeze out first month 2D data
CANCM4_fcst_month1 = squeeze(CANCM4_fcst(:,:,month1));
GEM5_fcst_month1 = squeeze(GEM5_fcst(:,:,month1));

CANCM4_fcst_month2 = squeeze(CANCM4_fcst(:,:,month2));
GEM5_fcst_month2 = squeeze(GEM5_fcst(:,:,month2));

CANCM4_fcst_month3 = squeeze(CANCM4_fcst(:,:,month3));
GEM5_fcst_month3 = squeeze(GEM5_fcst(:,:,month3));

%% 2. calculations
average_month1 = (CANCM4_fcst_month1 + GEM5_fcst_month1) / 2;
average_month2 = (CANCM4_fcst_month2 + GEM5_fcst_month2) / 2;
average_month3 = (CANCM4_fcst_month3 + GEM5_fcst_month3) / 2;

seasonal_forecast = (average_month1 + average_month2 + average_month3) / 3;

cm1 = othercolor('BrBG5',30);
CI = -6:.5:6;

%% 3. create projection and plot data

% create figure and set position
f = figure('Units','normalized','Position',[.1,.1,.8,.8]);
hold on;

% create map projection and set lat/lon boundary region
m_proj('miller','lon',[230 360],'lat',[0 60]);
% m_proj('miller','lon',[0 360],'lat',[-60 60]);

% plot data shading
m_contourf(lon,lat,seasonal_forecast'*1e5,CI,'linestyle','none')
set(gca,'colormap',cm1)
set(gca,'clim',[-2 2]);

% plot US continent, coastlines, and state boundaries
m_coast('line','color','k');

% label latitude and longitude on the map
m_grid('tickdir','out','ticklength',.005,'linewi',1,'fontsize',10,...
    'xtick',0:20:360,'ytick',-90:10:90)

cb = colorbar();
ylabel(cb, 'Precipitation Rates','FontSize',12,'Rotation',270);

% Define title
titleString = sprintf(['Surface Precipitation Rate for CanSIPS' ...
    '\n \\fontsize{16}%s - %s %s'],month1_str,month3_str,num2str(year));

% Create and format the title
ttl = title(titleString, 'fontsize', 20);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

exportgraphics(f,sprintf('../images/CanSIPS%s%s_%s-%s.jpg',month_str,num2str(year),month1_str,month3_str))