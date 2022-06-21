This folder contains the scripts used for processing the HCP data. There are 4 main scripts, with the following purposes:
<ol><h3>Atlas-related scripts:</h3>
    <li>COGparcelsGlasser.sh: This script was used to find the x,y,z-coordinates for the brain regions used in the Glasser Atlas (which were not provided by its creators). For more information, see /Atlases/Glasser/info/README.md</li>
    <li>bna_atlas_correct_numbering_vertices.m: This script was used to adapt the numbering of the regions of the Brainnetome atlas so that it could be used as a CIFTI file in combination with wb_command</li>
 <h3>Processing-related scripts:</h3>
    <li>rsfMRI_Download_Normalization_Concatenation_Parcellation_HCPAging.sh: This is the script that is used to generate the time series for the subjects from the HCP-Aging database.</li>
    <li>rsfMRI_Download_Normalization_Concatenation_Parcellation_HCPYA.sh: This is the script that is used to generate the time series for the subjects from the HCP-Young Adult database.</li>

<br/>
The above 2 scripts perform several processing steps while looping over a list of subjects and their associated resting-state scans. For an example of a subject list for those subjects with resting-state scans, refer to /Files/HCPAging_SubjectList.txt and /Files/HCPYA_Subjectlist.txt. The script performs the following steps:
<ol>
    <li> Downloading the subject data from the server (specifically, for each complete resting state scan it downloads 2 sub-scans with opposite phase encoding directions</li>
    <li> Normalizing the 2 discontinuous sub-scans with opposite phase encoding directions using demeaning and variance normalization</li>
    <li> Concatenating the 2 sub-scans with opposite phase encoding directions </li>
    <li> Parcellating the scan with different pre-specified .dlabel.nii atlases and saving them as a .ptseries.nii file and .txt file. </ol>
For more information about these processing steps, refer to /Files/HCPManual.pdf
</ol>
