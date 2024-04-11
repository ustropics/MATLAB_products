clear
close all

% Load the netCDF file
ncfile = 'ibtracs.NA.v04r00.nc';
info = ncinfo(ncfile);

% Define the years you're interested in
years = [1857, 1859, 1861, 1866, 1876, 1878, 1881, 1883, 1887, 1907, 1927, 1937, 1948, 2019, 1935, 1939, 1952, 1993, 2014, 1851, 1865, 1891, 1911, 1913, 1919, 1920, 1960, 1979, 2003, 2012, 1867, 1868, 1880, 1929, 1958, 1968, 1990, 2018]; % Add more years as needed

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
years_line1 = 'Years: 1857, 1859, 1861, 1866, 1876, 1878, 1881, 1883, 1887, 1907, 1927, 1937, 1948, 2019, 1935, 1939, 1952,';
years_line2 = '  1993, 2014, 1851, 1865, 1891, 1911, 1913, 1919, 1920, 1960, 1979, 2003, 2012, 1867, 1868, 1880, 1929, 1958, 1968, 1990, 2018';
years_combined = [years_line1, newline, years_line2];

ttl = title({'Density Tracks for Warm Neutral (ASO ONI values between 0.1 and 0.4)',...
    ['{\fontsize{12} ' years_combined '}']},'fontsize',16);
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

saveas(gca,'images/geoDensityPlot_warmNeutral.jpg');
