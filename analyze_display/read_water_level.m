folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_LCP_val2_1\';
%folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_HCP_test2_3\';
folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_2LCP_val2_6\';
%folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_LCP_val24_3\';
%folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_LCP_overland_val22_3\';
folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_3LCP_val1_10\';
folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_4LCP_val1_13\';
% run_name = 'Samoylov_LCP_REq_1_';
run_name = 'Samoylov_LCP_val2_1_';
%run_name = 'Samoylov_HCP_test2_3_';
run_name = 'Samoylov_2LCP_val2_6_';
%run_name = 'Samoylov_LCP_val24_3_';
%run_name = 'Samoylov_LCP_overland_val22_3_';
run_name = 'Samoylov_3LCP_val1_10_';
run_name = 'Samoylov_4LCP_val1_13_';

save_date='0901';

year_range = 2011:2012;


target_cell_size = 0.02;
new_grid = 20 + [-2:target_cell_size:1]';
%new_grid = [15:target_cell_size:21]';
threshold = target_cell_size/10;  

%define target variables
result.T = [];
result.waterIce =[];
result.water = [];
result.ice = [];
  %result.Xice = [];
 % result.Xwater = [];
  %result.XwaterIce = [];
  %result.waterPotential = [];
%result.saltConc = [];
%result.salt_c_brine=[];
result.class_number = [];
%must all have the same dimensions in all fields

for year = year_range
    disp(year)
    load([folder_path run_name num2str(year) save_date '.mat'])

    variableList = fieldnames(result);
    numberOfVariables = size(variableList,1);


    for i=1:size(out.STRATIGRAPHY,2)
        
        altitudeLowestCell = out.STRATIGRAPHY{1,i}{end,1}.STATVAR.lowerPos;

        layerThick=[];
        area=[];
        
        for j=1:size(out.STRATIGRAPHY{1,i},1)
            layerThick=[layerThick; out.STRATIGRAPHY{1,i}{j,1}.STATVAR.layerThick];
            area=[area; out.STRATIGRAPHY{1,i}{j,1}.STATVAR.area];
        end
        layerThick_temp = layerThick;
        layerThick = zeros(size(layerThick,1).*2, 1).* NaN;
        layerThick(1:2:size(layerThick,1),1) = threshold;
        layerThick(2:2:size(layerThick,1),1) = layerThick_temp - threshold;
        
        area_temp = area;
        area=[area; area].* NaN;
        area(1:2:size(layerThick,1),1) = area_temp;
        area(2:2:size(layerThick,1),1) = area_temp;
        
        %     depths = [0; cumsum(layerThick)];
        %     depths = -(depths-depths(end,1));
        %     depths = (depths(1:end-1,1)+depths(2:end,1))./2 + altitudeLowestCell;
        
        
        temp=repmat(NaN, size(layerThick_temp,1), numberOfVariables);
        pos=1;
        for j = 1:size(out.STRATIGRAPHY{1,i},1)
            fieldLength = size(out.STRATIGRAPHY{1,i}{j,1}.STATVAR.layerThick,1);
            for k=1:numberOfVariables-1
                if any(strcmp(fieldnames(out.STRATIGRAPHY{1,i}{j,1}.STATVAR), variableList{k,1}))
                    temp(pos:pos+fieldLength-1,k) = out.STRATIGRAPHY{1,i}{j,1}.STATVAR.(variableList{k,1});
                end
            end
            temp(pos:pos+fieldLength-1,numberOfVariables) = zeros(fieldLength,1) + size(out.STRATIGRAPHY{1,i},1)+1-j; %assigna class number starting with 1 from the bottom
            pos = pos+fieldLength;
        end
        
        %compute targate variables
        for k=1:numberOfVariables
            if strcmp(variableList{k,1}, 'saltConc')
                pos_waterIce = find(strcmp(variableList, 'waterIce'));
                temp(:,k) = temp(:,k)./ (temp(:,pos_waterIce) ./layerThick_temp./area_temp);  %divide by total water content
            end
        end
        
        for k=1:numberOfVariables
            if strcmp(variableList{k,1}, 'water') || strcmp(variableList{k,1}, 'ice') || strcmp(variableList{k,1}, 'waterIce') || strcmp(variableList{k,1}, 'XwaterIce') || strcmp(variableList{k,1}, 'Xwater') || strcmp(variableList{k,1}, 'Xice') || strcmp(variableList{k,1}, 'saltConc')
                temp(:,k) = temp(:,k)./layerThick_temp./area_temp;
            end
            %result.(variableList{k,1}) = [result.(variableList{k,1}) interp1(depths, temp(:,k), new_grid)];
        end
        
        temp_temp = temp;
        temp=[temp; temp].* NaN;
        temp(1:2:size(layerThick,1),:) = temp_temp;
        temp(2:2:size(layerThick,1),:) = temp_temp;
        
        %interpolate to new grid
        depths = cumsum(layerThick);
        depths = depths - threshold/2;
        depths(1) = 0;
        depths = -(depths-depths(end,1));
        depths = depths + altitudeLowestCell;
        
        for k=1:numberOfVariables
            result.(variableList{k,1}) = [result.(variableList{k,1}) interp1(depths, temp(:,k), new_grid, 'nearest')];
        end
        
    end
    
    
    

end