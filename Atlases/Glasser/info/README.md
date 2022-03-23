<h3>About the atlas:</h3>

This folder contains the relevant files for the Glasser HCP_MMP1.0 atlas, applied to the Human Connectome Project (Glasser et al., 2017, doi: 10.1038/nature18933). The original atlas files were downloaded from https://balsa.wustl.edu/file/87B9N (Cortical MMP1.0 atlas + Freesurfer Subcortical regions). 

------------------------------------------------------------------------------------------

<h3>About the annotation:</h3>

<ol>
  <li>Some generally helpful files that include the names of the regions can be found on https://neuroimaging-core-docs.readthedocs.io/en/latest/pages/atlases.html. More anatomical information about the regions can be found on https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4990127/bin/NIHMS68870-supplement-Neuroanatomical_Supplementary_Results.pdf.</li>

  <li>The parcel coordinates needed to be generated manually using FSL and a complete atlas in NIFTI file format. In order to do so, several steps were taken:

First, the Glasser cortical atlas in NIFTI format was downloaded from https://neurovault.org/collections/1549/. The Freesurfer subcortical atlas was obtained after separating it from the complete atlas in CIFTI format:

<code>wb_command -cifti-separate Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors_with_Atlas_ROIs2.32k_fs_LR.dlabel.nii COLUMN -volume-all FreesurferSubcortex.nii</code>

Then, the coordinates were obtained and put in the annotation file using RELATIVELINK/DATE_COGparcels.sh</li>

  <li>The ascription of the regions to the Yeo subnetworks was taken from https://brainlab.sitehost.iu.edu/resources/hcp_mmp10_yeo7_modes.pdf, based on the method described in Byrge and Kennedy, 2019 (https://doi.org/10.1162/netn_a_00068)</li>
