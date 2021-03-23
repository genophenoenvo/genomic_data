#! /usr/bin/Rscript --vanilla
	# install.packages("moments")

	library(moments)
	x <- read.csv('stdin', header = F);
	# "min, q1, med, mean, q3, max"
	summary(x);
	# describe(x)
	# sprintf("sd :%.02f", sd(x[,1]));
	# skewness(x[,1]);
	# kurtosis(x[,1]);

