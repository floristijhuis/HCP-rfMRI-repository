#!/bin/bash

# 2022/06/14
# F.Tijhuis 
# f.tijhuis@amsterdamumc.nl

# Requirements for this script
#  installed versions of: wb_command and nda-tools (python package)
#  a username/password combination to access the HCP-Aging data and a data package linked to your account containing the HCP-Aging (rfMRI) files

# This script can be used to download HCP-Aging resting-state scans from the NDA server, execute the recommended further preprocessing, and parcellate the time series using pre-made CIFTI atlases. The processing part of the script standardizes two separate scans and then concatenates them. Though we were primarily interested in concatenating resting-state scans, the script can be adapted for different purposes as well (e.g. for the concatenation of all task data). Moreover, the atlasdictionary can be altered to yield time series from different parcellations as well.


########## Defining variables - these need to be tweaked based on where your files are ##########

export PATH=/mnt/software/workbench/bin_rh_linux64:${PATH} #this needs to point to path where wb_command is installed

tempfolder="/data/KNW/f.tijhuis/temp" #this is the folder where the intermediate files are stored
outputpathhighest="/data/KNW/f.tijhuis/playground" #where you want to put the output, needs to exist

subjectlist="/data/KNW/f.tijhuis/playground/HCPAgingSubjects2.txt" #this needs to point to a txt file that contains the subject id's that you want to process/download, e.g. HCA6002236_V1_MR. The file we used included all subjects with rfMRI scans.
datastructuremanifest="/data/KNW/f.tijhuis/playground/HCPAgingMetaData/datastructure_manifest.txt" #this is a pre-downloaded file that contains the full file path of all HCP Aging files on the NDA server

ndausername="ftijhuis" 
ndapassword="Scha3p19!"
datapackage="1194773" #this is the data package number corresponding to the rfMRIpreprocessed data package in NDA (can be looked up in your account). this data package contains all the necessary files

declare -A atlasdict #this includes all the atlases that you want to use for parcellation and will be looped over later. It includes both the file path (needs to refer to a .dlabel.nii atlas) and the custom name of the output folders containing the time series (this can be selected by you)
atlasdict=( ["/data/KNW/f.tijhuis/Atlases/Schaefer/100regions7networks/Schaefer2018_100Parcels_7Networks_order_Tian_Subcortex_S1_3T.dlabel.nii"]="Schaefer2018_100Parcels_7Networks_Tian_Subcortex_S1_3T"
["/data/KNW/f.tijhuis/Atlases/Schaefer/1000regions7networks/Schaefer2018_1000Parcels_7Networks_order_Tian_Subcortex_S1_3T.dlabel.nii"]="Schaefer2018_1000Parcels_7Networks_Tian_Subcortex_S1_3T"
["/data/KNW/f.tijhuis/Atlases/Schaefer/400regions7networks/Schaefer2018_400Parcels_7Networks_order_Tian_Subcortex_S1.dlabel.nii"]="Schaefer2018_400Parcels_7Networks_Tian_Subcortex_S1_3T"
["/data/KNW/f.tijhuis/Atlases/Brainnetome/fsaverage.BN_Atlas.32k_fs_LR_246regions.dlabel.nii"]="fsaverage.BN_Atlas.32k_fs_LR_246regions"
["/data/KNW/f.tijhuis/Atlases/Gordon/Gordon333.32k_fs_LR_Tian_Subcortex_S1.dlabel.nii"]="Gordon333.32k_fs_LR_Tian_Subcortex_S1_3T"
["/data/KNW/f.tijhuis/Atlases/Glasser/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors_with_Atlas_ROIs2.32k_fs_LR.dlabel.nii"]="GlasserFreesurfer")

########## Looping over the subjects and the sessions ##########

now=$(date)
echo $now

