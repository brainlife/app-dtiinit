#!/bin/bash
module load matlab/2017a

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/vistasoft'))
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/soft/mason/SPM/spm8'))
mcc -m -R -nodisplay -a /N/u/brlife/git/vistasoft/mrAnatomy/Segment -a /N/u/brlife/git/vistasoft/mrDiffusion/templates  -d compiled dtiinit
exit
END
matlab -nodisplay -nosplash -r build

