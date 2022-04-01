% Fix labeling BNA CIFTI Atlas

% This script is meant to fix the label numbering of the vertices in the original BNA atlas.
% For the first 210 labels, every sensical odd label (e.g. 1) is followed
% by a nonsensical even label. For the second 210 labels, every sensical
% even label is preceded by a nonsensical odd label. This is taken into
% account to adapt the atlas

%%author__ = Floris Tijhuis
%%contact__ = f.tijhuis@amsterdamumc.nl
%%date__ = 2021/12/22 % date script was created
%%status__ = Finished


%%%%%%%%%%%%%%%%%%%%
% Review History   %
%%%%%%%%%%%%%%%%%%%%

%%% Reviewed by Name Date % e.g. Linda Douw 20200714


%%%%%%%%%%%%%%%%%%%%
% Requirements     %
%%%%%%%%%%%%%%%%%%%%

%%% Toolboxes 
% This script requires the cifti_matlab toolbox, which you can download
% from here: https://github.com/Washington-University/cifti-matlab

%%% Input/Output
% No other functions necessary. The BNA atlas in CIFTI format can be
% downloaded from the official Brainnetome website (https://atlas.brainnetome.org/download.html)
addpath('[PATH]/cifti-matlab-master/')

inputfile='/Atlases/Brainnetome/info/fsaverage.BN_Atlas.32k_fs_LR.dlabel.nii';
outputfile='/Atlases/Brainnetome/info/fsaverage.BN_Atlas.32k_fs_LR_verticescorrect.dlabel.nii';

%% 
BNA = cifti_read(inputfile);

for i=1:length(BNA.cdata)
    entry=BNA.cdata(i);
    if ~rem(entry,2) && entry>211 % this means the number is even (signifying the numbers in the right hemisphere)
        newentry=entry-210;
    else 
        newentry=entry;
    end
    BNA.cdata(i)=newentry;
end

cifti_write(BNA,outputfile);