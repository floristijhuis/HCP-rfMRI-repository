<h3>About the atlas:</h3>

This folder contains the relevant files for the Brainnetome atlas, applied to the Human Connectome Project (Fan et al., 2016, doi: 10.1093/cercor/bhw157). The original files downloaded from https://atlas.brainnetome.org/download.html are fsaverage.BN_Atlas.32k_fs_LR.dlabel.nii (which only contains cortical regions) and BN_Atlas_246_2mm.nii.gz (which contains both cortical and subcortical regions) and BN_Atlas_246_LUT.txt.

In order to create an atlas in CIFTI format with both subcortical and cortical regions, the following steps were taken:
<ol>
	<li>Extract the subcortical regions from the NIFTI atlas<br>
		<code>fslmaths BN_Atlas_246_2mm.nii.gz -thr 211 BN_Atlas_246_2mm_subcortical.nii.gz</code></li>

<li>First, the BN_Atlas_246_LUT.txt file was split up into a cortical label file (BN_Atlas_labelannotation_210.txt) and subcortical label file (BN_Atlas_labelannotation_subcortex.txt) and reformatted to import it as a volume label into the subcortical BNA atlas in NIFTI format. Then, this label file was used to create a labeled atlas:<br>
<code>wb_command -volume-label-import BN_Atlas_246_2mm_subcortical.nii.gz BN_Atlas_labelannotation_subcortex.txt BN_Atlas_246_2mm_subcortical_labeled.nii.gz</code></li>
	

<li>The CIFTI cortical file had some issues with the labeling of the vertices and the regions (with some impossible regions that led to empty rows in the time series). Therefore, this was first fixed:
	<ol><li>The numbering of the vertices was first altered using [bna_atlas_correct_numbering.m](https://github.com/floristijhuis/HCPAgingFloris/blob/master/Scripts/bna_atlas_correct_numbering.m) (to put the vertices of the right hemisphere in the correct label)</li>
	<li>The label numbers were changed:<br> <code>wb_command -cifti-label-import fsaverage.BN_Atlas.32k_fs_LR_verticescorrect.dlabel.nii BN_Atlas_labelannotation_210.txt fsaverage.BN_Atlas.32k_fs_LR_verticeslabelscorrect.dlabel.nii</code></li></ol>

<li>Lastly, the correct cortical file was merged with the labeled subcortical file:<br>
<code>wb_command -cifti-create-dense-from-template 91282_Greyordinates.dscalar.nii fsaverage.BN_Atlas.32k_fs_LR_246regions.dlabel.nii -cifti fsaverage.BN_Atlas.32k_fs_LR_verticeslabelscorrect.dlabel.nii -volume-all BN_Atlas_246_2mm_subcortical_labeled.nii.gz</code></li></ol>

------------------------------------------------------------------------------------------

<h3>About the annotation:</h3>

All the annotated information about the regions can be found in the files BNA_subregions.xlsx and subregion_func_network_Yeo.csv on the official Brainnetome website (https://atlas.brainnetome.org/download.html). They are also findable in the brainGraph R-package in a convenient format.

