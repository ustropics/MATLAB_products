clear
close all

% read in data files
NMME_prate_file = '../data/prate/NMME.prate.202404.ENSMEAN.anom.nc';
ncdisp(NMME_prate_file)

% set initial variables
lat = ncread(NMME_prate_file,'lat');
lon = ncread(NMME_prate_file,'lon');
prate = ncread(NMME_prate_file,'fcst');
init_time = ncread(NMME_prate_file,'initial_time');
target_months = ncread(NMME_prate_file,'target');


% calculate date
reference_date = datetime(1960,1,1,12,0,0, ...
    'Format','yyyy-MM-dd HH:mm:ss','TimeZone','UTC');

init_month = reference_date + calmonths(init_time);

month_name = datestr(datenum(0, month(init_month), 1), 'mmmm');