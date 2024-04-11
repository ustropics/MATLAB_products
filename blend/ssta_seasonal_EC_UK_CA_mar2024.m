close all
clear

%% 1. read in data files for seasonal forecast
% CanSIPS data from https://www.cpc.ncep.noaa.gov/products/NMME/data.html
% ECMWF/UKMO data from Copernicus https://cds.climate.copernicus.eu/#!/home
CanCM4_file = '../../NMME/data/ssta/CanCM4i.tmpsfc.202403.ENSMEAN.anom.nc';
GEM5_file = '../../NMME/data/ssta/GEM5_NEMO.tmpsfc.202403.ENSMEAN.anom.nc';
ECMWF_file = '../../Copernicus/data/ssta/ecmwf_Mar2024_ssta.nc';
UKMO_file = '../../Copernicus/data/ssta/ukmo_Mar2024_ssta.nc';
borders = m_shaperead('../../Borders/ne_110m_admin_1_states_provinces');
borders2 = m_shaperead('../../Borders/ne_10m_admin_0_countries');

ncdisp(ECMWF_file)

%% 2. set month variables for seasonal forecast
month1 = 4;
month2 = 5;
month3 = 6;

% set map color and contour interval 
cm1 = othercolor('RdBu10',30);
% CI = -7:.02:7;

%% 3. extract necessary data and set to arrays
% grab the month, year, and year string from file
[month, year] = extractDate(CanCM4_file);
month_str = convertMonthStr(month);
month1_str = convertMonthStr(month + month1-1);
month3_str = convertMonthStr(month + month3-1);

% get lon and lat values
lon = ncread(ECMWF_file,'longitude');
lat = ncread(ECMWF_file,'latitude');

% extract fcst/ssta 3D data
CANCM4_fcst = ncread(CanCM4_file,'fcst');
GEM5_fcst = ncread(GEM5_file,'fcst');
ECMWF_fcst = ncread(ECMWF_file,'ssta');
UKMO_fcst = ncread(UKMO_file,'ssta');

% sqeeze out necessary lead months to create 2D data for seasonal fcst
CANCM4_fcst_month1 = squeeze(CANCM4_fcst(:,1:end-1,month1));
GEM5_fcst_month1 = squeeze(GEM5_fcst(:,1:end-1,month1));
ECMWF_fcst_month1 = squeeze(ECMWF_fcst(:,:,month1));
UKMO_fcst_month1 = squeeze(UKMO_fcst(:,:,month1));

CANCM4_fcst_month2 = squeeze(CANCM4_fcst(:,1:end-1,month2));
GEM5_fcst_month2 = squeeze(GEM5_fcst(:,1:end-1,month2));
ECMWF_fcst_month2 = squeeze(ECMWF_fcst(:,:,month2));
UKMO_fcst_month2 = squeeze(UKMO_fcst(:,:,month2));

CANCM4_fcst_month3 = squeeze(CANCM4_fcst(:,1:end-1,month3));
GEM5_fcst_month3 = squeeze(GEM5_fcst(:,1:end-1,month3));
ECMWF_fcst_month3 = squeeze(ECMWF_fcst(:,:,month3));
UKMO_fcst_month3 = squeeze(UKMO_fcst(:,:,month3));

%% 4. perform calculations
% create CanSIPS monthly forecast
CanSIPS_average_month1 = (CANCM4_fcst_month1 + GEM5_fcst_month1) / 2;
CanSIPS_average_month2 = (CANCM4_fcst_month2 + GEM5_fcst_month2) / 2;
CanSIPS_average_month3 = (CANCM4_fcst_month3 + GEM5_fcst_month3) / 2;

% create CanSIPS seasonal forecast
CanSIPS_seasonal_fcst = (CanSIPS_average_month1 + CanSIPS_average_month2 + CanSIPS_average_month3) / 3;
CanSIPS_seasonal_fcst(CanSIPS_seasonal_fcst > 10) = NaN;

% create ECMWF seasonal forecast
ECMWF_seasonal_fcst = (ECMWF_fcst_month1 + ECMWF_fcst_month2 + ECMWF_fcst_month3) / 3;

% create UKMO seasonal forecast
UKMO_seasonal_fcst = (UKMO_fcst_month1 + UKMO_fcst_month2 + UKMO_fcst_month3) / 3;

% create final model blend forecast
model_blend_fcst = (CanSIPS_seasonal_fcst + ECMWF_seasonal_fcst + UKMO_seasonal_fcst) / 3;
% model_blend_fcst = imgaussfilt(model_blend_fcst,2);

%% 5. create projection and plot data
% create figure and set position
f = figure('Units','normalized','Position',[.1,.1,.8,.8]);
hold on;

% create map projection and set lat/lon boundary region
% m_proj('miller','lon',[230 360],'lat',[-10 60]);
m_proj('miller','lon',[0 360],'lat',[-60 60]);

% plot data shading
m_contourf(lon,lat,model_blend_fcst','linestyle','none')
set(gca,'colormap',flip(cm1))
set(gca,'clim',[-2 2]);

% plot state borders
for k=1: length(borders.ncst)
    m_plot(borders.ncst{k}(:,1), borders.ncst{k}(:,2),'color','#3d3d5c','linewidth',1);
    m_plot(borders.ncst{k}(:,1)+360, borders.ncst{k}(:,2),'color','#3d3d5c','linewidth',1);
end

% plot country borders
for k=1: length(borders2.ncst)
    m_plot(borders2.ncst{k}(:,1), borders2.ncst{k}(:,2),'color','#3d3d5c','linewidth',1);
    m_plot(borders2.ncst{k}(:,1)+360, borders2.ncst{k}(:,2),'color','#3d3d5c','linewidth',1);
end

% label latitude and longitude on the map
m_grid('tickdir','out','ticklength',.005,'linewi',1,'fontsize',10,...
    'xtick',0:20:360,'ytick',-90:10:90)

% set colorbar and colorbar label
cb = colorbar();
ylabel(cb, 'Sea Surface Temperature Anomalies','FontSize',12,'Rotation',270);
cb.FontSize = 10;

% define title
titleString = sprintf(['\\fontsize{18}CanSIPS+ECMWF+UKMET Superblend for Sea Surface Temperature Anomalies' ...
    '\n\\fontsize{16}%s to %s %s'],month1_str,month3_str,num2str(year));

% create and format the title
ttl = title(titleString, 'fontsize', 20);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

% save output to image
exportgraphics(f,sprintf('../../images/superblend%s%s_%s-%s_ssta.jpg',month_str,num2str(year),month1_str,month3_str))