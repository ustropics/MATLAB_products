function downloadCansipsFcstData(year, month)
    % Construct the URL
    url = sprintf('https://dd.weather.gc.ca/ensemble/cansips/grib2/forecast/raw/%d/%02d/cansips_forecast_raw_latlon2.5x2.5_PRATE_SFC_0_%d-%02d_allmembers.grib2', year, month, year, month);
    
    % Define the filename to save the downloaded file
    month_names = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
    filename = sprintf('CANSIPS_prate_fcst_%s%d.grib2', month_names{month}, year);
    
    % Define the directory
    directory = '../data/grib2/fcst/';
    
    % Construct the full path
    full_path = fullfile(directory, filename);
    
    try
        % Download the file
        websave(full_path, url);
        disp(['File downloaded successfully: ', full_path]);
    catch
        disp('Error downloading file. Please check the URL and try again.');
    end
end