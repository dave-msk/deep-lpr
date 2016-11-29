Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
All rights reserved.

This software may be modified and distributed under the terms
of the BSD license.  See the LICENSE file for details.

==================================================================

Author: Siu-Kei Muk, Jason Bolito

Acknowledgement:

We would like to show our gratitude to Mr.ChengYao Qian for his participation in training data collection.

Introduction:

The Deep Licence Plate Reader (deep-LPR) is a matlab based tool for recognition of license plates. A combined technique from image processing and convolutional neural network is employed. The deep-LPR is shown to have satisfactory accuracies even the given license plate image is heavily noised. For further details, please refer to the technical report attached (deep-LPR.pdf).

The format of license plates are initially Australian. One can modify it into other formats in the "deep-lpr/ccorrection/formats.txt" file.

==================================================================

Minimum requirements for DLPR:
	- Matlab R2016a (with the Deep Learning Toolbox installed)
	- CUDA supported GPU
	- CUDA SDK


To setup the Deep Licence Plate Reader (DLPR)
1 - cd deep-lpr
2 - in Matlab, run setup_lpr
3 - You should have a global variable called lpr_data

To execute DLPR on a colour image (assumes you're in deep-lpr/)
1 - run the function 
	deep_lpr(image, lpr_data)
2 - The function should output a string with the LPN

To run the testing script (assumes you're in deep-lpr/)
- run testing_script

To train the CNN (assumes you're in deep-lpr/)
1 - cd matlab_cnn/
2 - run the script run_cnn_small
3 - You should see a table displaying the epochs and global progress

To run the CNN character test script (assumes you're in deep-lpr/)
    run the script test_char

To run the segmentation module and display the segmentation process (assumes you're in deep-lpr/)
- run the function
	segment(image, true, true, true)
