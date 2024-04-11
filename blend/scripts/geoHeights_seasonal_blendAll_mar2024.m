close all
clear

%% 1. Import necessary files
% import files for model data
ECMWF_file = '../../data/netcdf4/ecmwf_Mar2024_500mbHeights.nc';
NCEP_file = '../../data/netcdf4/ncep_Mar2024_500mbHeights.nc';
UKMO_file = '../../data/netcdf4/ukmo_Mar2024_500mbHeights.nc';
JMA_file = '../../data/netcdf4/jma_Mar2024_500mbHeights.nc';
CMC_file = '../../data/netcdf4/cmc_Mar2024_500mbHeights.nc';
DWD_file = '../../data/netcdf4/dwd_Mar2024_500mbHeights.nc';
METEO_file = '../../data/netcdf4/meteo_Mar2024_500mbHeights.nc';
ECCC_file = '../../data/netcdf4/eccc_Mar2024_500mbHeights.nc';


% import state and country borders
states = readgeotable('../../Borders/ne_110m_admin_1_states_provinces.shp');
countries = readgeotable('../../Borders/ne_10m_admin_0_countries.shp');

%% 2. set variables and initial arrays
% set initial months
month1 = 4;
month2 = 5;
month3 = 6;

% set lon,lat values
lon = ncread(ECMWF_file,'longitude');
lat = ncread(ECMWF_file,'latitude');

lon2 = ncread(JMA_file,'longitude');
lat2 = ncread(JMA_file,'latitude');

% set constant for acceleration of gravity
g = 9.8;

% set color map and contour interval
CM = othercolor('RdBu11',20);
CI = -3:.1:3;

%% 3. extract necessary data and set to arrays
% extract model data for geopotential height anomalies
ECMWF_fcst = ncread(ECMWF_file,'za') / g;
NCEP_fcst = ncread(NCEP_file,'za') / g;
UKMO_fcst = ncread(UKMO_file,'za') / g;
JMA_fcst = ncread(JMA_file,'za') / g;
CMC_fcst = ncread(CMC_file,'za') / g;
DWD_fcst = ncread(DWD_file,'za') / g;
METEO_fcst = ncread(METEO_file,'za') / g;
ECCC_fcst = ncread(ECCC_file,'za') / g;

% extract data for ECMWF model
ECMWF_fcst_month1 = squeeze(ECMWF_fcst(:,:,month1));
ECMWF_fcst_month2 = squeeze(ECMWF_fcst(:,:,month2));
ECMWF_fcst_month3 = squeeze(ECMWF_fcst(:,:,month3));

% extract data for NCEP model
NCEP_fcst_month1 = squeeze(NCEP_fcst(:,:,month1));
NCEP_fcst_month2 = squeeze(NCEP_fcst(:,:,month2));
NCEP_fcst_month3 = squeeze(NCEP_fcst(:,:,month3));

% extract data for UKMO model
UKMO_fcst_month1 = squeeze(UKMO_fcst(:,:,month1));
UKMO_fcst_month2 = squeeze(UKMO_fcst(:,:,month2));
UKMO_fcst_month3 = squeeze(UKMO_fcst(:,:,month3));

% extract data for JMA model
JMA_fcst_month1 = squeeze(JMA_fcst(:,:,month1));
JMA_fcst_month2 = squeeze(JMA_fcst(:,:,month2));
JMA_fcst_month3 = squeeze(JMA_fcst(:,:,month3));

% extract data for CMC model
CMC_fcst_month1 = squeeze(CMC_fcst(:,:,month1));
CMC_fcst_month2 = squeeze(CMC_fcst(:,:,month2));
CMC_fcst_month3 = squeeze(CMC_fcst(:,:,month3));

% extract data for DWD model
DWD_fcst_month1 = squeeze(DWD_fcst(:,:,month1));
DWD_fcst_month2 = squeeze(DWD_fcst(:,:,month2));
DWD_fcst_month3 = squeeze(DWD_fcst(:,:,month3));

