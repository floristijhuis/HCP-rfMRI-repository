<h3>About the atlas:</h3>

This folder contains the relevant files for the Schaefer atlas, applied to the Human Connectome Project (Schaefer et al., 2018, doi: 10.1093/cercor/bhx179). This atlas was used in 3 different resolutions (100 regions, 400 regions, 1000 regions). It was combined with the S1-version of the Tian subcortical atlas (Tian et al., 2020, doi: 10.1038/s41593-020-00711-6). For more information about why these parameters were picked, see USERLINK/ATLASES

The combined cortical and subcortical atlas could directly be downloaded for the 400-region resolution from https://github.com/yetianmed/subcortex/tree/master/Group-Parcellation. For the other resolutions, it had to be constructed manually by combining the Schafer atlas in the desired resolution (https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal/Parcellations) with the subcortical atlas (also downloaded from the Tian Github page). This was performed in the following way:

<ol>
  <li>Add label file to Tian S1 subcortical atlas (in volume space):<br>
<code>wb_command -volume-label-import Tian_Subcortex_S1_3T.nii.gz Tian_Subcortex_S1_3T_labelannotation.txt Tian_Subcortex_S1_3T_labeled.nii.gz</code></li>
  
  <li>Add the labeled Tian S1 subcortical atlas to the cortical Schafer atlas in the desired resolution (100 or 1000 regions):<br><code>
  wb_command -cifti-create-dense-from-template 91282_Greyordinates.dscalar.nii Schaefer2018_<em>RESOLUTION</em>Parcels_7Networks_order_Tian_Subcortex_S1_3T.dlabel.nii -cifti Schaefer2018_<em>RESOLUTION</em>Parcels_7Networks_order.dlabel.nii -volume-all Tian_Subcortex_S1_3T_labeled.nii.gz</code></li></ol>

------------------------------------------------------------------------------------------

<h3>About the annotation:</h3>

All the annotated information about the names and subnetwork membership of the regions can be found on the respective GitHub pages of the Schaefer and Tian atlases:

  <ul><li><em>Schaefer</em>: https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal/Parcellations/HCP/fslr32k/cifti for region names and subnetwork membership, and https://github.com/ThomasYeoLab/CBIG/tree/master/stable_projects/brain_parcellation/Schaefer2018_LocalGlobal/Parcellations/MNI/Centroid_coordinates for region coordinates</li>
    <li><em>Tian</em>: https://github.com/yetianmed/subcortex/tree/master/Group-Parcellation/3T/Subcortex-Only for the region names and coordinates.</li></ul>
