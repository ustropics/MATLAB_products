clear
close all

% Load the netCDF file
ncfile = 'data/ibtracs.NA.v04r00.nc';
info = ncinfo(ncfile);

% define strong La Nina seasons
years = [2010, 1973, 1916, 1975, 1998, 1892, 1988, 1999, 1893, 1933, 1942, 1955, 1856, 1889, 1909, 2022];

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

% set longitude and latitude limits for the map projection
latlim = [10 50];
lonlim = [-140 0];

% plot density
figure('Units','inches','Position',[.5,.5,20,10]);
geodensityplot(latAll, lonAll,'FaceColor','interp');

% set title and title options
ttl = title({'Density Tracks for Strong La Nina Years (ASO ONI values < -1.0)',...
    '{\fontsize{12} Years: 2010, 1973, 1916, 1975, 1998, 1892, 1988, 1999, 1893, 1933, 1942, 1955, 1856, 1889, 1909, 2022}'},'fontsize',16);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

geolimits(latlim, lonlim); % set limits for the map projection

% set colorbar and cb settings
c = colorbar;
c.Label.String = 'Tropical Cyclone Track Density';
c.FontSize = 16;

% set ticks and tick labels
ticks = linspace(0, .5, 2.5); % Adjust the tick positions as needed
tickLabels = cellstr(num2str(ticks', '%-g')); % Format tick labels without scientific notation
c.Ticks = ticks;
c.TickLabels = tickLabels;

% save plot as an image
saveas(gca,'images/geoDensityPlot_strongNina.jpg');
