clear
close all

% Load the netCDF file
ncfile = 'ibtracs.NA.v04r00.nc';
info = ncinfo(ncfile);

% Define the years you're interested in
years = [1894, 1950, 1974, 1978, 1985, 1996, 2017, 1870, 1936, 1961, 1967, 2008, 2013, 1863, 1882, 1949, 1981, 1984, 1989, 2001, 1853, 1854, 1858, 1873, 1912, 1915, 1928, 1931, 1934, 1943, 1945, 1959, 1962, 1966, 1980, 1992, 2005]; % Add more years as needed

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
years_line1 = 'Years: 1894, 1950, 1974, 1978, 1985, 1996, 2017, 1870, 1936, 1961, 1967, 2008, 2013,1863, 1882, 1949, 1981, 1984, 1989,';
years_line2 = '2001, 1853, 1854, 1858, 1873, 1912, 1915, 1928, 1931, 1934, 1943, 1945, 1959, 1962, 1966, 1980, 1992, 2005';
years_combined = [years_line1, newline, years_line2];

ttl = title({'Density Tracks for Cold Neutral (ASO ONI values between -0.4 and -0.1)',...
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

saveas(gca,'images/geoDensityPlot_coldNeutral.jpg');
