run_name = 'Samoylov_HCP_test3_3_';
% run_name = 'Samoylov_LCP_val23_3_';
run_name = 'Samoylov_4LCP_val2_12_';
%run_name = 'Samoylov_LCP_val2_3_';
%run_name = 'Samoylov_HCP_val2_3_';
run_name = 'Samoylov_4LCP_val2';

folder_path = 'H:\projects\coup\Nunataryuk\';
forcing_file = 'M:\git2\CryoGridExamples\forcing\samoylov_ERA_obs_fitted_1979_2014_spinup_extended2044.mat';
number_of_tiles = 13;
run_off_tile = 12;
year_range = 2005:2019;
%year_range = 2011:2012;


save_date='0901';
lateral_class_number_runoff = 2;
%variable = 'subsurface_run_off';
runoff_variable = 'surface_run_off';

rainfall = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
snowfall = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
water_storage = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
ice_storage = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
snow_storage = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
snow_water_storage = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
evaporation = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
latent_heat_flux = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
sensible_heat_flux = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
sublimation = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
SWE_max = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
runoff = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
lateral_snow_drift = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
tile_area = zeros(size(year_range,2).*12, number_of_tiles) .* NaN;
start_month = str2num(save_date(1:2));


%rainfall and snowfall
load(forcing_file)
index = 1;
for year = year_range 
    for month = start_month:12
        rainfall(index,:) = repmat(sum(FORCING.data.rainfall(FORCING.data.t_span >= datenum(year-1, month,1) & FORCING.data.t_span < datenum(year-1, month+1,1))), 1, number_of_tiles);
        snowfall(index,:) = repmat(sum(FORCING.data.snowfall(FORCING.data.t_span >= datenum(year-1, month,1) & FORCING.data.t_span < datenum(year-1, month+1,1))), 1, number_of_tiles);
        index = index +1; 
    end
    for month = 1:start_month-1
        rainfall(index,:) = repmat(sum(FORCING.data.rainfall(FORCING.data.t_span >= datenum(year, month,1) & FORCING.data.t_span < datenum(year, month+1,1))), 1, number_of_tiles);
        snowfall(index,:) = repmat(sum(FORCING.data.snowfall(FORCING.data.t_span >= datenum(year, month,1) & FORCING.data.t_span < datenum(year, month+1,1))), 1, number_of_tiles);
        index = index +1; 
    end
end
rainfall = rainfall .* (FORCING.data.t_span(2,1)-FORCING.data.t_span(1,1))./1000;
snowfall = snowfall .* (FORCING.data.t_span(2,1)-FORCING.data.t_span(1,1))./1000;


