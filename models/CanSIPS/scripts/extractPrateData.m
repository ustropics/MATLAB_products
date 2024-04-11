function prateData = extractPrateData(folderPath)
    % Get a list of all netCDF files in the specified folder
    ncFiles = dir(fullfile(folderPath, '*.nc'));
    
    % Initialize a cell array to store prate data for each year
    prateData = cell(length(ncFiles), 1);
    
    % Loop through each netCDF file
    for i = 1:length(ncFiles)
        % Read the netCDF file
        ncFile = fullfile(folderPath, ncFiles(i).name);
        year = ncread(ncFile, 'year');
        prate = ncread(ncFile, 'prate');
        
        % Store prate data in the cell array, using year as an index
        prateData{year - min(year) + 1} = prate;
    end
end
