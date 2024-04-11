function plot_borders(varargin)
    % Parse input arguments
    county_borders = [];
    country_borders = [];
    state_borders = [];
    
    for i = 1:numel(varargin)
        if strcmp(varargin{i}, 'county')
            county_borders = varargin{i+1};
        elseif strcmp(varargin{i}, 'country')
            country_borders = varargin{i+1};
        elseif strcmp(varargin{i}, 'state')
            state_borders = varargin{i+1};
        end
    end

    % Plot county borders if provided
    if ~isempty(county_borders)
        for k = 1:length(county_borders.ncst)
            m_plot(county_borders.ncst{k}(:,1) , county_borders.ncst{k}(:,2), 'color', '#090909', 'linewidth', 1);
        end
    end

    % Plot country borders if provided
    if ~isempty(country_borders)
        for k = 1:length(country_borders.ncst)
            m_plot(country_borders.ncst{k}(:,1), country_borders.ncst{k}(:,2), 'color', '#2f3030', 'linewidth', 1.2);
        end
    end

    % Plot state borders if provided
    if ~isempty(state_borders)
        for k = 1:length(state_borders.ncst)
            m_plot(state_borders.ncst{k}(:,1), state_borders.ncst{k}(:,2), 'color', '#2f3030', 'linewidth', 1.2);
        end
    end
end