function [] = main()

% Karst and Big Red 2 (IU) specific configuration
if exist('/N/u/hayashis/BigRed2/git/vistasoft','dir')
    disp('loading paths')
    addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
end

% Jetstream specific configuration
if exist('/root/git/vistasoft','dir')
    disp('loading paths')
    addpath(genpath('/root/git/vistasoft'))
    addpath(genpath('/root/git/jsonlab'))
end

% load my own config.json
config = loadjson('config.json');

% to find resolution
dwi = niftiRead(config.dwi);
res = dwi.pixdim(1:3);
clear dwi

% run dtiInit
% https://github.com/vistalab/vistasoft/blob/master/mrDiffusion/dtiInit/dtiInitParams.m
dwParams = dtiInitParams(...
    'clobber',1, ...
    'phaseEncodeDir',2, ...
    'bvecsFile',config.bvecs, ...
    'bvalsFile',config.bvals, ...
    'dt6BaseName','dti_trilin', ...
    'outDir', pwd, ...
    'dwOutMm', res ...
);

dtiInit(config.dwi, config.t1, dwParams)

