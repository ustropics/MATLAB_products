clear
close all

% read in hindcast data
file_1990 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1990.nc';
file_1991 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1991.nc';
file_1992 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1992.nc';
file_1993 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1993.nc';
file_1994 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1994.nc';
file_1995 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1995.nc';
file_1996 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1996.nc';
file_1997 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1997.nc';
file_1998 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1998.nc';
file_1999 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar1999.nc';
file_2000 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2000.nc';
file_2001 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2001.nc';
file_2002 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2002.nc';
file_2003 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2003.nc';
file_2004 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2004.nc';
file_2005 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2005.nc';
file_2006 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2006.nc';
file_2007 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2007.nc';
file_2008 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2008.nc';
file_2009 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2009.nc';
file_2010 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2010.nc';
file_2011 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2011.nc';
file_2012 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2012.nc';
file_2013 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2013.nc';
file_2014 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2014.nc';
file_2015 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2015.nc';
file_2016 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2016.nc';
file_2017 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2017.nc';
file_2018 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2018.nc';
file_2019 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2019.nc';
file_2020 = '../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar2020.nc';


prate_1990 = ncread(file_1990,'prate');
prate_1991 = ncread(file_1991,'prate');
prate_1992 = ncread(file_1992,'prate');
prate_1993 = ncread(file_1993,'prate');
prate_1994 = ncread(file_1994,'prate');
prate_1995 = ncread(file_1995,'prate');
prate_1996 = ncread(file_1996,'prate');
prate_1997 = ncread(file_1997,'prate');
prate_1998 = ncread(file_1998,'prate');
prate_1999 = ncread(file_1999,'prate');
prate_2000 = ncread(file_2000,'prate');
prate_2001 = ncread(file_2001,'prate');
prate_2002 = ncread(file_2002,'prate');
prate_2003 = ncread(file_2003,'prate');
prate_2004 = ncread(file_2004,'prate');
prate_2005 = ncread(file_2005,'prate');
prate_2006 = ncread(file_2006,'prate');
prate_2007 = ncread(file_2007,'prate');
prate_2008 = ncread(file_2008,'prate');
prate_2009 = ncread(file_2009,'prate');
prate_2010 = ncread(file_2010,'prate');
prate_2011 = ncread(file_2011,'prate');
prate_2012 = ncread(file_2012,'prate');
prate_2013 = ncread(file_2013,'prate');
prate_2014 = ncread(file_2014,'prate');
prate_2015 = ncread(file_2015,'prate');
prate_2016 = ncread(file_2016,'prate');
prate_2017 = ncread(file_2017,'prate');
prate_2018 = ncread(file_2018,'prate');
prate_2019 = ncread(file_2019,'prate');
prate_2020 = ncread(file_2020,'prate');


prate_1990_03 = squeeze(prate_1990(:,:,2));
prate_1991_03 = squeeze(prate_1991(:,:,2));
prate_1992_03 = squeeze(prate_1992(:,:,2));
prate_1993_03 = squeeze(prate_1993(:,:,2));
prate_1994_03 = squeeze(prate_1994(:,:,2));
prate_1995_03 = squeeze(prate_1995(:,:,2));
prate_1996_03 = squeeze(prate_1996(:,:,2));
prate_1997_03 = squeeze(prate_1997(:,:,2));
prate_1998_03 = squeeze(prate_1998(:,:,2));
prate_1999_03 = squeeze(prate_1999(:,:,2));
prate_2000_03 = squeeze(prate_2000(:,:,2));
prate_2001_03 = squeeze(prate_2001(:,:,2));
prate_2002_03 = squeeze(prate_2002(:,:,2));
prate_2003_03 = squeeze(prate_2003(:,:,2));
prate_2004_03 = squeeze(prate_2004(:,:,2));
prate_2005_03 = squeeze(prate_2005(:,:,2));
prate_2006_03 = squeeze(prate_2006(:,:,2));
prate_2007_03 = squeeze(prate_2007(:,:,2));
prate_2008_03 = squeeze(prate_2008(:,:,2));
prate_2009_03 = squeeze(prate_2009(:,:,2));
prate_2010_03 = squeeze(prate_2010(:,:,2));
prate_2011_03 = squeeze(prate_2011(:,:,2));
prate_2012_03 = squeeze(prate_2012(:,:,2));
prate_2013_03 = squeeze(prate_2013(:,:,2));
prate_2014_03 = squeeze(prate_2014(:,:,2));
prate_2015_03 = squeeze(prate_2015(:,:,2));
prate_2016_03 = squeeze(prate_2016(:,:,2));
prate_2017_03 = squeeze(prate_2017(:,:,2));
prate_2018_03 = squeeze(prate_2018(:,:,2));
prate_2019_03 = squeeze(prate_2019(:,:,2));
prate_2020_03 = squeeze(prate_2020(:,:,2));

% Stack all variables into an array
prate_stack = cat(3, prate_1990_03, prate_1991_03, prate_1992_03, prate_1993_03, prate_1994_03, ...
                      prate_1995_03, prate_1996_03, prate_1997_03, prate_1998_03, prate_1999_03, ...
                      prate_2000_03, prate_2001_03, prate_2002_03, prate_2003_03, prate_2004_03, ...
                      prate_2005_03, prate_2006_03, prate_2007_03, prate_2008_03, prate_2009_03, ...
                      prate_2010_03, prate_2011_03, prate_2012_03, prate_2013_03, prate_2014_03, ...
                      prate_2015_03, prate_2016_03, prate_2017_03, prate_2018_03, prate_2019_03);

% Compute the mean along the stacked dimension
prate_mean = mean(prate_stack, 3);

fcst_file = '../data/netcdf4/fcst/CANSIPS_fcst_mar2024.nc';
lon = ncread(fcst_file,'lon');
lat = ncread(fcst_file,'lat');
prate = ncread(fcst_file,'prate');
prate_month1 = squeeze(prate(:,:,2));

prate_month1_anom = prate_month1 - prate_mean;

cm = othercolor('BrBG6');

%% 4. Create map projection and plot data
% create figure and set position
figure('Units','normalized','Position',[.1,.1,.8,.8]);
hold on;

m_proj('miller','lon',[0 360],'lat',[-60 60]);

m_contourf(lon,lat,prate_month1_anom'*1e4,-2:.5:1,'linestyle','none')
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