% extract data for ECCC model
ECCC_fcst_month1 = squeeze(ECCC_fcst(:,:,month1));
ECCC_fcst_month2 = squeeze(ECCC_fcst(:,:,month2));
ECCC_fcst_month3 = squeeze(ECCC_fcst(:,:,month3));

% extract data for METEO model
METEO_fcst_month1 = squeeze(METEO_fcst(:,:,month1));
METEO_fcst_month2 = squeeze(METEO_fcst(:,:,month2));
METEO_fcst_month3 = squeeze(METEO_fcst(:,:,month3));

% create seasonal forecasts for models
ECMWF_seasonal_fcst = (ECMWF_fcst_month1 + ECMWF_fcst_month2 + ECMWF_fcst_month3) / 3;
NCEP_seasonal_fcst = (NCEP_fcst_month1 + NCEP_fcst_month2 + NCEP_fcst_month3) / 3;
UKMO_seasonal_fcst = (UKMO_fcst_month1 + UKMO_fcst_month2 + UKMO_fcst_month3) / 3;
JMA_seasonal_fcst = (JMA_fcst_month1 + JMA_fcst_month2 + JMA_fcst_month3) / 3;
CMC_seasonal_fcst = (CMC_fcst_month1 + CMC_fcst_month2 + CMC_fcst_month3) / 3;
DWD_seasonal_fcst = (DWD_fcst_month1 + DWD_fcst_month2 + DWD_fcst_month3) / 3;
ECCC_seasonal_fcst = (ECCC_fcst_month1 + ECCC_fcst_month2 + ECCC_fcst_month3) / 3;
METEO_seasonal_fcst = (METEO_fcst_month1 + METEO_fcst_month2 + METEO_fcst_month3) / 3;

%% 4. Perform calculations and create figure
% convert borders to geotables
S = geotable2table(states,["Latitude" "Longitude"]);
T = geotable2table(countries,["Latitude" "Longitude"]);

% configure borders for plotting on stereographic projection
[state_latitude,state_longitude] = polyjoin(S.Latitude',S.Longitude');
[country_latitude,country_longitude] = polyjoin(T.Latitude',T.Longitude');

f = figure('Units','normalized','Position', [.1,.1,.8,.8]);
annotation('textbox', [0.085, 0.9, 0.8, 0.08], 'String', ...
   '500mb Geopotential Heights Anomalies Seasonal Forecast from March Dataset \fontsize{14}(For June — August 2024)', ...
    'FontSize', 18, 'FontWeight','bold', 'EdgeColor', 'none', 'HorizontalAlignment', 'left');

tiledlayout(2,4,'TileSpacing','compact')

%% 5. Create subplot 1 for ECMWF
nexttile
m_proj('stereographic','lat',40,'long',-90,'radius',45);
hold on

