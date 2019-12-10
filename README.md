This repository holds the code for the paper:

**"On-board range-based relative localization for micro air vehicles in indoor leader–follower flight"**. *Steven van der Helm, Mario Coppola, Kimberly N. McGuire, Guido C. H. E. de Croon, 2018. Autonomous Robots, March 2019, pp 1-27.*
The paper is available open-access at this link: *https://link.springer.com/article/10.1007/s10514-019-09843-6*
Or use the following link for a PDF: *https://link.springer.com/content/pdf/10.1007%2Fs10514-019-09843-6.pdf*

# Getting the data
To download the data used in the paper, use the script `download_data.sh', or do it manually by following the instructions on top of the script. The data is needed to reproduce the plots as in the paper.

# Code description
The following MATLAB scripts reproduce the results from the paper.

### Observability analysis

* `observability_condition_check.m`, *(verifies Equation 36, Appendix A)*
Symbolically verifies the derived observability condition in the paper (Condition Eq. 36). The analyirical derivation can be found in Appendix A of the paper.

* `observability_unintuitive_conditions.m`, *(reproduces Figures 3c, 3d, 4e, 4f)*.
Reprocudes the unobservable intuitive conditions as seen in figures 3 and 4.

* `observability_simulator.m`, *(reproduces Figures 5 to 10)*.
Reproduces the simulation results used to empirically evaluate the observability conditions.

### Noise analysis

* `noise_circular_trajectory_plot.m`, *(reproduces Figure 11)*.
Reproduces the circular trajectories used in the simulation study, depicted also in Fig. 11 in a more stylized fashion.

* `noise_generate_data.m`, *(reproduces data from Table 1)*
Runs EKF instances for different noise levels for both filters and reproduces the data seen in Table 1.

* `noise_range_plot.m`, (reproduces Figure 12)
Based on the data extracted from `range_noise_study.m` (Table 1 in the paper) reproduces the impact of range noise on the localization error.

* `noise_heading_disturbance_plot.m`, *(reproduces Figure 13)*.
Plots the heading disturbance that was used in the noise analysis, as seen in Figure 13.

* `noise_heading_disturbance_analysis.m` *(reproduces Figure 14)*
Based on the data extracted from `range_noise_study.m` (Table 1 in the paper) reproduces the impact of disturbance with increasing noise.

### Data analysis of experimental results
* `experiment_2MAVs_MCS.m`, *(reproduces Figures 16 to 21)*.
Data analysis for leader-follower the experiment with the **2 MAVs using the Motion Caputure Sytem** (except range, which was measured with Ultra Wideband). Please note that, depending on the start and end time of the analysis, the pictured distribution may slightly vary from the paper.

* `experiment_2MAVs_onboard.m`, *(reproduces Figures 22, 23, 25, 26)*.
Data analysis for leader-follower the experiment with the **2 MAVs using onboard sensing**. Please note that, depending on the start and end time of the analysis, the pictured distribution may slightly vary from the paper.

* `experiment_3MAVs_MCS.m`, *(reproduces Figures 27)*.
Data analysis for leader-follower the experiment with the **3 MAVs using the Motion Caputure Sytem** (except range, which was measured with Ultra Wideband). Please note that, depending on the start and end time of the analysis, the pictured distribution may slightly vary from the paper.

* `experiment_3MAVs_onboard.m`, *(reproduces Figures 27-32)*.
Data analysis for leader-follower the experiment with the **3 MAVs using onboard sensing**. Please note that, depending on the start and end time of the analysis, the pictured distribution may slightly vary from the paper.

* `experiment_unobservable_MCS.m`, *(reproduces Figure 33)*
Figure showing the occurrence of unobservable conditions in the results. Please note that, depending on the start and end time of the analysis, the figure may slightly vary from the paper as it considers a different time-segment.

