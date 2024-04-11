clear
close all

% Load the netCDF file
ncfile = 'ibtracs.NA.v04r00.nc';
info = ncinfo(ncfile);

% Define the year
year = 2023;

% Find all storm indices for the given year
season_data = ncread(ncfile, 'season');
storm_indices = find(season_data == year);

if isempty(storm_indices)
    disp(['No storms found for year ', num2str(year)]);
else
    % Accumulate latitude and longitude for all storms
    latAll = [];
    lonAll = [];
    
    for i = 1:numel(storm_indices)
        storm_index = storm_indices(i);
        lat = ncread(ncfile, 'lat', [1, storm_index], [Inf, 1]);
        lon = ncread(ncfile, 'lon', [1, storm_index], [Inf, 1]);
        
        latAll = [latAll; lat];
        lonAll = [lonAll; lon];
    end
    
    % Plot density
    figure;
    geodensityplot(latAll, lonAll,'FaceColor','interp');
    title(['Tropical Cyclone Density Plot - ', num2str(year)]);
end