% Load the netCDF file
ncfile = 'data/ibtracs.NA.v04r00.nc';
county_borders = m_shaperead('../borders/ne_10m_admin_2_counties');
country_borders = m_shaperead('../borders/ne_10m_admin_0_countries');
state_borders = m_shaperead('../borders/ne_110m_admin_1_states_provinces');
info = ncinfo(ncfile);

% Define the years you want to plot
years = [1969,1998,2005,2010];
season = 'MJJ';

% convert years to a string
yearsStr = sprintf('%d, ', years);
yearsStr = yearsStr(1:end-2);  % Remove the last comma and space

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
            % Read latitude and longitude for the storm
            lat = ncread(ncfile, 'lat', [1, storm_indices(i)], [Inf, 1]);
            lon = ncread(ncfile, 'lon', [1, storm_indices(i)], [Inf, 1]);
            latAll = [latAll; lat];
            lonAll = [lonAll; lon];
        end
    else
        disp(['No storms found for year ', num2str(year)]);
    end
end

% Set longitude and latitude limits for the map projection
latlim = [0 60]; % Adjusted latitude limits
lonlim = [-120 0]; % Adjusted longitude limits

% Create a map projection using m_proj
f = figure('Units','inches','Position',[.5,.5,20,10]);
m_proj('Miller', 'lon', lonlim, 'lat', latlim);

% Count the number of points in each bin
nBins = 100; % Number of bins for density estimation
[counts, lon_edges, lat_edges] = histcounts2(lonAll, latAll, nBins, 'Normalization', 'count');

% Filter out counts that are 0
nonzero_counts = imgaussfilt(counts, .5);
nonzero_counts(nonzero_counts == 0) = NaN;  % Set zero counts to NaN

% Reshape counts to match the grid
lon_centers = (lon_edges(1:end-1) + lon_edges(2:end)) / 2;
lat_centers = (lat_edges(1:end-1) + lat_edges(2:end)) / 2;
[LON, LAT] = meshgrid(lon_centers, lat_centers);

% Plot the density using m_contourf with nonzero counts
hexColor = '#aaaaaa'; % Your hexadecimal color code
rgbColor = sscanf(hexColor(2:end),'%2x%2x%2x',[1 3])/255;
m_coast('patch', rgbColor, 'edgecolor', 'k');
hold on

levels = 0.5:0.1:15;
colormap("turbo")
for i = 1:length(levels)-1
    [~,h(i)] = m_contourf(LON, LAT, nonzero_counts', [levels(i), levels(i+1)], 'LineStyle', 'none');
    h(i).FaceAlpha = 0.05; % Set transparency for this contour level
end

% set borders to be plotted using custom function
plot_borders('country', country_borders, 'state', state_borders);
set(gca,'clim',[0 15])

% Set title and title options
ttl = title({'Density Tracks for TSR April 2024 forecast Analogs',...
    ['{\fontsize{12} Years: ' yearsStr '}']},'fontsize',16);
ttl.Units = 'normalized';
ttl.Position(1) = 0;
ttl.HorizontalAlignment = 'left';

% Add a colorbar and adjust its settings
c = colorbar;
c.Label.String = 'Tropical Cyclone Track Density';
c.FontSize = 16;

% Set ticks and tick labels
ticks = linspace(1, max(counts(:)), 0); % Adjust the tick positions as needed
c.Ticks = ticks;

% Label latitude and longitudes on map
m_grid('tickdir','out','ticklength',.005,'linewi',1,'fontsize',10,...
    'xtick',-160:10:0,'ytick',0:10:60);

% save file
% filename = sprintf('images/geodensityTrackPlots_laNina%s.jpg', season);
filename = 'images/geodensityTrackPlots_TSRAprilFcst.jpg';
exportgraphics(f, filename);
