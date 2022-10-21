Uncertainty from Noise
=======================

MATLAB code for correcting the noise from a vector or matrix of noise-
contaminated RMS values. The code calculates, from multiple observations,
the average of the noise energy and the noise-contaminated energy and 
obtains the noise-corrected average energy by subtracting the two. 

The code also returns the expanded uncertainty of the average. The 
uncertainty can be particularly large if the signal-plus-noise to
noise ratio (SNNR) is less than 3 dB. Noise corrections should always
be accompanied by their uncertainties.

For further information on expanded uncertainties and confidence intervals
check the "Docs" folder. Documents that are particularly important for 
understanding uncertainty and how to calculate it when working with sound
levels are the "Guide to the Expression of Uncertainty in Measurement (GUM)
(JCGM 100:2008; ISO/IEC GUIDE 98-3:1995) and Uncertainty of Decibel Levels
(Taraldsen et al., 2015).

The code in noiseCorrection (for 'lin' and 'qua' cases) and noiseError needs
to be updated. The approach from Taraldsen et al (2015) should also be
incorporated into these two functions.

[Guillermo Jiménez Arranz, 16 Jun 2021]





