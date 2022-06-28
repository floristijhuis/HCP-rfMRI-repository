#!/bin/bash

# 2022/05/25
# F.Tijhuis 
# f.tijhuis@amsterdamumc.nl

# Requirements for this script
#  installed versions of: wb_command and AWS CLI (command line installer)
#  access to Connectome DB and a personal access key for the AWS S3 storage
#  configured/bucketed version of the HCP-YA database on your system (achieved using aws configure; see https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

# This script can be used to download HCP-YA scanning data from the server of Connectome DB and execute the recommended further preprocessing. The processing part of the script standardizes two separate scans and then concatenates them. Though we were primarily interested in concatenating resting-state scans, the script can be adapted for different purposes as well (e.g. for the concatenation of all task data).


########## Defining variables - these need to be tweaked based on where your files are ##########

export PATH=/mnt/software/workbench/bin_rh_linux64:${PATH} #this needs to point to path where wb_command is installed

tempfolder="[TEMPFOLDER]" #this is the folder where the intermediate files will be stored
outputpathhighest="[OUTPUTDIRECTORY]" #where you want to put the output, needs to exist

subjectlist="[SUBJECTLIST].txt" #this needs to point to a txt file that contains the subject id's that you want to process/download, e.g. 100206. The file we used included all subjects with rfMRI scans 

declare -A atlasdict #this includes all the atlases that you want to use for parcellation and will be looped over later. The key indicates the file path to the atlas (needs to refer to a .dlabel.nii atlas) and the value describes the custom name of the output directories/files (this can be selected by you)
atlasdict=( ["[ATLASPATH]/Atlases/Schaefer/100regions7networks/Schaefer2018_100Parcels_7Networks_order_Tian_Subcortex_S1_3T.dlabel.nii"]="Schaefer2018_100Parcels_7Networks_Tian_Subcortex_S1_3T"
["[ATLASPATH]/Atlases/Schaefer/1000regions7networks/Schaefer2018_1000Parcels_7Networks_order_Tian_Subcortex_S1_3T.dlabel.nii"]="Schaefer2018_1000Parcels_7Networks_Tian_Subcortex_S1_3T"
["[ATLASPATH]/Atlases/Schaefer/400regions7networks/Schaefer2018_400Parcels_7Networks_order_Tian_Subcortex_S1.dlabel.nii"]="Schaefer2018_400Parcels_7Networks_Tian_Subcortex_S1_3T"
["[ATLASPATH]/Atlases/Brainnetome/fsaverage.BN_Atlas.32k_fs_LR_246regions.dlabel.nii"]="fsaverage.BN_Atlas.32k_fs_LR_246regions"
["[ATLASPATH]/Atlases/Gordon/Gordon333.32k_fs_LR_Tian_Subcortex_S1.dlabel.nii"]="Gordon333.32k_fs_LR_Tian_Subcortex_S1_3T"
["[ATLASPATH]/Atlases/Glasser/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors_with_Atlas_ROIs2.32k_fs_LR.dlabel.nii"]="GlasserFreesurfer")

########## Looping over the subjects and the sessions ##########

now=$(date)
echo $now

