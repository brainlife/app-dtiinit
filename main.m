function [] = main()

switch getenv('ENV')
case 'IUHPC'
    disp('loading paths (HPC) - hayashis')
    addpath(genpath('/N/u/brlife/git/vistasoft'))
    addpath(genpath('/N/u/brlife/git/jsonlab'))
case 'VM'
    disp('loading paths (VM)')
    addpath(genpath('/usr/local/vistasoft'))
    addpath(genpath('/usr/local/jsonlab'))
end

% load my own config.json
config = loadjson('config.json')

% to find resolution
disp('loading dwi resolution')
dwi = niftiRead(config.dwi);
res = dwi.pixdim(1:3)
clear dwi

dwParams = dtiInitParams;
dwParams.eddyCorrect       = -1;
dwParams.rotateBvecsWithRx = 0;
dwParams.rotateBvecsWithCanXform = 0;
dwParams.phaseEncodeDir    = 2; 
dwParams.clobber           =  1;
dwParams.bvecsFile  = config.bvecs;
dwParams.bvalsFile  = config.bvals;
dwParams.dt6BaseName = 'dti';
dwParams.outDir = '.';
dwParams.dwOutMm    = res;

%apply config params
if isfield(config, 'eddyCorrect')
    dwParams.eddyCorrect = str2double(config.eddyCorrect);
    dwParams.rotateBvecsWithRx = config.rotateBvecsWithRx;
    dwParams.rotateBvecsWithCanXform = config.rotateBvecsWithCanXform;
end

%dump paths to be used
dtiInitDir(config.dwi, dwParams)

[dt6FileName, outBaseDir] = dtiInit(config.dwi, config.t1, dwParams)

disp('creating product.json')
product = struct();
product.dt6 = load(dt6FileName{1});
product.dtlog = load('dtiInitLog.mat');
product.datatype_tags = {'test','another'};
savejson('', product, 'product.json');


