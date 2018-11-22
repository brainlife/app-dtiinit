[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.3-blue.svg)](https://doi.org/10.25663/bl.app.3)

# abcd-dtiinit
This App runs [vistasoft/dtiInit](https://github.com/vistalab/vistasoft/wiki/DWI-Initialization) which is a dwi preprocessing software that can run eddy/motion correction and coregister to t1 anatomy. This preprocessing is necessary for various DWI processing such as tensor fittings and stream tracking. dtiInit products various other files stored in a standard directory stuctures used by some vistasoft applications; mrDiffusion, AFQ, mrTrix, LiFE, etc. Other Apps may juse use the dwi output from this App.

## Parameters
Configurations and input parameters were explained within Brainlife App execution page. More detailed explanations of those parameters were explained [here](https://github.com/vistalab/vistasoft/blob/master/mrDiffusion/dtiInit/dtiInitParams.m)

Best parameters for the HCP datasets 
* eddyCorrect = (-1) no eddy current or motion correction 
* rotateBvecsWithCanXform = false 
* rotateBvecsWithRx = false

### Authors
- Lindsey Kitchell (kitchell@indiana.edu)
- Soichi Hayashi (hayashis@iu.edu)

### Project director
- Franco Pestilli (franpest@indiana.edu)

### Funding 
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)

## Running the App 

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/bl.app.3](https://doi.org/10.25663/bl.app.3) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
{
    "phaseEncodeDir": "2",
    "resolution": "default",
    "rotateBvecsWithCanXform": true,
    "rotateBvecsWithRx": true,
    "eddyCorrect": "-1",
    "dwi": "somewhere/dwi/dwi.nii.gz",
    "bvecs": somewhere/dwi/dwi.bvecs",
    "bvals": "somewhere/dwi/dwi.bvals",
    "t1": "somewhere/anat/t1.nii.gz"
}
```

3. Launch the App by executing `main`

```bash
./main
```

### Sample Datasets

If you don't have your own input files, you can download sample datasets from Brainlife.io, or you can use [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download 5a050a00eec2b300611abff3 && mv 5a050a00eec2b300611abff3 dwi
bl dataset download 5a050966eec2b300611abff2 && mv 5a050966eec2b300611abff2 anat
```

## Output

dtiInit output files are explained [here](https://github.com/vistalab/vistasoft/wiki/DWI-Initialization#youre-done). This App also outputs a copy of the aligned dwi files.

#### Product.json

product.json will contains the same information stored in `dtiinit.mat`

```json
{
	"adcUnits": null,
	"params": {
		"nBootSamps": 500,
		"buildDate": "2018-10-02 22:47",
		"buildId": "hayashis on Matlab R2017a (GLNXA64)",
		"rawDataDir": ".",
		"rawDataFile": "dwi_aligned_trilin_noMEC.nii",
		"subDir": ""
	},
	"files": {
		"b0": "dti\/bin\/b0.nii.gz",
		"brainMask": "dti\/bin\/brainMask.nii.gz",
		"wmMask": "dti\/bin\/wmMask.nii.gz",
		"wmProb": "dti\/bin\/wmProb.nii.gz",
		"tensors": "dti\/bin\/tensors.nii.gz",
		"vecRgb": "dti\/bin\/vectorRGB.nii.gz",
		"faStd": "dti\/bin\/faStd.nii.gz",
		"mdStd": "dti\/bin\/mdStd.nii.gz",
		"pddDisp": "dti\/bin\/pddDispersion.nii.gz",
		"t1": "\/5bb3ecea8b415c002a21b08e\/5a050966eec2b300611abff2\/t1.nii.gz",
		"alignedDwRaw": ".\/dwi_aligned_trilin_noMEC.nii.gz",
		"alignedDwBvecs": ".\/dwi_aligned_trilin_noMEC.bvecs",
		"alignedDwBvals": ".\/dwi_aligned_trilin_noMEC.bvals"
	}
}

```

### Dependencies

This App only requires [singularity](https://www.sylabs.io/singularity/) to run. If you don't have singularity, you will need to install following dependencies.  

  - Matlab: https://www.mathworks.com/products/matlab.html
  - jsonlab: https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab-a-toolbox-to-encode-decode-json-files
  - VISTASOFT: https://github.com/vistalab/vistasoft/
