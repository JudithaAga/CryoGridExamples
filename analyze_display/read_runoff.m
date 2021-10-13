
folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_LCP_val2_3\';
folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_HCP_test3_3\';
folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_4LCP_val2_12\';
%folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_LCP_val2_3\';
%folder_path = 'H:\projects\coup\Nunataryuk\Samoylov_HCP_val2_3\';



run_name = 'Samoylov_HCP_test3_3_';
% run_name = 'Samoylov_LCP_val23_3_';
run_name = 'Samoylov_4LCP_val2_12_';
%run_name = 'Samoylov_LCP_val2_3_';
%run_name = 'Samoylov_HCP_val2_3_';

save_date='0901';

year_range = 2011:2012;

lateral_class_number = 2;

variable = 'subsurface_run_off';
variable = 'surface_run_off';

data = [];
data_year=[];

for year = year_range
    disp(year)
    load([folder_path run_name num2str(year) save_date '.mat'])
    for i=1:size(out.LATERAL,2)
        data = [data; out.LATERAL{1, i}{lateral_class_number,1}.STATVAR.(variable)];
    end
    data_year=[data_year; out.LATERAL{1, end}{lateral_class_number,1}.STATVAR.(variable) - out.LATERAL{1, 1}{lateral_class_number,1}.STATVAR.(variable)];

end