for tile = 1:number_of_tiles
    index = 1;
    for year = year_range
        filename = [folder_path run_name '_' num2str(tile) '/' run_name '_' num2str(tile) '_' num2str(year) save_date '.mat'];
        disp(['loading tile ' num2str(tile) ', year ' num2str(year)]);
        load(filename)
        for month = start_month:12
            range = find(out.TIMESTAMP(1,:) >= datenum(year-1, month,1) & out.TIMESTAMP(1,:) < datenum(year-1, month+1,1));
            
            water_storage(index,tile) = 0;
            ice_storage(index,tile) = 0;
            snow_storage(index,tile) = 0;
            snow_water_storage(index, tile) = 0;
            for tile_no = 1:size(out.STRATIGRAPHY{1,range(1)},1)
                water_storage(index,tile) = water_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.water);
                ice_storage(index,tile) = ice_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.ice);
                
                lateral_snow_drift(index,tile) = out.LATERAL{1, range(1)}{end,1}.STATVAR.drift_pool;
                try
                    water_storage(index,tile) = water_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.Xwater);
                    ice_storage(index,tile) = ice_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.Xice);
                end
                class_name = class(out.STRATIGRAPHY{1,range(1)}{tile_no,1});
                if strcmp(class_name(1:4), 'SNOW')
                    snow_storage(index,tile) = snow_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.ice);
                    snow_water_storage(index, tile) = snow_water_storage(index, tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.water);
                end
            end
            
            evap_sum = 0;
            Qh_sum = 0;
            N = 0;
            for i=range
                if out.STRATIGRAPHY{1,i}{1,1}.STATVAR.area(1,1) == out.STRATIGRAPHY{1,i}{2,1}.STATVAR.area(1,1)
                    evap_sum = evap_sum + out.STRATIGRAPHY{1,i}{1,1}.STATVAR.Qe;
                    Qh_sum = Qh_sum + out.STRATIGRAPHY{1,i}{1,1}.STATVAR.Qh;
                else
                    evap_sum = evap_sum + out.STRATIGRAPHY{1,i}{2,1}.STATVAR.Qe;
                    Qh_sum = Qh_sum + out.STRATIGRAPHY{1,i}{2,1}.STATVAR.Qh;
                end
                N = N+1;
            end
            latent_heat_flux(index,tile) = evap_sum ./N;
            sensible_heat_flux(index,tile) = Qh_sum ./N;
            evaporation(index,tile) = evap_sum .* 24 .* 3600 .* out.PARA.output_timestep ./ 2264.705e6; 
                 
            tile_area(index, tile) = out.STRATIGRAPHY{1,range(1)}{end,1}.STATVAR.area(1,1);
            if tile == run_off_tile
                runoff(index,run_off_tile) = out.LATERAL{1, range(1)}{lateral_class_number_runoff,1}.STATVAR.(runoff_variable);
            end

            index = index +1;
        end
        
        for month = 1:start_month-1
            range = find(out.TIMESTAMP(1,:) >= datenum(year, month,1) & out.TIMESTAMP(1,:) < datenum(year, month+1,1));
            
            water_storage(index,tile) = 0;
            ice_storage(index,tile) = 0;
                        snow_storage(index,tile) = 0;
            snow_water_storage(index, tile) = 0;
            for tile_no = 1:size(out.STRATIGRAPHY{1,range(1)},1)
                water_storage(index,tile) = water_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.water);
                ice_storage(index,tile) = ice_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.ice);
                
                lateral_snow_drift(index,tile) = out.LATERAL{1, range(1)}{end,1}.STATVAR.drift_pool;
                try
                    water_storage(index,tile) = water_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.Xwater);
                    ice_storage(index,tile) = ice_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.Xice);
                end
                class_name = class(out.STRATIGRAPHY{1,range(1)}{tile_no,1});
                if strcmp(class_name(1:4), 'SNOW')
                    snow_storage(index,tile) = snow_storage(index,tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.ice);
                    snow_water_storage(index, tile) = snow_water_storage(index, tile) + sum(out.STRATIGRAPHY{1,range(1)}{tile_no,1}.STATVAR.water);
                end
            end
            
            evap_sum = 0;
            Qh_sum = 0;
            N = 0;
            for i=range
                if out.STRATIGRAPHY{1,i}{1,1}.STATVAR.area(1,1) == out.STRATIGRAPHY{1,i}{2,1}.STATVAR.area(1,1)
                    evap_sum = evap_sum + out.STRATIGRAPHY{1,i}{1,1}.STATVAR.Qe;
                    Qh_sum = Qh_sum + out.STRATIGRAPHY{1,i}{1,1}.STATVAR.Qh;
                else
                    evap_sum = evap_sum + out.STRATIGRAPHY{1,i}{2,1}.STATVAR.Qe;
                    Qh_sum = Qh_sum + out.STRATIGRAPHY{1,i}{2,1}.STATVAR.Qh;
                end
                N = N+1;
            end
            latent_heat_flux(index,tile) = evap_sum ./N;
            sensible_heat_flux(index,tile) = Qh_sum ./N;
            evaporation(index,tile) = evap_sum .* 24 .* 3600 .* out.PARA.output_timestep ./ 2264.705e6;
            
            tile_area(index, tile) = out.STRATIGRAPHY{1,range(1)}{end,1}.STATVAR.area(1,1);
            if tile == run_off_tile
                runoff(index,run_off_tile) = out.LATERAL{1, range(1)}{lateral_class_number_runoff,1}.STATVAR.(runoff_variable);
            end
            index = index +1;
        end
        
        
    end
end

water_balance = sum((rainfall+snowfall).*tile_area,2);  %P
water_balance = [water_balance sum(evaporation .* tile_area,2)]; %ET
water_balance = [water_balance [runoff(2:end, run_off_tile)-runoff(1:end-1, run_off_tile); NaN]]; %lateral runoff
water_balance = [water_balance [sum(water_storage(2:end, :)-water_storage(1:end-1, :),2); NaN]]; %storage change water
water_balance = [water_balance [sum(ice_storage(2:end, :)-ice_storage(1:end-1, :),2); NaN]]; %storage change ice
water_balance = [water_balance [sum(lateral_snow_drift(2:end, :)-lateral_snow_drift(1:end-1, :),2); NaN]]; %lateral snow drift loss
water_balance = [water_balance [sum(snow_storage(2:end, :)-snow_storage(1:end-1, :),2); NaN]]; %snow ice storage change

bowen_ratio = sum(sensible_heat_flux .* tile_area,2) ./ sum(tile_area,2) ./ (sum(latent_heat_flux .* tile_area,2) ./ sum(tile_area,2));

%%

annual_balance = [];
offset_month = 3;
for year = year_range(1:end-1)
    current_year = year;
    range = offset_month + (year - year_range(1))*12 + 1:offset_month + (year - year_range(1))*12 + 12;
    disp([range(1) range(end)])
    range2 = (year - year_range(1))*12 + 1:(year - year_range(1))*12 + 12;
    current_year = [current_year sum(sum(rainfall(range,:).*tile_area(range,:),2) ./sum(tile_area(range,:),2),1) sum(sum(snowfall(range2,:).*tile_area(range2,:),2)./sum(tile_area(range2,:),2),1)];
    current_year = [current_year sum(sum(evaporation(range,:).*tile_area(range,:),2) ./sum(tile_area(range,:),2),1)];
    current_year = [current_year (runoff(range(end),run_off_tile)-runoff(range(1),run_off_tile)) ./ sum(tile_area(range(1),:),2)];
    annual_balance = [annual_balance; current_year];
end
annual_balance(:,2:end) = annual_balance(:,2:end).*1000;

annual_balance2=[annual_balance(:,1) sum(annual_balance(:,2:3),2) annual_balance(:,4)./sum(annual_balance(:,2:3),2) annual_balance(:,5)./sum(annual_balance(:,2:3),2)];