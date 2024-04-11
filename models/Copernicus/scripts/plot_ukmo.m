ukmo_filename = '../data/prate/ukmo_Mar2024.nc';
ecmwf_filename = '../data/prate/ecmwf_Mar2024.nc';
jma_filename = '../data/prate/jma_Mar2024.nc';
ncdisp(jma_filename)

jma_lat = ncread(jma_filename,'latitude');
lat = ncread(ukmo_filename,'latitude');
lon = ncread(ukmo_filename,'longitude');
ukmo_prate = ncread(ukmo_filename,'tpara');
ecmwf_prate = ncread(ecmwf_filename,'tpara');
jma_prate = ncread(jma_filename,'tpara');

cansips_prate_aug = average_month1(:, 1:end-1);
cansips_prate_JJA = average_JJA(:, 1:end-1);

ukmo_prate_jun = squeeze(ukmo_prate(:,:,4));
ukmo_prate_jul = squeeze(ukmo_prate(:,:,5));
ukmo_prate_aug = squeeze(ukmo_prate(:,:,6));

ecmwf_prate_jun = squeeze(ecmwf_prate(:,:,4));
ecmwf_prate_jul = squeeze(ecmwf_prate(:,:,5));
ecmwf_prate_aug = squeeze(ecmwf_prate(:,:,6));

jma_prate_jun = squeeze(jma_prate(:,:,4));
jma_prate_jul = squeeze(jma_prate(:,:,5));
jma_prate_aug = squeeze(jma_prate(:,:,6));

ecmwf_prate_JJA = (ecmwf_prate_jun + ecmwf_prate_jul + ecmwf_prate_aug) / 3;
ukmo_prate_JJA = (ukmo_prate_jun + ukmo_prate_jul + ukmo_prate_aug) / 3;
jma_prate_JJA = (jma_prate_jun + jma_prate_jul + jma_prate_aug) / 3;

ukmo_ecmwf_cansip_Aug = (ukmo_prate_aug*1e8 + ecmwf_prate_aug*1e8 + cansips_prate_aug*1e5) / 3;
ukmo_ecmwf_prate_JJA = (ecmwf_prate_JJA + ukmo_prate_JJA) / 2;

ukmo_ecmwf_cansip_prate_JJA = (ecmwf_prate_JJA*1e8 + ukmo_prate_JJA*1e8 + cansips_prate_JJA*1e5) / 3;

cm1 = othercolor('BrBG9',25);
CI = -1:.2:1;

%% 3. create projection and plot data

% create figure and set position
figure('Units','normalized','Position',[.1,.1,.8,.8]);
hold on;

% create map projection and set lat/lon boundary region
m_proj('miller','lon',[230 360],'lat',[0 60]);
% m_proj('miller','lon',[0 360],'lat',[-60 60]);

% plot data shading
m_contourf(lon,lat,ukmo_ecmwf_cansip_prate_JJA',-7:.2:5,'linestyle','none')
set(gca,'colormap',cm1)
set(gca,'clim',[-5 5])

% plot US continent, coastlines, and state boundaries
m_coast('line','color','k');

% label latitude and longitude on the map
m_grid('tickdir','out','ticklength',.005,'linewi',1,'fontsize',10,...
    'xtick',0:20:360,'ytick',-90:10:90)

cb = colorbar();
ylabel(cb, 'Precipitation Rates','FontSize',12,'Rotation',270);
