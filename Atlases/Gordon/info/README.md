<h5>About the atlas:</h5>

This folder contains the relevant files for the Gordon atlas, applied to the Human Connectome Project (Gordon et al., 2016, doi: 10.1093/cercor/bhu239). The cortical Gordon atlas was combined with the S1-version of the Tian subcortical atlas (Tian et al., 2020, doi: 10.1038/s41593-020-00711-6). For more information about the combination of these atlases, see USERLINK/ATLASES

The combined cortical and subcortical atlas could directly be downloaded from https://github.com/yetianmed/subcortex/tree/master/Group-Parcellation.

------------------------------------------------------------------------------------------

<h5>About the annotation:</h5>

<ul>
  <li><em>Gordon</em>: Most of the information (network membership, name, coordinates) for the cortical regions can be found in the 'Parcels.xlsx' file that can be downloaded from https://sites.wustl.edu/petersenschlaggarlab/parcels-19cwpgu/.

**NOTE**
<ol>
  <li>The parcel names are not really anatomically informative. The R-Package brainGraph contains some more anatomically accurate labels for each region.</li>
  <li>The subnetworks that Gordon et al. use do not correspond to the 7 RSNs by Yeo et al. In this annotation file, the subnetworks and colors that they used in the original paper were used. This leads to different names for the networks and colors in the subnet_color.txt file that do not all correspond to the Yeo networks. If you truly want to map the parcels onto Yeo networks (not recommended), you can use the surfacenode_to_rsn_assignment.m script in USERELATIVELINK. Briefly, this script loops over the vertices that belong to a region in the Gordon atlas and checks which RSN they belong to in the RSN parcellation in surface space. Then, the region was assigned to the RSN that entailed the largest number of vertices in the Gordon parcel (this strategy was also used for the Glasser atlas in Byrge and Kennedy, 2019 (https://doi.org/10.1162/netn_a_00068). For more information about this procedure, see the notes in this script.</li></ol>

  <li><em>Tian</em>: https://github.com/yetianmed/subcortex/tree/master/Group-Parcellation/3T/Subcortex-Only was used to obtain the subcortical region names and coordinates.</li></ul>
