#Potential Outcomes program Install
#Santiago Silva
#Feb 13, 2021
#this file contains the code Dr. Cunnigham emailed us in preparation of the thronton replication
#this is part of the Randomized Control Experiment Chapter
install.packages("tidyverse")
install.packages("cli")
install.packages("haven")
install.packages("rmarkdown")
install.packages("learnr")
install.packages("haven")
install.packages("stargazer")


library(learnr)
library(haven)
library(tidyverse)
library(estimatr)
library(stargazer)

# 10 minute code time limit
options(tutorial.exercise.timelimit = 600)

# read_data function
read_data <- function(df) {
  full_path <- paste0("https://raw.github.com/scunning1975/mixtape/master/", df)
  return(haven::read_dta(full_path))
}

#we just created a function to read in STATA data