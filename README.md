<h1 align="center">dtiInit</h1>

<p align="center">
  An eddy- and motion-corrected diffusion-weighted image aligned to a T1-weighted anatomy, plus a vistasoft dtiInit directory, from single-shell DWI and a T1w image.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/bl.app.3"><img src="https://img.shields.io/badge/Brainlife-bl.app.3-blue.svg" alt="Run on brainlife.io"></a>
  <a href="https://github.com/brainlife/app-dtiinit/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> 📍 **This branch, `1.6`, is the brainlife.io App dtiInit** ([doi:10.25663/bl.app.3](https://doi.org/10.25663/bl.app.3)).

This App runs [vistasoft dtiInit](https://github.com/vistalab/vistasoft/wiki/DWI-Initialization), a DWI preprocessing tool that can correct eddy currents and head motion and coregister the diffusion data to the T1-weighted anatomy. This preprocessing is required by many diffusion analyses, such as tensor fitting and tractography. dtiInit writes its results in the standard directory structure used by vistasoft applications (mrDiffusion, AFQ, LiFE and others); other Apps can use the aligned DWI output directly.

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Preprocesses single-shell DWI with vistasoft dtiInit (optional eddy current and motion correction, b-vector rotation) and aligns it to a T1-weighted image, producing a dtiInit directory and an aligned DWI.**

Runs vistasoft dtiInit (compiled MATLAB): optional eddy/motion correction, resampling to the chosen resolution, alignment to the ACPC-aligned T1 and tensor fitting, writing the standard dtiInit/dt6 directory used by mrDiffusion, AFQ and LiFE. The aligned DWI, bvecs and bvals are also exported as a dwi output. The README recommends eddyCorrect=-1 and both rotate options false for HCP data; set noDwiAlignment if the DWI is already aligned to the T1.

| | |
|---|---|
| 📥 **Inputs** | `neuro/dwi` · `neuro/anat/t1w` |
| 📤 **Outputs** | `neuro/dtiinit` · `neuro/dwi` |
| 🐳 **Container** | `brainlife/mcr:neurodebian1604-r2017a` |
| ⚙️ **Resources** | 8 CPUs · 15 GB memory · 6 h walltime |
| 🔗 **Run it** | [doi.org/10.25663/bl.app.3](https://doi.org/10.25663/bl.app.3) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` (single_shell) | yes | Single-shell DWI with bvecs and bvals to preprocess. Single shell (datatype tag single_shell). |
| `t1` | `neuro/anat/t1w` | yes | T1 image to align the output dwi data to. Should be ACPC aligned; dtiInit aligns the DWI to it. |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/dtiinit` | dtiInit directory (dt6.json/product.json, aligned DWI, tensor fit and transforms) in vistasoft layout. |
| `dwi` | `neuro/dwi` | Aligned DWI (dwi_aligned_trilin_noMEC) with its rotated bvecs and bvals. |

<details>
<summary><b>⚙️ Parameters</b> (6)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `phaseEncodeDir` | enum | `2` | Taken from the rawDti nifti field, you can specify it here if it does not exist. If you collected your DTI data using GE's ASSET, you may be prompted to provide phase-encode direction (1= L/R 'row', 2 = A/P 'col'). Information about this, as well as the b-value and gradient code, can befound in the dicom file header. Options: `2`, `1`, `3`. |
| `resolution` | string | `default` | enter the three values of the desired resolution separated by spaces |
| `rotateBvecsWithCanXform` | boolean | `true` | Rotate the bvectors according to the canonical xForm. You need to set this to true for Siemens data (such as HCP) and Philips (see mrDiffusion/dtiInit/dtiInit.m section VII) |
| `rotateBvecsWithRx` | boolean | `true` | Rotate the bvectors according to the prescription (see mrDiffusion/dtiInit/dtiInit.m section VII) |
| `eddyCorrect` | enum | `1` | do eddy current and motion correction Options: `-1`, `1`, `0`. |
| `noDwiAlignment` | boolean | `false` | Do not align the DWI data to T1. When True, the DWI data are considered already acpc aligned to T1 and have neurological orientation. The configuration of eddy correction is forced to -1 and Bvecs rotations to False. |

</details>

<!-- brainlife-app:end -->

## 🚀 Running the App

### ☁️ On brainlife.io

Open the App at [doi.org/10.25663/bl.app.3](https://doi.org/10.25663/bl.app.3), choose a single-shell DWI dataset (`neuro/dwi`, tag `single_shell`) and a T1-weighted image (preferably ACPC-aligned) from your project, set the options and press **Execute**. The App archives a `neuro/dtiinit` dataset and an aligned `neuro/dwi` dataset (tagged `dtiinit`) to your project.

The parameters map onto vistasoft's [`dtiInitParams`](https://github.com/vistalab/vistasoft/blob/master/mrDiffusion/dtiInit/dtiInitParams.m):

| Parameter | Meaning |
|---|---|
| `eddyCorrect` | `1` eddy current and motion correction (default), `0` motion correction only, `-1` none |
| `phaseEncodeDir` | phase-encode direction: `1` x (L/R), `2` y (A/P, default), `3` z |
| `rotateBvecsWithCanXform` | rotate the b-vectors by the canonical xform; needed for Siemens (e.g. HCP) and Philips data |
| `rotateBvecsWithRx` | rotate the b-vectors by the prescription |
| `resolution` | output voxel size as three values separated by spaces, or `default` |
| `noDwiAlignment` | treat the DWI as already ACPC-aligned to the T1 in neurological orientation; forces `eddyCorrect` to `-1` and both rotations off |

Recommended settings for HCP data: `eddyCorrect` = `-1`, `rotateBvecsWithCanXform` = `false`, `rotateBvecsWithRx` = `false`.

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). `main` runs the compiled MATLAB code in the `brainlife/mcr:neurodebian1604-r2017a` container, so no MATLAB licence is needed.

1. Clone this repository and check out the registered version (`git checkout 1.6`).
2. Create `config.json` with the paths to your inputs and the options you want:

   ```json
   {
       "dwi": "input/dwi/dwi.nii.gz",
       "bvecs": "input/dwi/dwi.bvecs",
       "bvals": "input/dwi/dwi.bvals",
       "t1": "input/anat/t1.nii.gz",
       "eddyCorrect": "1",
       "phaseEncodeDir": "2",
       "rotateBvecsWithRx": false,
       "rotateBvecsWithCanXform": false,
       "noDwiAlignment": false,
       "resolution": "default"
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

To run without containers you need MATLAB, [jsonlab](https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab-a-toolbox-to-encode-decode-json-files) and [vistasoft](https://github.com/vistalab/vistasoft/) on the MATLAB path; then run `dtiinit.m`.

### 🧪 Sample data

Download a sample DWI and T1 from brainlife.io with the [brainlife CLI](https://github.com/brainlife/cli):

```bash
npm install -g brainlife
bl login
mkdir input
bl dataset download 5a050a00eec2b300611abff3 && mv 5a050a00eec2b300611abff3 input/dwi
bl dataset download 5a050966eec2b300611abff2 && mv 5a050966eec2b300611abff2 input/anat
```

## 📦 Outputs

The working directory becomes the `neuro/dtiinit` output; its files are described in the [dtiInit documentation](https://github.com/vistalab/vistasoft/wiki/DWI-Initialization#youre-done).

```text
./
├── dti*/bin/                            b0, brainMask, wmMask, wmProb, tensors, vectorRGB, faStd, mdStd, pddDispersion
├── dt6.mat                              dtiInit summary (MATLAB)
├── product.json                         the same information as JSON (also copied to dt6.json)
├── dwi_aligned_*.nii.gz                 aligned DWI, with .bvecs and .bvals (name depends on the options)
└── dwi.nii.gz, dwi.bvecs, dwi.bvals     copy of the aligned DWI (the neuro/dwi output)
```

`product.json` lists the paths of the files above, for example:

```json
{
    "files": {
        "b0": "dti/bin/b0.nii.gz",
        "brainMask": "dti/bin/brainMask.nii.gz",
        "tensors": "dti/bin/tensors.nii.gz",
        "alignedDwRaw": "./dwi_aligned_trilin_noMEC.nii.gz",
        "alignedDwBvecs": "./dwi_aligned_trilin_noMEC.bvecs",
        "alignedDwBvals": "./dwi_aligned_trilin_noMEC.bvals"
    }
}
```

## 🩺 Troubleshooting

- **`failed to produce product.json`**: dtiInit did not finish. Check the log for the MATLAB error, make sure the bvecs and bvals match the DWI, and review the `phaseEncodeDir` and b-vector rotation options.
- **Multi-shell data**: this App takes single-shell DWI only (`single_shell` tag).

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- dtiInit. brainlife.io App. [doi:10.25663/bl.app.3](https://doi.org/10.25663/bl.app.3)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Franco Pestilli (project director)
- Lindsey Kitchell
- Soichi Hayashi

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

MIT.
