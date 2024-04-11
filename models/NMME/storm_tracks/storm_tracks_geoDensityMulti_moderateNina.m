clear
close all

% Load the netCDF file
ncfile = 'data/ibtracs.NA.v04r00.nc';
info = ncinfo(ncfile);

% Define the years you're interested in
years = [1910, 1924, 1938, 1954, 2011, 2020, 1874, 1886, 1890, 1964, 1970, 1971, 1995, 1917, 2016, 2021, 1869, 1879, 1903, 1872, 1875, 1898, 1906, 1908, 1922, 1956, 1983, 2000]; % Add more years as needed

% Accumulate latitude and longitude for all years
latAll = [];
lonAll = [];

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

            latAll = [latAll; lat];
            lonAll = [lonAll; lon];
        end
    else
        disp(['No storms found for year ', num2str(year)]);
    end
end

% Set longitude and latitude limits for the map projection
latlim = [10 50];
lonlim = [-140 0];

% Plot density
figure('Units','inches','Position',[.5,.5,20,10]);
geodensityplot(latAll, lonAll,'FaceColor','interp');
ttl = title({'Density Tracks for Moderate La Nina Years (ASO ONI values between -0.9 and -0.5)',...
    '{\fontsize{12} Years: 1910, 1924, 1938, 1954, 2011, 2020, 1874, 1886, 1890, 1964, 1970, 1971, 1995, 1917, 2016, 2021, 1869, 1879, 1903, 1872, 1875, 1898, 1906, 1908, 1922, 1956, 1983, 2000}'},'fontsize',16);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

geolimits(latlim, lonlim); % Set limits for the map projection

c = colorbar;
c.Label.String = 'Tropical Cyclone Track Density';
c.FontSize = 16;

% Set ticks and tick labels
ticks = linspace(0, .5, 2.5); % Adjust the tick positions as needed
tickLabels = cellstr(num2str(ticks', '%-g')); % Format tick labels without scientific notation
c.Ticks = ticks;
c.TickLabels = tickLabels;

saveas(gca,'images/geoDensityPlot_moderateNina.jpg');
