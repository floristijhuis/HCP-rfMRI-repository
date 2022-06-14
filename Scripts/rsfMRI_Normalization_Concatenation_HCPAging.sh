#!/bin/bash

# 2022/03/23
# F.Tijhuis 
# f.tijhuis@amsterdamumc.nl

# Requirements for this script
#  installed versions of: wb_command

# This script executes the recommended further preprocessing of HCP-Aging data after it was downloaded. It is meant to standardize two separate scans and then concatenate them. For our purposes, this was only relevant for resting-state scans but the script can be adapted for different purposes as well (e.g. for the concatenation of all task data).

########## Defining variables - these need to be tweaked based on where your files are ##########

export PATH=/mnt/software/workbench/bin_rh_linux64:${PATH} #this needs to point to path where wb_command is installed

inputpathhighest="/data/public_data/HCPAging/fmriresults01" #fmriresults01 is a standard folder in the HCP file organisation, it contains subject-specific folders
outputpathhighest="/data/public_data/HCPAgingDerivatives" #where you want to put the output, needs to exist

########## Looping over the subjects and the sessions ##########

now=$(date)
echo $now


for S in $inputpathhighest/HCA* # It now processes both V1 and V2 if they are present in the folder, but this can be changed easily (e.g. HCA*V2*)
do

	inputpathsubject="$S/MNINonLinear/Results"
	basename=`basename ${S%%}`
	SUBJECTVISIT=${basename::-3} 
	SUBJECT=${basename::-6}
	VISIT=${SUBJECTVISIT: -2}

	echo "Now working on Subject ${SUBJECT} during visit ${VISIT}"
	echo

	mkdir $outputpathhighest/${SUBJECT}
	mkdir $outputpathhighest/${SUBJECT}/${VISIT}

	for SESSION in "rfMRI_REST1" "rfMRI_REST2" # This makes sure to execute the same processing for both sessions (REST1 and REST2) separately
	do

		if [ -d $inputpathsubject/${SESSION}_AP ] && [ -d $inputpathsubject/${SESSION}_PA ] # Script will only proceed if the session as well as both of the phase encoding directions are present in the data. If you also want to include subjects with only 1 phase encoding direction, you can edit this to make it more liberal (concatenation will not be necessary, demeaning and variance normalization can still be done)
		then

			echo "Now working on Session ${SESSION}"
			echo

			outputpathsession="$outputpathhighest/${SUBJECT}/${VISIT}/${SESSION}"

			mkdir $outputpathsession

			########## Preprocessing ##########

			echo "Starting demeaning, variance-normalization, and concatenating..."
			echo
			# Demean, Variance-Normalize time series from 2 different phase encoding directions individually, then concatenate them
			# https://wiki.humanconnectome.org/display/PublicData/HCP+Users+FAQ
			# https://www.humanconnectome.org/software/workbench-command/-cifti-math
			# https://www.humanconnectome.org/software/workbench-command/-cifti-merge

			for PED in "AP" "PA" # This makes sure to execute demeaning and variance normalization for both phase encoding directions separately
			do

				echo "Demeaning and variance normalization of ${SESSION}_${PED}..."
				wb_command -cifti-reduce $inputpathsubject/${SESSION}_${PED}/${SESSION}_${PED}_Atlas_MSMAll_hp0_clean.dtseries.nii MEAN $outputpathsession/${SUBJECTVISIT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_mean.dscalar.nii
				wb_command -cifti-reduce $inputpathsubject/${SESSION}_${PED}/${SESSION}_${PED}_Atlas_MSMAll_hp0_clean.dtseries.nii STDEV $outputpathsession/${SUBJECTVISIT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_stdev.dscalar.nii

				wb_command -cifti-math '((x-mean)/stdev)' $outputpathsession/${SUBJECTVISIT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_demeaned_vnormalized.dtseries.nii -fixnan 0 -var x $inputpathsubject/${SESSION}_${PED}/${SESSION}_${PED}_Atlas_MSMAll_hp0_clean.dtseries.nii -var mean $outputpathsession/${SUBJECTVISIT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_mean.dscalar.nii -select 1 1 -repeat -var stdev $outputpathsession/${SUBJECTVISIT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_stdev.dscalar.nii -select 1 1 -repeat

				echo

			done

			echo "Concatenating ${SESSION}_AP and ${SESSION}_PA..."
			wb_command -cifti-merge $outputpathsession/${SUBJECTVISIT}_${SESSION}_Atlas_MSMAll_hp0_clean.dtseries.nii -cifti $outputpathsession/${SUBJECTVISIT}_${SESSION}_AP_Atlas_MSMAll_hp0_clean_demeaned_vnormalized.dtseries.nii -cifti $outputpathsession/${SUBJECTVISIT}_${SESSION}_PA_Atlas_MSMAll_hp0_clean_demeaned_vnormalized.dtseries.nii

			echo "Done with demeaning, variance-normalization, and concatenation!"
			echo
			echo "Done with Session $SESSION!"
			echo

		else
			echo "Session $SESSION does not exist for $SUBJECT, SKIPPING..."

		fi

	done

	echo "Done with Subject $SUBJECT!"
	echo
	echo

done

echo "Processing done!"

then=$(date)
	echo $then
