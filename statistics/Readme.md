Glider Statistics Readme
========================

Regrettably, the U.S. soaring community does not keep accurate records of the number of hours that gliders are flown in the U.S. As a result, the Soaring Safety Foundation does not have accurate counts for the number of hours flown by U.S. gliders. Without this information it is impossible to accurately estimate the accident rate for soaring in the U.S.

This information is sorely needed as preliminary estimates suggest that the accident rate for soaring is significantly higher than for commercial aviation. Bringing down these accident rates will require us to identify the risk factors driving these accident rates, and assess the effectiveness of intervention strategies. Both of these activities require accurate numbers.

In particular, Smith et. al. found strongly suggestive evidence that the fatal accident rate for sailplanes vary dramatically from model to model. In [1], Smith et. al. attribute these divergent accident rates to the differing tendency for sailplanes to spin. This preliminary work highlights the value of quantitative evidence in identifying the risk factors driving soaring's high accident rates.

I conjecture, that a quantitative analysis of soaring accidents will reveal a pattern similar to that discovered by the safety analysts who worked to drive down automobile accidents in the 20th century. In that case, at every scale of analysis risks were highly concentrated in a few areas. When researchers found that significant reductions in risk could be achieved by addressing a few problem areas, it became hard to justify continued complacency.

Similarly, if Smith et. al. are correct, and the fatal accident rates between aircraft differ by an order of magnitude, it is hard to continue justifying flying those models without aggressive targeted safety interventions.

Lastly, the Soaring Safety Foundation has tracked the rate of fatal and nonfatal accidents for several decades. This analysis has shown a continuous gradual decline in the rate of nonfatal accidents but a stubborn persistence in the rate of fatal accidents. I believe, that this evidence strongly indicates that nonfatal and fatal accidents are qualitatively different. If correct, it would suggest that specialized analysis and interventions need to be directed at each.

Method
------

This project aims to automate some of the work needed to generate estimates for basic analysis parameters.

I estimate the age distribution of aircraft belonging to a given model by referencing FAA registration records.

This information is currently available at registry.faa.gov. I request that the FAA make this information available via REST services providing JSON or XML feeds.

I estimate the average utilization (hours flown/(current year - manufactured year)) by referencing Wings and Wheels - a large online marketplace for the sale of used sailplanes. I request that the FAA require pilots to report the number of hours flown when they renew their aircraft registry. It is egregious, that no agency in the U.S. tracks the number of hours flown by U.S. based sailplanes.

I estimate the accidents associated with each model using the Aviation Safety Network database - a volunteer run wiki that maintains the largest international accident database for sailplanes.

Utilities
---------

This directory contains a set of Gawk scripts for scraping data from these diverse resources and for performing rudimentary analysis on them.
