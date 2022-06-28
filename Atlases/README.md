<h3>Brain Atlases for Parcellation</h3>

This folder contains the atlases that were used to parcellate the data from the Human Connectome Project, as well as annotation files that describe several features of the atlas. Moreover, it contains several README.md files that explain how the atlases and annotation files were downloaded or otherwise obtained. Each atlas-specific folder contains at least the following files:

<ol>
  <li>Atlas: The specific atlas in CIFTI format. The CIFTI format was used in order to ensure compatibility with the data from the HCP. Reasons for picking these specific atlases are summarized in the manual present in the root folder.</li>

  <li>atlas_positions.txt: A .txt file in which each line describes the x,y,z-coordinates of one of the brain regions of the atlas in MNI space (2mm resolution).</li>
  
  <li>atlas_region_names_full.txt: A .txt file specifying the full names of the brain regions in the atlas. Each line corresponds to one brain region.</li>
  
  <li>atlas_region_names_short.txt: A .txt file specifying the shortened names of the brain regions in the atlas. Each line corresponds to one brain region.</li>
    
  <li>atlas_subnet_order_names.txt: A .txt file specifying the membership of each of the brain regions in the atlas to a resting-state subnetwork. Unless otherwise specified, the names refer to the resting-state networks coined by Yeo et al. (2011, doi: 10.1152/jn.00338.2011).</li>

  <li>atlas_subnet_order_colors.txt: A .txt file that can be used for visualization purposes as it describes the standard colors that correspond to the resting-state subnetworks (see Yeo et al. 2011).</li>


