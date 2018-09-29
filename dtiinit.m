disp('running dtiinit')

if ~isdeployed
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
end

% load my own config.json
config = loadjson('config.json')

% to find resolution
if ~isfield(config,'resolution')
    disp('resolution not set.. setting it to default value')
    set(config, 'resolution', 'default')
end

disp('loading dwi resolution')
if strcmp(config.resolution,'default')
    dwi = niftiRead(config.dwi);
    res = dwi.pixdim(1:3);
else
    res = str2num(config.resolution);
end
clear dwi

% https://github.com/vistalab/vistasoft/blob/master/mrDiffusion/dtiInit/dtiInitParams.m
dwParams = dtiInitParams;
dwParams.eddyCorrect       = str2num(config.eddyCorrect);
dwParams.rotateBvecsWithRx = config.rotateBvecsWithRx;
dwParams.rotateBvecsWithCanXform = config.rotateBvecsWithCanXform;
dwParams.phaseEncodeDir    = str2num(config.phaseEncodeDir); 
dwParams.clobber           =  1;
dwParams.bvecsFile  = config.bvecs;
dwParams.bvalsFile  = config.bvals;
dwParams.dt6BaseName = 'dti';
dwParams.outDir = '.';
dwParams.dwOutMm    = res;

disp(dwParams)

%dump paths to be used
dtiInitDir(config.dwi, dwParams)

[dt6FileName, outBaseDir] = dtiInit(config.dwi, config.t1, dwParams)

disp('creating product.json')
dt6 = load(dt6FileName{1})
%TODO - maybe load other things like dti/fibers/conTrack?
savejson('', dt6, 'product.json');

