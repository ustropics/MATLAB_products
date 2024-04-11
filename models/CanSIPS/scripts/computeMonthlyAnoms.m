function [monthly_averages] = computeMonthlyAnoms(folder_path, start_year, end_year)
    % Initialize cell array to store prate data
    prate_data = cell(end_year - start_year + 1, 12); % Assuming max 31 days in a month

    for year = start_year:end_year
        for month = 1:12
            % Generate filename
            month_str = sprintf('%02d', month); % Format month as two digits
            filename = sprintf('%sCANSIPS_prate_hindcast_Jan%d.nc', folder_path, year);

            % Extract prate values
            prate = ncread(filename, 'prate');

            % Squeeze the first month
            prate_data{year - start_year + 1, month} = squeeze(prate(:,:,1)); % Assuming you want the first month's data
        end
    end

    % Initialize cell array to store monthly averages
    monthly_averages = cell(1, 12);

    % Loop through each month
    for month = 1:12
        % Initialize array to store prate values for the current month
        month_data = zeros(size(prate_data{1, month}));

        % Accumulate prate values for the current month from all years
        for year = 1:size(prate_data, 1)
            month_data = month_data + prate_data{year, month};
        end

        % Calculate the mean for the current month
        monthly_averages{month} = month_data / size(prate_data, 1);
    end
end