while read line # This loops over all the lines of the subjectlist file and executes the downloading, normalization, concatenation, and parcellation for each of these subjects separately
do

	SUBJECT=$line

	echo "Now working on Subject ${SUBJECT}"
	echo

	for SESSION in "rfMRI_REST1" "rfMRI_REST2" # This makes sure to execute the same processing for both sessions (REST1 and REST2) separately
	do
		echo "Now working on Session ${SESSION}"
		echo
		echo "Starting Download of scans from Connectome DB..."

		########## Download the LR and RL scans (both phase encoding directions) from the Connectome DB server using curl ##########
		########## https://wiki.humanconnectome.org/pages/viewpage.action?pageId=77365252 ###########

		file_relative_path_lr=MNINonLinear/Results/${SESSION}_LR/${SESSION}_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii
		file_relative_path_rl=MNINonLinear/Results/${SESSION}_RL/${SESSION}_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii

		aws s3 cp s3://hcp-openaccess/HCP_1200/$SUBJECT/$file_relative_path_lr $tempfolder/${SUBJECT}_${SESSION}_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii --quiet
		aws s3 cp s3://hcp-openaccess/HCP_1200/$SUBJECT/$file_relative_path_rl $tempfolder/${SUBJECT}_${SESSION}_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii --quiet

		if [ -f $tempfolder/${SUBJECT}_${SESSION}_LR_Atlas_MSMAll_hp2000_clean.dtseries.nii ] && \
			[ -f $tempfolder/${SUBJECT}_${SESSION}_RL_Atlas_MSMAll_hp2000_clean.dtseries.nii ] # Script will only proceed if the session as well as both of the phase encoding directions have been properly downloaded from the server. If you also want to include subjects with only 1 phase encoding direction, you can edit this to make it more liberal (concatenation will not be necessary, demeaning and variance normalization can still be done)

		then

			mkdir $outputpathhighest/${SUBJECT}
			mkdir $outputpathhighest/${SUBJECT}/${SESSION}
			outputpathsession=$outputpathhighest/${SUBJECT}/${SESSION}

			########## Preprocessing ###########

			echo "Starting demeaning, variance-normalization, and concatenating..."
			echo
			# Demean, Variance-Normalize time series from 2 different phase encoding directions individually, then concatenate them
			# https://wiki.humanconnectome.org/display/PublicData/HCP+Users+FAQ
			# https://www.humanconnectome.org/software/workbench-command/-cifti-math
			# https://www.humanconnectome.org/software/workbench-command/-cifti-merge

			for PED in "LR" "RL" # This makes sure to execute demeaning and variance normalization for both phase encoding directions separately
			do

				echo "Demeaning and variance normalization of ${SESSION}_${PED}..."
				wb_command -cifti-reduce $tempfolder/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp2000_clean.dtseries.nii MEAN $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp2000_clean_mean.dscalar.nii
				wb_command -cifti-reduce $tempfolder/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp2000_clean.dtseries.nii STDEV $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp2000_clean_stdev.dscalar.nii

				wb_command -cifti-math '((x-mean)/stdev)' $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp2000_clean_demeaned_vnormalized.dtseries.nii -fixnan 0 -var x $tempfolder/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp2000_clean.dtseries.nii -var mean $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp2000_clean_mean.dscalar.nii -select 1 1 -repeat -var stdev $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp2000_clean_stdev.dscalar.nii -select 1 1 -repeat

				echo

			done

			echo "Concatenating ${SESSION}_LR and ${SESSION}_RL..."
			wb_command -cifti-merge $outputpathsession/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp2000_clean.dtseries.nii -cifti $outputpathsession/${SUBJECT}_${SESSION}_LR_Atlas_MSMAll_hp2000_clean_demeaned_vnormalized.dtseries.nii -cifti $outputpathsession/${SUBJECT}_${SESSION}_RL_Atlas_MSMAll_hp2000_clean_demeaned_vnormalized.dtseries.nii

			echo "Done with demeaning, variance-normalization, and concatenation!"
			echo

			########## Preprocessing ###########
			echo "Now starting parcellation..."

			for item in "${!atlasdict[@]}"
			do
				atlasname=${atlasdict[$item]}
				atlaspath=$item
				
				# 1. Parcellating the concatenated time series for the specific atlas chosen
				# https://www.humanconnectome.org/software/workbench-command/-cifti-parcellate
				# See /Atlases for the different atlases that can be used

				echo "Now parcellating time series using atlas $atlasname..."

				mkdir $outputpathsession/${atlasname}

				wb_command -cifti-parcellate $outputpathsession/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp2000_clean.dtseries.nii $atlaspath COLUMN $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp2000_clean_${atlasname}_timeseries.ptseries.nii

				echo "Done with parcellation for atlas $atlasname!"

				# 2. Converting the parcellated time series to a .txt file
				# https://www.humanconnectome.org/software/workbench-command/-cifti-convert
				
				echo "Now starting conversion of time series to .txt..."

				wb_command -cifti-convert -to-text $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp2000_clean_${atlasname}_timeseries.ptseries.nii $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp2000_clean_${atlasname}_timeseries.txt

				echo "Done with conversion to .txt!"
				echo
				
				# 3. Creating the connectivity matrix using simple Pearson correlation
				# https://www.humanconnectome.org/software/workbench-command/-cifti-correlate
				# This is optional; for some applications you may only need the time series (e.g. if you want to create the connectivity matrices in a different way. In this case, comment out section 3 and 4

				echo "Now creating connectivity matrix using Pearson correlation..."
				
				wb_command -cifti-correlation $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp2000_clean_${atlasname}_timeseries.ptseries.nii $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp2000_clean_${atlasname}_connmatrix.pconn.nii

				echo "Done with parcellation for atlas $atlasname!"

				# 4. Converting the connectivity matrix to a .txt file
				# https://www.humanconnectome.org/software/workbench-command/-cifti-convert

				echo "Now starting conversion of connectivity matrix to .txt..."

				wb_command -cifti-convert -to-text $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp2000_clean_${atlasname}_connmatrix.pconn.nii  $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp2000_clean_${atlasname}_connmatrix.txt

				echo "Done with conversion to .txt!"
				echo
			done

			echo "Done with parcellation"
			echo
			
			rm $outputpathsession/$SUBJECT*
			
			echo "Done with Session $SESSION!"
			echo

		else
			echo "Session $SESSION is not complete for $SUBJECT, SKIPPING..."

		fi

	done

	echo "Done with Subject $SUBJECT!"
	echo
	echo

	rm $tempfolder/*

done < $subjectlist

echo "Processing done!"

then=$(date)
echo $then
