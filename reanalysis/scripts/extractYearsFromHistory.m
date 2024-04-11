function years = extractYearsFromHistory(historyValue)
    % Find the index of 'composite:'
    compositeIndex = strfind(historyValue, 'composite:');
    
    if ~isempty(compositeIndex)
        % Extract years after 'composite:'
        yearsStr = strtrim(historyValue(compositeIndex+10:end));
        years = strsplit(yearsStr);
    else
        years = [];
    end
end