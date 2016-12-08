function [] = main()

%if isempty(getenv('SCA_SERVICE_DIR'))
%    disp('setting SCA_SERVICE_DIR to pwd')
%    setenv('SCA_SERVICE_DIR', pwd)
%end

disp('loading paths')
addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
%!module load spm

% load my own config.json
config = loadjson('config.json');
%[ out ] = dti_service(config);

% run dtiInit
dwParams = dtiInitParams(...
    'clobber',1, ...
    'phaseEncodeDir',2, ...
    'bvecsFile',config.bvecs, ...
    'bvalsFile',config.bvals, ...
    'outDir', pwd ...
);
dtiInit(config.dwi, config.t1, dwParams)

