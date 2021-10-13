source_path = '../CryoGrid/source';
addpath(genpath(source_path));

%-----------------------------
% modified by user
%init_format = 'EXCEL3D'; %EXCEL or YAML
init_format = 'EXCEL';


%run_name= 'Terelj_1';
% run_name = 'Herschell_HCP';
% run_name = 'ERC_2021_ground_ice2';
% run_name = 'example4';
% run_name = 'test_BGC_3';
% run_name = 'HU_RDRSv2_QMwind';
% run_name = 'schilthorn_FC_2005_up_100_-10';
% run_name = 'Samoylov_LCP_test_snow';
% run_name = 'Paiku210625_whole';
% run_name = 'Samoylov_1D';
% run_name = 'test_AdM';
run_name = 'NyA_latWater_latHeat_silt_5m_Cc05_1880_2100';

constant_file = 'CONSTANTS_excel'; %file with constants
result_path = './results/';  %with trailing backslash
%result_path = '/uio/lagringshotell/geofag/projects/coup/Nunataryuk/'
%result_path = 'H:\projects/coup/Nunataryuk/';

% end modified by user
%------------------------

%providers
provider = PROVIDER;
provider = assign_paths(provider, init_format, run_name, result_path, constant_file);
provider = read_const(provider);
provider = read_parameters(provider);


% %creates the RUN_INFO class
 [run_info, provider] = run_model(provider);

 [run_info, tile] = run_model(run_info);


