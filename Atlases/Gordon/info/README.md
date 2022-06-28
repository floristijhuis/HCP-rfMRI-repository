<h5>About the atlas:</h5>

This folder contains the relevant files for the Gordon atlas, applied to the Human Connectome Project (Gordon et al., 2016, doi: 10.1093/cercor/bhu239). The cortical Gordon atlas was combined with the S1-version of the Tian subcortical atlas (Tian et al., 2020, doi: 10.1038/s41593-020-00711-6).

The combined cortical and subcortical atlas could directly be downloaded from https://github.com/yetianmed/subcortex/tree/master/Group-Parcellation.

------------------------------------------------------------------------------------------

<h5>About the annotation:</h5>

<ul>
  <li><em>Gordon</em>: Most of the information (network membership, name, coordinates) for the cortical regions can be found in the 'Parcels.xlsx' file that can be downloaded from https://sites.wustl.edu/petersenschlaggarlab/parcels-19cwpgu/.

**NOTE**
<ol>
  <li>The parcel names are not really anatomically informative. The R-Package brainGraph contains some more anatomically accurate labels for each region.</li>
  <li>The subnetworks that Gordon et al. use do not correspond to the 7 RSNs by Yeo et al, as Gordon et al. use their own classification and definition of resting-state subnetworks. In this annotation file, the subnetworks and colors that they used in the original paper were used. This leads to different names for the networks and colors in the subnet_color.txt file that do not all correspond to the Yeo networks.</li></ol>

  <li><em>Tian</em>: https://github.com/yetianmed/subcortex/tree/master/Group-Parcellation/3T/Subcortex-Only was used to obtain the subcortical region names and coordinates.</li></ul>
