clear
%% 1. read in data
folder_path = '../data/netcdf4/prate/';
fcst_file = '../data/netcdf4/fcst/CANSIPS_fcst_mar2024.nc';
% ncdisp(fcst_file)

%% 2. set variables
start_year = 1990;
end_year = 2020;

%% 3. perform calculations
monthly_averages = computeMonthlyAnoms(folder_path, start_year, end_year);

% Extract month1 from the monthly_averages
month3_anom = monthly_averages{3}; % Accessing the first element of the cell array
month7_anom = monthly_averages{7};
month10_anom = monthly_averages{2};

lon = ncread(fcst_file,'lon');
lat = ncread(fcst_file,'lat');
prate = ncread(fcst_file,'prate');



prate_month1 = squeeze(prate(:,:,1));
prate_month5 = squeeze(prate(:,:,5));
prate_month7 = squeeze(prate(:,:,7));

prate_month7_anom = prate_month7 - month10_anom;

cm = othercolor('BrBG10');

%% 4. Create map projection and plot data
% create figure and set position
figure('Units','normalized','Position',[.1,.1,.8,.8]);
hold on;

m_proj('miller','lon',[0 360],'lat',[-60 60]);

m_contourf(lon,lat,prate_month7_anom'*1e4,-2:0.1:2,'linestyle','none')
set(gca,'colormap',cm)
set(gca,'clim',[-2 2]);

% plot US continent, coastlines, and state boundaries
% m_coast('patch',[.9 .9 .9],'edgecolor','k');
m_coast('line','color','k');

% label latitude and longitude on the map
m_grid('tickdir','out','ticklength',.005,'linewi',1,'fontsize',10,...
    'xtick',0:20:360,'ytick',-90:10:90)

cb = colorbar();
ylabel(cb, 'Precipitation Anomalies (C)','FontSize',12,'Rotation',270);