while read line # This loops over all the lines of the subjectlist file and executes the downloading and normalization for each of these subjects separately
do

	S=$line
        SUBJECTVISIT=${S::-3} 
	SUBJECT=${S::-6} # this refers to just the subject ID
	VISIT=${SUBJECTVISIT: -2} # visit refers to either V1 or V2 (longitudinal subset of subjects)

	echo "Now working on subject ${SUBJECT} during visit ${VISIT}"
	echo

	for SESSION in "rfMRI_REST1" "rfMRI_REST2" # This makes sure to execute the same processing for both sessions (REST1 and REST2) separately
	do
		echo "Now working on Session ${SESSION}"
		echo
		echo "Starting Download of scans from the NDA server..."

		########## Download the AP and PA scans (both phase encoding directions) from the NDA server ##########
		########## https://wiki.humanconnectome.org/display/PublicData/How+to+get+data+from+the+NDA+using+command+line+tools ###########

                file_relative_path_ap=`sed -e 's/^"//' -e 's/"$//' <<<"$(grep -i $S $datastructuremanifest | grep -i ${SESSION}_AP_Atlas_MSMAll_hp0_clean.dtseries.nii | cut -f6)"` #this line of code looks up the full NDA file path for the rfMRI scan in the AP direction for the current session (if it exists)
                file_relative_path_pa=`sed -e 's/^"//' -e 's/"$//' <<<"$(grep -i $S $datastructuremanifest | grep -i ${SESSION}_PA_Atlas_MSMAll_hp0_clean.dtseries.nii | cut -f6)"` #this line of code looks up the full NDA file path for the rfMRI scan in the AP direction for the current session (if it exists)

		if [ ! -z "$file_relative_path_ap" ] && [ ! -z "$file_relative_path_ap" ] # Script will only proceed if the session as well as both of the phase encoding directions have been properly downloaded from the server. If you also want to include subjects with only 1 phase encoding direction, you can edit this to make it more liberal (concatenation will not be necessary, demeaning and variance normalization can still be done)

	        then

                downloadcmd $file_relative_path_ap -u $ndausername -p $ndapassword -d $tempfolder -dp $datapackage -q
                mv ${tempfolder}/fmriresults01/$S/MNINonLinear/Results/${SESSION}_AP/${SESSION}_AP_Atlas_MSMAll_hp0_clean.dtseries.nii $tempfolder/${SUBJECT}_${SESSION}_AP_Atlas_MSMAll_hp0_clean.dtseries.nii

		downloadcmd $file_relative_path_pa -u $ndausername -p $ndapassword -d $tempfolder -dp $datapackage -q
                mv ${tempfolder}/fmriresults01/$S/MNINonLinear/Results/${SESSION}_PA/${SESSION}_PA_Atlas_MSMAll_hp0_clean.dtseries.nii $tempfolder/${SUBJECT}_${SESSION}_PA_Atlas_MSMAll_hp0_clean.dtseries.nii

			mkdir $outputpathhighest/${SUBJECT}
                	mkdir $outputpathhighest/${SUBJECT}/${VISIT}
			mkdir $outputpathhighest/${SUBJECT}/${VISIT}/${SESSION}
			outputpathsession=$outputpathhighest/${SUBJECT}/${VISIT}/${SESSION}
               
			########## Preprocessing ###########

			echo "Starting demeaning, variance-normalization, and concatenating..."
			echo
			# Demean, Variance-Normalize time series from 2 different phase encoding directions individually, then concatenate them
			# https://wiki.humanconnectome.org/display/PublicData/HCP+Users+FAQ
			# https://www.humanconnectome.org/software/workbench-command/-cifti-math
			# https://www.humanconnectome.org/software/workbench-command/-cifti-merge

			for PED in "AP" "PA" # This makes sure to execute demeaning and variance normalization for both phase encoding directions separately
			do

				echo "Demeaning and variance normalization of ${SESSION}_${PED}..."
				wb_command -cifti-reduce $tempfolder/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean.dtseries.nii MEAN $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_mean.dscalar.nii
				wb_command -cifti-reduce $tempfolder/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean.dtseries.nii STDEV $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_stdev.dscalar.nii

				wb_command -cifti-math '((x-mean)/stdev)' $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_demeaned_vnormalized.dtseries.nii -fixnan 0 -var x $tempfolder/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean.dtseries.nii -var mean $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_mean.dscalar.nii -select 1 1 -repeat -var stdev $outputpathsession/${SUBJECT}_${SESSION}_${PED}_Atlas_MSMAll_hp0_clean_stdev.dscalar.nii -select 1 1 -repeat

				echo

			done

			echo "Concatenating ${SESSION}_AP and ${SESSION}_PA..."
			wb_command -cifti-merge $outputpathsession/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp0_clean.dtseries.nii -cifti $outputpathsession/${SUBJECT}_${SESSION}_AP_Atlas_MSMAll_hp0_clean_demeaned_vnormalized.dtseries.nii -cifti $outputpathsession/${SUBJECT}_${SESSION}_PA_Atlas_MSMAll_hp0_clean_demeaned_vnormalized.dtseries.nii

			echo "Done with demeaning, variance-normalization, and concatenation!"
			echo

			########## Parcellating ###########
			echo "Now starting parcellation..."

			for item in "${!atlasdict[@]}"
			do
				atlasname=${atlasdict[$item]}
				atlaspath=$item

				echo "Now parcellating using atlas $atlasname..."

				# 1. Parcellating the concatenated time series for the specific atlas chosen
				# https://www.humanconnectome.org/software/workbench-command/-cifti-parcellate
				# See /Atlases for the different atlases that can be used

				mkdir $outputpathsession/${atlasname}

				wb_command -cifti-parcellate $outputpathsession/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp0_clean.dtseries.nii $atlaspath COLUMN $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp0_clean_${atlasname}.ptseries.nii

				echo "Done with parcellation for atlas $atlasname!"

				echo "Now starting conversion to .txt..."
				# 2. Converting the parcellated time series to a .txt file
				# https://www.humanconnectome.org/software/workbench-command/-cifti-convert

				wb_command -cifti-convert -to-text $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp0_clean_${atlasname}.ptseries.nii $outputpathsession/${atlasname}/${SUBJECT}_${SESSION}_Atlas_MSMAll_hp0_clean_${atlasname}.txt

				echo "Done with conversion to .txt for atlas $atlasname!"
				echo
			done

			echo "Done with parcellation"
			echo
			echo "Done with Session $SESSION!"
			echo

	        else
			echo "Session $SESSION is not complete for $SUBJECT, SKIPPING..."

	        fi

done

echo "Done with Subject $SUBJECT!"
echo
echo

rm -r $tempfolder/*

done < $subjectlist

echo "Processing done!"

then=$(date)
	echo $then
