function monthName = convertMonthStr(monthNumber)
    % Define a dummy year and day
    year = 2000;
    day = 1;
    
    % Create a datetime object with the specified month
    dt = datetime(year, monthNumber, day);
    
    % Get the abbreviated month name
    monthName = datestr(dt, 'mmm');
end