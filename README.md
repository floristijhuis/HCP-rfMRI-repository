# Human Connectome Project rfMRI repository

This GitHub repository was created by Floris Tijhuis as part of a research assistantship at the Institute for Advanced Study (IAS) Amsterdam and the Vrije Universiteit Medisch Centrum (VUmc) Amsterdam. The goal of the project was to create a database containing (pre)processed time series and connectivity matrices of the resting-state functional MRI scans of two large-scale neuroimaging databases of the Human Connectome Project; the HCP-Aging database (February 2021 release) and the HCP-Young Adult database.

This repository contains several different types of files and scripts;
* /ConnectivityMatrices contains the connectivity matrices for each subject in the two databases, parcellated using different brain atlases (i.e. predefined sets of brain regions). The connectivity matrices were obtained by performing a simple Pearson correlation on the time series.
* /Atlases contains the different brain atlases accompanied by information files on the atlases and instructions on how to obtain or generate these files.
* /Scripts contains all the scripts necessary to generate the time series and connectivity matrices for the subjects in the HCP-Young Adult and HCP-Aging databases. Moreover, it contains some scripts that were required for the generation of the brain atlases or information files on the atlases.
* /SubjectLists contains .txt files with the subject identifiers for all the subjects present in the separate databases. These subject lists are called by the main scripts in /Scripts and can be altered in order to create time series/connectivity matrices of a subset of participants or new releases of the HCP-Aging database.

For a more elaborate explanation of the data, processing steps and how to navigate this repository, please refer to the accompanying manual.
