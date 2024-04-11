function months = extractMonthsFromHistory(historyValue)
    % Regular expression pattern to match the month substrings
    pattern = 'Season is (\w+) to (\w+);';

    % Define arrays for mapping abbreviated month names to full month names
    abbreviatedMonths = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
    fullMonths = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'};

    % Find the month substrings using regular expression
    tokens = regexp(historyValue, pattern, 'tokens');

    if ~isempty(tokens)
        % Extracting the first month from the tokens
        firstMonthSubstring = tokens{1}{1};
        % Extracting the second month from the tokens
        secondMonthSubstring = tokens{1}{2};

        % Finding the index of the abbreviated first month in the array
        firstMonthIndex = find(strcmp(abbreviatedMonths, firstMonthSubstring));
        % Finding the index of the abbreviated second month in the array
        secondMonthIndex = find(strcmp(abbreviatedMonths, secondMonthSubstring));

        if ~isempty(firstMonthIndex) && ~isempty(secondMonthIndex)
            % Get the corresponding full month names
            firstMonth = fullMonths{firstMonthIndex};
            secondMonth = fullMonths{secondMonthIndex};
            months = {firstMonth, secondMonth};
        else
            months = {'Unknown', 'Unknown'}; % If any month is not recognized
        end
    else
        months = {'Unknown', 'Unknown'}; % If the pattern is not found in historyValue
    end
end
