#!/bin/bash

# 2021/12/21
# F.Tijhuis 
# f.tijhuis@amsterdamumc.nl

# Requirements for this script
#  installed versions of: fsl

# This script extracts the coordinates from a nifti version of the Glasser atlas to put in an annotation file for plotting purposes. This can be done for other atlases as well, provided you have them in a nifti format and have the appropriate region numbers. For more information on where these files came from, see /Atlases/Glasser/info/README.md

########## Defining variables - these need to be tweaked based on where your files are ###########

export PATH=/mnt/software/fsl-5.0.9/bin/fsl:${PATH} #this needs to point to path where fsl is installed

inputpath=/Atlases/Glasser/info
outputpath=/Atlases/Glasser/annotation

########## Extracting coordinates from left hemisphere, right hemisphere, and subcortex ##########

for i in {1..180}
do

fslstats $inputpath/MMP_in_MNI_corr.nii.gz -l `expr $i - 1` -u `expr $i + 1` -c >> $outputpath/GlasserFreesurfer_positions.txt

done

for i in {201..380}
do

fslstats $inputpath/MMP_in_MNI_corr.nii.gz -l `expr $i - 1` -u `expr $i + 1` -c >> $outputpath/GlasserFreesurfer_positions.txt

done

for i in {361..379}
do

fslstats $inputpath/FreesurferSubcortex.nii -l `expr $i - 1` -u `expr $i + 1` -c >> $outputpath/GlasserFreesurfer_positions.txt

done
