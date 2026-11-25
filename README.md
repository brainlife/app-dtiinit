[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.3-blue.svg)](https://doi.org/10.25663/bl.app.3)

# abcd-dtiinit

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Preprocesses single-shell DWI with vistasoft dtiInit (optional eddy current and motion correction, b-vector rotation) and aligns it to a T1-weighted image, producing a dtiInit directory and an aligned DWI.**

Runs vistasoft dtiInit (compiled MATLAB): optional eddy/motion correction, resampling to the chosen resolution, alignment to the ACPC-aligned T1 and tensor fitting, writing the standard dtiInit/dt6 directory used by mrDiffusion, AFQ and LiFE. The aligned DWI, bvecs and bvals are also exported as a dwi output. The README recommends eddyCorrect=-1 and both rotate options false for HCP data; set noDwiAlignment if the DWI is already aligned to the T1.

Run it on brainlife.io: [https://doi.org/10.25663/bl.app.3](https://doi.org/10.25663/bl.app.3)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` (single_shell) | yes | Single-shell DWI with bvecs and bvals to preprocess. Single shell (datatype tag single_shell). |
| `t1` | `neuro/anat/t1w` | yes | T1 image to align the output dwi data to. Should be ACPC aligned; dtiInit aligns the DWI to it. |

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/dtiinit` | dtiInit directory (dt6.json/product.json, aligned DWI, tensor fit and transforms) in vistasoft layout. |
| `dwi` | `neuro/dwi` | Aligned DWI (dwi_aligned_trilin_noMEC) with its rotated bvecs and bvals. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `phaseEncodeDir` | enum | `2` | Taken from the rawDti nifti field, you can specify it here if it does not exist. If you collected your DTI data using GE's ASSET, you may be prompted to provide phase-encode direction (1= L/R 'row', 2 = A/P 'col'). Information about this, as well as the b-value and gradient code, can befound in the dicom file header. Options: `2`, `1`, `3`. |
| `resolution` | string | `default` | enter the three values of the desired resolution separated by spaces |
| `rotateBvecsWithCanXform` | boolean | `true` | Rotate the bvectors according to the canonical xForm. You need to set this to true for Siemens data (such as HCP) and Philips (see mrDiffusion/dtiInit/dtiInit.m section VII) |
| `rotateBvecsWithRx` | boolean | `true` | Rotate the bvectors according to the prescription (see mrDiffusion/dtiInit/dtiInit.m section VII) |
| `eddyCorrect` | enum | `1` | do eddy current and motion correction Options: `-1`, `1`, `0`. |
| `noDwiAlignment` | boolean | `false` | Do not align the DWI data to T1. When True, the DWI data are considered already acpc aligned to T1 and have neurological orientation. The configuration of eddy correction is forced to -1 and Bvecs rotations to False. |

Runtime: container `brainlife/mcr:neurodebian1604-r2017a`; 8 CPUs; 15 GB memory; 6 h walltime.

<!-- brainlife-app:end -->

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
    "phaseEncodeDir": "2",
    "resolution": "default",
    "rotateBvecsWithCanXform": true,
    "rotateBvecsWithRx": true,
    "eddyCorrect": "-1",
    "dwi": "somewhere/dwi/dwi.nii.gz",
    "bvecs": "somewhere/dwi/dwi.bvecs",
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
