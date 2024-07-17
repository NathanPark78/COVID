function datacovid = data_process()
    %iterated data processing through csv
    datacovid = {'Country' 'State'};
    raw = readcell('time_series_covid19_confirmed_global.csv');
    for ii = 5:size(raw,2)
        raw{1,ii} = sprintf('%d/%d/%d',raw{1,ii}.Month,raw{1,ii}.Day,raw{1,ii}.Year);
    end
    %refining the data, cleaning out names
    datacovid = [datacovid raw(1,5:end)];
    deaths = readtable('time_series_covid19_deaths_global.csv');
    deaths = table2cell(deaths);
    cases = raw(2:end,5:end);
    deathfin = deaths(2:end,5:end);
    countries = raw(2:end,2);
    states = raw(2:end,1);
    
    %country formatting
    for ii = 1:size(cases,1)
        if ~isempty(strfind(countries{ii},'fill'))
            continue;
        end

        datacovid{end+1,1} = countries{ii};
        if strcmp(countries{ii},'US')
            datacovid{end,1} = 'United States';
        end

        datacovid{end,2} = states{ii};
        for jj = 1:size(cases,2)
            datacovid{end,jj+2} = [(cases{ii,jj}) (deathfin{ii,jj}) ];
        end

    end
    
    %convert to cell
    raw = readtable('time_series_covid19_confirmed_US.csv');
    raw = table2cell(raw);
    deaths = readtable('time_series_covid19_deaths_US.csv');
    deaths = table2cell(deaths);
    cur_state = '';
    for ii = 2:size(deaths,1)
        state = deaths{ii,7};
        if contains(state,'fill')
            continue;
        end
        if ~strcmp(cur_state,state)
                if ~isempty(cur_state)
                    datacovid{end+1,1} = 'United States';
                    datacovid{end,2} = cur_state;
                    for jj = 1:size(raw,2)-11
                        datacovid{end,jj+2} = [case_count(jj) death_count(jj)];
                    end
                end
                death_count = zeros(1,size(raw,2)-11);
                case_count = zeros(1,size(raw,2)-11);
                cur_state = state;
        end
        for jj = 1:size(raw,2)-11
            death_count(jj) = death_count(jj) + (deaths{ii,jj+12});
            case_count(jj) = case_count(jj) + (raw{ii,jj+11});
        end 
    end

    %adding in last state
    datacovid{end+1,1} = 'United States';
    datacovid{end,2} = cur_state;
    for jj = 1:size(raw,2)-11
        datacovid{end,jj+2} = [case_count(jj) death_count(jj)];
    end
    
    %adding in other countries
    special = {'Australia' , 'Canada' , 'China' };
    for name = special
        indexes = [];
        for ii = 2:size(datacovid,1)
            if strcmp(datacovid{ii,1},name{1})
                indexes(end+1) = ii;
            end
        end
        datacovid{end+1,1} = name{1};
        datacovid{end,2} = '';
        for jj = 3:size(datacovid,2)
            datacovid{end,jj} = [0 0];
            for ii = indexes
                datacovid{end,jj} = datacovid{end,jj} + datacovid{ii,jj};
            end
        end 
    end 

    %fixing empty column for non-negative
    for ii = 2:size(datacovid,1)
        if ismissing(datacovid{ii,2})
            datacovid{ii,2} = '';
        end
    end
    %sort and organize countries
    datacovid{1,1} = 'AAA';
    datacovid = sortrows(datacovid,[1 2]);
    datacovid{1,1} = 'Country';
end