% plot data shading
m_contourf(lon,lat,ECMWF_seasonal_fcst'/10,CI,'linestyle','none')
set(gca,'colormap',flip(CM))
set(gca,'clim',[-3 3])

m_grid('xtick',[],'tickdir','out','ytick',[],'linest','--','fontsize',16);

m_plot(state_longitude,state_latitude,'k','linewidth',1);
m_plot(country_longitude,country_latitude,'k','linewidth',1);

title('ECMWF')

%% 6. Create subplot 2 for NCEP
nexttile
m_proj('stereographic','lat',40,'long',-90,'radius',45);
hold on

% plot data shading
m_contourf(lon,lat,NCEP_seasonal_fcst'/10,CI,'linestyle','none')
set(gca,'colormap',flip(CM))
set(gca,'clim',[-4 4])

m_grid('xtick',[],'tickdir','out','ytick',[],'linest','--','fontsize',16);

m_plot(state_longitude,state_latitude,'k','linewidth',1);
m_plot(country_longitude,country_latitude,'k','linewidth',1);

title('NCEP')

%% 7. Create subplot 3 for UKMET
nexttile
m_proj('stereographic','lat',40,'long',-90,'radius',45);
hold on

% plot data shading
m_contourf(lon,lat,UKMO_seasonal_fcst'/10,CI,'linestyle','none')
set(gca,'colormap',flip(CM))
set(gca,'clim',[-4 4])

m_grid('xtick',[],'tickdir','out','ytick',[],'linest','--','fontsize',16);

m_plot(state_longitude,state_latitude,'k','linewidth',1);
m_plot(country_longitude,country_latitude,'k','linewidth',1);

title('UKMET')

%% 8. Create subplot 4 for JMA
nexttile
m_proj('stereographic','lat',40,'long',-90,'radius',45);
hold on

% plot data shading
m_contourf(lon2,lat2,JMA_seasonal_fcst'/10,CI,'linestyle','none')
set(gca,'colormap',flip(CM))
set(gca,'clim',[-3 3])

m_grid('xtick',[],'tickdir','out','ytick',[],'linest','--','fontsize',16);

m_plot(state_longitude,state_latitude,'k','linewidth',1);
m_plot(country_longitude,country_latitude,'k','linewidth',1);

title('JMA')

%% 9. Create subplot 5 for CMC
nexttile
m_proj('stereographic','lat',40,'long',-90,'radius',45);
hold on

% plot data shading
m_contourf(lon,lat,CMC_seasonal_fcst'/10,CI,'linestyle','none')
set(gca,'colormap',flip(CM))
set(gca,'clim',[-3 3])

m_grid('xtick',[],'tickdir','out','ytick',[],'linest','--','fontsize',16);

m_plot(state_longitude,state_latitude,'k','linewidth',1);
m_plot(country_longitude,country_latitude,'k','linewidth',1);

title('CMCC')

%% 10. Create subplot 6 for DWD
nexttile
m_proj('stereographic','lat',40,'long',-90,'radius',45);
hold on

% plot data shading
m_contourf(lon,lat,DWD_seasonal_fcst'/10,CI,'linestyle','none')
set(gca,'colormap',flip(CM))
set(gca,'clim',[-3 3])

m_grid('xtick',[],'tickdir','out','ytick',[],'linest','--','fontsize',16);

m_plot(state_longitude,state_latitude,'k','linewidth',1);
m_plot(country_longitude,country_latitude,'k','linewidth',1);

title('DWD')

%% 10. Create subplot 7 for METEO
nexttile
m_proj('stereographic','lat',40,'long',-90,'radius',45);
hold on

% plot data shading
m_contourf(lon,lat,METEO_seasonal_fcst'/10,CI,'linestyle','none')
set(gca,'colormap',flip(CM))
set(gca,'clim',[-4 4])

m_grid('xtick',[],'tickdir','out','ytick',[],'linest','--','fontsize',16);

m_plot(state_longitude,state_latitude,'k','linewidth',1);
m_plot(country_longitude,country_latitude,'k','linewidth',1);

title('METEO-France')

%% 11. Create subplot 8 for ECCC
nexttile
m_proj('stereographic','lat',40,'long',-90,'radius',45);
hold on

% plot data shading
m_contourf(lon,lat,ECCC_seasonal_fcst'/10,CI,'linestyle','none')
set(gca,'colormap',flip(CM))
set(gca,'clim',[-3 3])

m_grid('xtick',[],'tickdir','out','ytick',[],'linest','--','fontsize',16);

m_plot(state_longitude,state_latitude,'k','linewidth',1);
m_plot(country_longitude,country_latitude,'k','linewidth',1);

title('ECCC')

h = axes(f,'Visible','off');
h.XLabel.Visible = 'off';
h.YLabel.Visible = 'off';

c = colorbar(h,'Position',[0.1 0.05 0.8 0.03],'Orientation','horizontal');  % attach colorbar to h
set(gca,'colormap',flip(CM))
set(gca,'clim',[-3 3])

ylabel(c, 'Geopotential Height Anomaly (dam)', 'FontSize', 12);

% save image
exportgraphics(f,'../../images/geoHeights_MME_blend.jpg')