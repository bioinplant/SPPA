SPPA algorithm provides an objective, systematic, sensitive means to evaluate the biological impact of exposures to MS of different compositions making a powerful comparative tool for commercial product evaluation and potentially for other known or potentially toxic environmental smoke substances. 

Step 1: load the sample expression data, run Calculate_effect_score_for_pathways.R, and get the SPPA_score.txt file 

Rscript Calculate_effect_score_for_each_pathway.R /path/to/expression_data.txt 1:3 4:6 /path/to/Reactome_pathway.csv /path/to/result

Step 2: Run Next_three_steps.pl，get Total Effect Score (TES)

perl Next_three_steps.pl /path/to/Next_three_steps_script /path/to/SPPA_score.txt
