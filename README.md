# Human Connectome Project rfMRI repository

This GitHub repository was created as a joint project of the Institute for Advanced Study (IAS) Amsterdam and the Vrije Universiteit Medisch Centrum (VUmc), department Anatomy and Neurosciences. The goal of the project was to create a database containing (pre)processed time series and connectivity matrices of the resting-state functional MRI scans of two large-scale neuroimaging databases of the Human Connectome Project; the HCP-Aging database (February 2021 release) and the HCP-Young Adult database. The connectivity matrices have been made publicly available as a Zenodo dataset, which can be found here: https://doi.org/10.5281/zenodo.6770120

This repository contains several different types of files and scripts;

* /Scripts contains all the scripts necessary to generate the time series and connectivity matrices for the subjects in the HCP-Young Adult and HCP-Aging databases. Moreover, it contains some scripts that were required for the generation of the brain atlases or information files on the atlases.
* /Atlases contains the different brain atlases accompanied by information files on the atlases and instructions on how to obtain or generate these files.
* /SubjectLists contains .txt files with the subject identifiers for all the subjects present in the separate databases. These subject lists are called by the main scripts in /Scripts and can be altered in order to create time series/connectivity matrices of a subset of participants or new releases of the HCP-Aging database.

For a more elaborate explanation of the data, processing steps and how to navigate this repository, please refer to the accompanying manual present in this folder.

If you use this repository or the scripts in this repository, please cite in the following way:

*Tijhuis, F., Schepers, M., Centeno, E., Maciel, B., Douw, L., Nobrega Santos, F. Human Connectome project rfMRI repository. San Francisco (CA): GitHub; [Accessed Year Mon Day]. https://github.com/floristijhuis/HCP-rfMRI-repository.*
