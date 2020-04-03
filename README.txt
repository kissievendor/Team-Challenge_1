
Calculation of nerve diameter and area

===============================================================================================================================

The motivation for this project was to develope an automated algorithm that allows researchers to differentiate
between amyotrophic lateral sclerosis (ALS) and multifocal motor neuropathy (MMN) of their patients. Based on an MRI
data set, the area and diameter of nerves are determined which subsequently allows the researcher to conclude the
disease and lets the medical doctor apply the treatment appropriate to the disease.

The algorithm determines the diameter and area of the human nerves C5, C6 and C7 based on a data set of MRI-images.
The locations of the calculated values are directly after the ganglion and 1cm along the nerve route.
For the determination of the diameter, an active contouring approach was chosen. The determination of the area was
carried out using an intensity based algorithm.

These instructions will get you a copy of the project running on your local machine for testing purposes. See the
guide on how to deploy the project on your machine.

===============================================================================================================================

Prerequisites

*Install MATLAB R2019a or a later version of the program on your device.


Installing

*Unpack the folder


Running the test

*Open main.m in MATLAB

*Set datapath to the folder with the stored MRI data. e.g. datapath = "C:\Users\JohnDoe\Documents\MRI\data";

*Determine which patient(s) should be analyzed, both for area and diameter.

	*a single patient e.g. patientIds = 12;

	*multiple patients in a row e.g. patients 1 to 16: patientIds = 1:16;

	*multiple patients that are not in a row: patientIds = [1:5,23,29];

*Optional: determine further parameters such as threshold or margin for the area calculation.

	*Threshold determines the amount of pixels that are accounted as the nerve (higher threshold, less pixel
	 accounted for nerve). Use a value between 0 and 1.
	 e.g. areas = intensity(patients, patientIds, 'threshold', 0.33);

	*Margin changes the size of the region of interest (ROI). A larger margin leeds to more pixels that are
	 checked whether they belong to the nerve. Use a low single digit value.
	 e.g. areas = intensity(patients, patientIds, 'margin', 2);

	*Plot enables/disables the visualization of the examined nerves.
	 e.g. areas = intensity(patients, patientIds, 'plot', true);

	*A combination of the above
	 e.g. areas = intensity(patients, patientIds, 'threshold', 0.33, 'margin', 2, 'plot', true);

	*Edge determines the amount of borderpixels around the ROI. Increasing it will increase the patch size on
	 which the active contour is done.
	 e.g. diameters = diameter_struct(patients, patientIds, 'edge', 5);

*Run main.m

*The results are stored as txt.files for each patient and are also accessible in the MATLAB Workspace in the
 variable result

===============================================================================================================================

Files

*activecontouring.m: Creates active contour mask of one nerve, and compute diameters.

*create_struct.m: Processes all nerves of one patients and stores is in a patient struct.

*diameter_struct.m: Calculates the diameter of the nerves using an active contour algorithm and creates a structure
 		    in which the results are visable.

*drawnerve.m: Plotting labeled nerve structures.

*findarea.m: Finding the intersecting area between the planes after 1cm and directly after the ganglion and the
	     constructed nerve.

*getcand.m: Gets candidate for the corners.

*getpatch.m: Creates patch around the tractography which is our region of interest.

*intensity.m: Calculates the area of the nerves C5 to C7 using an intensity-based algorithm and plotting a 3D model
	      of them.

*iscoplanar.m: Tests input points for coplanarity in N-dimensional space.

*loadpatient.m: Loads data of designated patient(s).

*main.m: Main file, giving the results of diameter and area calculation.

*makegroupmask.m: Builds mask of the groups.

*makepointsmask.m: Builds mask of the points.

*plane.m: Builds plane after 1cm along the nerve route and directly after the ganglion, respectively.

*points.m: Finds 8 vertices of the nerve per slice and stores them.

*result_struct.m: Presenting results in the desired structure.

*rectmask.m: Builds rectangular mask around the tract.

*search.m: Builds the group of pixels displaying the nerve for each slice.

*Surfaceintersection.m: Intersection of two surfaces.

===============================================================================================================================

This algorithm was run in April 2020.

The code was built in MATLAB R2019a.

Group members: K. van den Berg, K. Koopman, A. Koop, S. Noordman, M. Romme, L. Staiger

===============================================================================================================================

References

*iscoplanar.m: Brett Shoelson, Ph.D. (2014), brett.shoelson@mathworks.com
	       Weisstein, Eric W. "Coplanar." From MathWorld--A Wolfram Web Resource.
	       http://mathworld.wolfram.com/Coplanar.html
	       Abbott, P. (Ed.). "In and Out: Coplanarity." Mathematica J. 9, 300-302, 2004.
	       http://www.mathematica-journal.com/issue/v9i2/contents/Inout9-2/Inout9-2_3.html

*Surfaceintersection.m: Jaroslaw Tuszynski (2020).
 			Surface Intersection (https://www.mathworks.com/matlabcentral/fileexchange/48613-surface-intersection),
			MATLAB Central File Exchange. Retrieved April 3, 2020.