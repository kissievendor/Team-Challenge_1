
Calculation of nerve diameter and area

===============================================================================================================================
The motivation for this project was to develope an automated algorithm that allows researchers to differentiate
between amyotrophic lateral sclerosis (ALS) and multifocal motor neuropathy (MMN) of their patients. Based on an MRI
data set, the area and diameter of nerves are determined which subsequently allows the researcher to conclude the disease
and lets the medical doctor apply the treatment appropriate to the disease.

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

*Determine which patient(s) should be analyzed with the second parameter of the function.
	*a single patient e.g. with patientID 12:  areas = intensity(patients, 12);
	*multiple patients in a row e.g. patients 1 to 16: areas = intensity(patients, 1:16);
	*multiple patients that are not in a row: areas = intensity(patients, [1:5,23,29]);

*Optional: determine further parameters such as threshold or margin for the area calculation.
	*Threshold determines the amount of pixels that are accounted as the nerve (higher threshold, less pixel
	 accounted for nerve). Use a value between 0 and 1.
	 e.g. result = intensity(18:20, 'threshold', 0.33);
	*Margin changes the size of the region of interest (ROI). A larger margin leeds to more pixels that are
	 checked whether they belong to the nerve. Use a low single digit value
	 e.g. result = intensity(18:20, 'margin', 2);
	*A combination of both, e.g.: result = intensity(18:20, 'threshold', 0.33, 'margin', 2);

*Run main.m

*The results are stored as txt.files for each patient and are also accessible in the MATLAB Workspace in the
 variable result

===============================================================================================================================
Files

*main.m: the main file, giving the results of diameter and area calculation.
*activecontouring.m: Create active contour mask of one nerve, and compute diameters

===============================================================================================================================
This algorithm was run in April 2020.

The code was built in MATLAB R2019a.

Group members: K. van den Berg, K. Koopman, A. Koop, S. Noordman, M. Romme, L. Staiger