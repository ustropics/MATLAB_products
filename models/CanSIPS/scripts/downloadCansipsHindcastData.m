function downloadCansipsHindcastData(years)
    % Start parallel pool if not already started
    if isempty(gcp('nocreate'))
        parpool('local');
    end
    
    % Use parfor loop for parallel execution
    parfor i = 1:length(years)
        year = years(i);
        % Loop through months
        for month = 1:12
            % Form the URL for the specific month and year
            url = sprintf('https://dd.weather.gc.ca/ensemble/cansips/grib2/hindcast/raw/%d/%02d/cansips_hindcast_raw_latlon2.5x2.5_PRATE_SFC_0_%d-%02d_allmembers.grib2', year, month, year, month);

            % Download data
            disp(['Downloading data for ' num2str(year) '-' num2str(month, '%02d') '...']);
            data = webread(url);

            % Define filename
            filename = sprintf('../data/grib2/CANSIPS_prate_hindcast_%s%d.grib2', datestr(datenum(year,month,1),'mmm'), year);

            % Save data
            websave(filename, url);
        end
    end
end