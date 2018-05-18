# Boundary tethered model simulations

Code and results for simulations of the boundary tethered model written for Matlab.

The simulations are organized with separate wrapper functions corresponding to each simulated experiment, which can be found in the ExperimentWrappers folder. Running any of these will carry out the corresponding simulation as described in the paper.

The model parameters can be viewed or changed through the function: params. The default parameters were tuned to work with the spiking model -- to implement rate-based models these parameters may need to be changed. Typically reducing the inhibition weight between grid-to-grid connections is sufficient.

Longer training simulations are broken up into epochs to reduce demands on memory. As each epoch finishs, the resultant network will be saved to the folder MatlabData under the appropriate experiment name. These net files are structs containing information from the entire simulation, including 

the simulated animal path under: 			pos
the saved spike times under: 				spike_ts
the most recently contacted boundary under:		lastBorder
the simulation parameters under:				p

Before each simulation is carried out, the path is generated and the activity of border units is precomputed ahead of time. This is parallelized with parfor loops, so opening a matlabpool will speed this up. This part also relies on the function: lineSegmentIntersect, which can be found on Mathworks here: 

https://www.mathworks.com/matlabcentral/fileexchange/27205-fast-line-segment-intersection?focused=5150921&tab=function

The results are contained in the folder 'Nets'. The rate map data for each of these experiments can be loaded into a more useful form by using the function getMapsFromNets(Folder), where folder specifies the folder containing all the simulations for a particular experiment. For an example of this use, see the end of ExperimentWrappers/Stensola_2012

This code is provided for use without any responsibility assumed on our part. If you use it, please cite the paper! For any questions or comments, please contact me at: atkeinath@gmail.com

Enjoy!
