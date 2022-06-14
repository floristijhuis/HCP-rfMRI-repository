#!/bin/bash

# 2022/03/23
# F.Tijhuis 
# f.tijhuis@amsterdamumc.nl

# Requirements for this script
#  installed versions of: wb_command

# This script parcellates a (standardized and concatenated) scan (.dtseries.nii) into a (.ptseries.nii) and (.txt) file. You need to have an appropriate atlas (.dlabel.nii) in cifti format.

########## Defining variables - these need to be tweaked based on where your files are ###########

export PATH=/mnt/software/workbench/bin_rh_linux64:${PATH} #this needs to point to path where wb_command is installed

filepathhighest="/data/public_data/HCPAgingDerivatives" #this points to the folder where the 'derivatives' of the original data (i.e. the demeaned, normalized, and concatenated files) are stored

atlaspath="/Atlases/[ATLAS]/[ATLAS].dlabel.nii" #this needs to be altered to your specific atlas, needs to be a full file path and point to a .dlabel file
atlasname="[ATLAS]" #this can be altered and will end up in the name of the folders and parcellated files

########## Looping over the subjects and sessions ##########

now=$(date)
echo $now


for S in $filepathhighest/HCA*
do

	SUBJECT=`basename ${S%%}`

	for V in $S/*
	do

		VISIT=`basename ${V%%}`

		echo "Now working on Subject $SUBJECT during Visit $VISIT"
		echo

		for SESSION in "rfMRI_REST1" "rfMRI_REST2" #this makes sure to execute the same processing for both sessions (REST1 and REST2) separately. Can also be altered to do the parcellation for task data (e.g. "CARIT") or for all tasks present $V/*)
		do

			if [ -f $V/${SESSION}/${SUBJECT}_${VISIT}_${SESSION}_Atlas_MSMAll_hp0_clean.dtseries.nii ] #check to make sure that the file needed for the parcellation is present
			then

				echo "Now working on Session $SESSION"
				echo

				########## Parcellating  ##########

				echo "Now starting parcellation..."

				# 1. Parcellating the concatenated time series for the specific atlas chosen
				# https://www.humanconnectome.org/software/workbench-command/-cifti-parcellate
				# See /Atlases for the different atlases that can be used

				mkdir $V/${SESSION}/${atlasname}

				wb_command -cifti-parcellate $V/${SESSION}/${SUBJECT}_${VISIT}_${SESSION}_Atlas_MSMAll_hp0_clean.dtseries.nii $atlaspath COLUMN $V/${SESSION}/${atlasname}/${SUBJECT}_${VISIT}_${SESSION}_Atlas_MSMAll_hp0_clean_${atlasname}.ptseries.nii

				echo "Done with parcellation!"

				echo "Now starting conversion to .txt..."
				# 2. Converting the parcellated time series to a .txt file
				# https://www.humanconnectome.org/software/workbench-command/-cifti-convert

				wb_command -cifti-convert -to-text $V/${SESSION}/${atlasname}/${SUBJECT}_${VISIT}_${SESSION}_Atlas_MSMAll_hp0_clean_${atlasname}.ptseries.nii $V/${SESSION}/${atlasname}/${SUBJECT}_${VISIT}_${SESSION}_Atlas_MSMAll_hp0_clean_${atlasname}.txt

				echo "Done with conversion to .txt!"
				echo
				echo "Done with Session $SESSION!"
				echo

			else
				echo "Session $SESSION does not exist for $SUBJECT during $VISIT, SKIPPING..."

			fi

		done

		echo "Done with Visit $VISIT!"
		echo
		echo

	done

	echo "Done with Subject $SUBJECT!"
	echo
	echo

done

echo "Processing done!"

then=$(date)
	echo $then
