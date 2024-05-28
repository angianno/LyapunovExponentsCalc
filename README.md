To calculate the LLE for each subject and electrode, you have to run plot_linear_parts.m by defining the number of participants and the sampling rate.
The script plot_linear_parts.m calls the function polyfit_linear_section to detect the linear part for LLE computation.
Note that the path to EEG data of the participants should also be provided (here we were not able to provide the data due to external ethical restrictions), but the scripts are general-purpose. 
