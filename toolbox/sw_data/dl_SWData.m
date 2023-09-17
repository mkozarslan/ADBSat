% Downloads Space Weather Data from https://celestrak.org/SpaceData/

function dl_SWData()
    url = 'https://celestrak.org/SpaceData/SW-All.csv';
    base_path = ADBSat_dynpath();
    rel_path = 'toolbox/sw_data';
    filename = fullfile(base_path, rel_path, 'SW-All.csv');

    % Check if the file exists
    if exist(filename, 'file')
        % Get the file's modification date
        file_info = dir(filename);
        % modDate = datetime(file_info.date);
        modDate = parseFileDate(file_info.date);
        
        % Check if the modification date is today
        % if isequal(modDate.Date, datetime('today').Date)
        if year(modDate) == year(datetime('today')) && month(modDate) == month(datetime('today')) && day(modDate) == day(datetime('today'))
            % fprintf('Space Weather Data for today already exists. Skipping download.\n');
            return;
        end
    end

    % Check if the directory exists; if not, create it
    if ~exist(fullfile(base_path, rel_path), 'dir')
        mkdir(fullfile(base_path, rel_path));
    end

    websave(filename, url);

    % fprintf('Space Weather Data downloaded and saved as %s\n', filename);
end
