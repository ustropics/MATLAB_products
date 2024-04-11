function [month, year] = extractDate(filename)
    % Open NetCDF file and read global attributes
    nc_info = ncinfo(filename);
    
    % Search for the creation_date attribute
    creation_date_attr = nc_info.Attributes(strcmp({nc_info.Attributes.Name}, 'creation_date'));
    
    % Extract creation_date string
    creation_date_str = creation_date_attr.Value;
    
    % Initialize month and year
    month = [];
    year = [];
    
    % Search for month abbreviations in the creation_date string
    months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
    for i = 1:length(months)
        month_idx = strfind(creation_date_str, months{i});
        if ~isempty(month_idx)
            month = i;
            break;
        end
    end
    
    % Extract year
    year_match = regexp(creation_date_str, '\d{4}', 'match', 'once');
    if ~isempty(year_match)
        year = str2double(year_match);
    end
end