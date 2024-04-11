clear
close all

% Load the netCDF file
ncfile = 'data/ibtracs.NA.v04r00.nc';
county_borders = m_shaperead('../borders/ne_10m_admin_2_counties');
country_borders = m_shaperead('../borders/ne_10m_admin_0_countries');
state_borders = m_shaperead('../borders/ne_110m_admin_1_states_provinces');
info = ncinfo(ncfile);

% Define the years you want to plot
years = [1878,1926,1998,2010,2020];

% Initialize map projection
f = figure('Units','inches','Position',[.5,.5,20,10]);
m_proj('miller', 'lon', [-120 0], 'lat', [0 60]);
set(gca,'color','b');


% Plot the density using m_contourf with nonzero counts
hexColor = '#aaaaaa'; % Your hexadecimal color code
rgbColor = sscanf(hexColor(2:end),'%2x%2x%2x',[1 3])/255;
m_coast('patch', rgbColor, 'edgecolor', 'k');
hold on

plot_borders('country', country_borders, 'state', state_borders);

% Pre-calculate storm tracks for each year
storm_tracks = cell(length(years), 1);

for year_index = 1:length(years)
    year = years(year_index);
    
    % Find all storm indices for the given year
    season_data = ncread(ncfile, 'season');
    storm_indices = find(season_data == year);
    
    if isempty(storm_indices)
        disp(['No storms found for year ', num2str(year)]);
    else
        for i = 1:numel(storm_indices)
            storm_index = storm_indices(i);
            lat = ncread(ncfile, 'lat', [1, storm_index], [Inf, 1]);
            lon = ncread(ncfile, 'lon', [1, storm_index], [Inf, 1]);
            usa_wind = ncread(ncfile, 'usa_wind', [1, storm_index], [Inf, 1]);
            usa_wind = usa_wind * 1.151;
            storm_name = ncread(ncfile, 'name', [1, storm_index], [Inf, 1])';
            
            % Color the storm track segments based on usa_wind value
            for segment = 2:length(lon)
                if isnan(usa_wind(segment))
                    % Skip plotting this segment if usa_wind is NaN
                    continue;
                end
                
                if usa_wind(segment) <= 39
                    color = '#1c54ff'; % tropical depression
                elseif usa_wind(segment) <= 73
                    color = '#6cc343'; % tropical storm
                elseif usa_wind(segment) <= 95
                    color = '#ffc309'; % category 1
                elseif usa_wind(segment) <= 110
                    color = '#ff7209'; % category 2
                elseif usa_wind(segment) <= 129
                    color = '#e83b0c'; % category 3
                elseif usa_wind(segment) <= 156
                    color = '#e80cae'; % category 4
                else
                    color = '#bd00ff'; % category 5
                end
                m_plot(lon(segment-1:segment), lat(segment-1:segment), 'color', color, 'linewidth', 2);
            end
            
            % Add track label with year and storm name
            % m_text(lon(1), lat(1), [num2str(year) ': ' storm_name], 'color', 'k', 'fontsize', 10);  % Label at first point
        end
    end
end

% label latitude and longitudes on map
m_grid('tickdir','out','ticklength',.005,'linewi',1,'fontsize',10,...
    'xtick',-160:10:160,'ytick',-60:10:60);



xlabel('Longitude');
ylabel('Latitude');
title('Tropical Cyclone Tracks');

exportgraphics(f,'images/stormTrackPlots_CSUAprilForecastAnalogs.jpg')

