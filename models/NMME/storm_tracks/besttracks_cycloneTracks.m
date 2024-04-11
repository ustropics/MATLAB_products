clear
close all

% Load the netCDF file
ncfile = 'ibtracs.NA.v04r00.nc';
info = ncinfo(ncfile);

% Define the years you're interested in
years = [2010, 1973, 1916, 1975, 1998, 1892, 1988, 1999, 1893, 1933, 1942, 1955, 1856, 1889, 1909, 2022]; % Add more years as needed

% Set longitude and latitude limits for the map projection
latlim = [10 50];
lonlim = [-140 0];

% Plot density
figure('Units','inches','Position',[.5,.5,20,10]);

for year = years
    % Find all storm indices for the given year
    season_data = ncread(ncfile, 'season');
    storm_indices = find(season_data == year);

    if ~isempty(storm_indices)
        % Accumulate latitude and longitude for all storms in this year
        for i = 1:numel(storm_indices)
            storm_index = storm_indices(i);
            lat = ncread(ncfile, 'lat', [1, storm_index], [Inf, 1]);
            lon = ncread(ncfile, 'lon', [1, storm_index], [Inf, 1]);

            % Plot storm track
            geoplot(lat, lon, 'Color', 'blue'); % Adjust color and style as needed
            hold on
        end
    else
        disp(['No storms found for year ', num2str(year)]);
    end
end

ttl = title({'Tropical Cyclone Tracks for Selected Years',...
    '{\fontsize{12} Years: 2010, 1973, 1916, 1975, 1998, 1892, 1988, 1999, 1893, 1933, 1942, 1955, 1856, 1889, 1909, 2022}'},'fontsize',16);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

geolimits(latlim, lonlim); % Set limits for the map projection

saveas(gca,'images/TropicalCycloneTracks.jpg');
