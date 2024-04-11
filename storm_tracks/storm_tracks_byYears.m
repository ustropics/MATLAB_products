clear
close all

% load the netCDF file and border shapefiles
ncfile = 'data/ibtracs.NA.v04r00.nc';
county_borders = m_shaperead('../borders/ne_10m_admin_2_counties');
country_borders = m_shaperead('../borders/ne_10m_admin_0_countries');
state_borders = m_shaperead('../borders/ne_110m_admin_1_states_provinces');
info = ncinfo(ncfile);

% define the years we want to plot
years = [2023]; % Add more years as needed

% set our colormap
num_years = numel(years);
color_map = lines(num_years);

% plot cyclone tracks for each year
figure;

m_proj('miller', 'lon', [-88 -78], 'lat', [25 32]);
hold on;

% set borders to be plotted using custom function
plot_borders('county',county_borders,'country', country_borders, 'state', state_borders);

for i = 1:num_years
    year = years(i);
    % Find all storm indices for the given year
    season_data = ncread(ncfile, 'season');
    number_data = ncread(ncfile, 'number');
    storm_indices = find(season_data == year);
    
    if ~isempty(storm_indices)
        for j = 1:numel(storm_indices)
            storm_index = storm_indices(j);
            lat = ncread(ncfile, 'lat', [1, storm_index], [Inf, 1]);
            lon = ncread(ncfile, 'lon', [1, storm_index], [Inf, 1]);
            m_line(lon, lat, 'color', color_map(i, :), 'LineWidth', 1); % Assign color based on year
        end
    end
end

m_grid('linestyle', 'none', 'tickdir', 'out');
xlabel('Longitude');
ylabel('Latitude');
title('Tropical Cyclone Tracks');
colorbar('Ticks', linspace(0, 1, num_years), 'TickLabels', cellstr(num2str(years')));
