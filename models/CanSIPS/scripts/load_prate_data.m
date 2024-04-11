function [prate_month] = load_prate_data(year, month)
    month_str = sprintf('%02d', month); % Ensure month is represented as two digits
    file = sprintf('../data/netcdf4/prate/CANSIPS_prate_hindcast_Mar%d%s.nc', year, month_str);
    prate = ncread(file, 'prate');
    prate_month = squeeze(prate(:, :, 1));
end