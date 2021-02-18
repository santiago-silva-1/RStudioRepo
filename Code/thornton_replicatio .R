library(tidyverse)
library(haven)

read_data <- function(df)
{
  full_path <- paste("https://raw.github.com/scunning1975/mixtape/master/", 
                     df, sep = "")
  df <- read_dta(full_path)
  return(df)
}

hiv <- read_data("thornton_hiv.dta")
#we just loaded the data

# creating the permutations

tb <- NULL
#just created object "tb"

permuteHIV <- function(df, random = TRUE){
  tb <- df
  first_half <- ceiling(nrow(tb)/2)
  second_half <- nrow(tb) - first_half
  
  if(random == TRUE){
    tb <- tb %>%
      sample_frac(1) %>%
      mutate(any = c(rep(1, first_half), rep(0, second_half)))
  }
  
  te1 <- tb %>%
    filter(any == 1) %>%
    pull(got) %>%
    mean(na.rm = TRUE)
  
  te0 <- tb %>%
    filter(any == 0) %>%
    pull(got) %>% 
    mean(na.rm = TRUE)
  
  ate <-  te1 - te0
  
  return(ate)
}
#just created function permuteHIV, which randomly assigns treatment 


permuteHIV(hiv, random = FALSE)
#what is this?

iterations <- 1000
#we're going to repeat something 100 times

permutation <- tibble(
  iteration = c(seq(iterations)), 
  ate = as.numeric(
    c(permuteHIV(hiv, random = FALSE), map(seq(iterations-1), ~permuteHIV(hiv, random = TRUE)))
  )
)
#just created object "permutation"


#calculating the p-value

permutation <- permutation %>% 
  arrange(-ate) %>% 
  mutate(rank = seq(iterations))

p_value <- permutation %>% 
  filter(iteration == 1) %>% 
  pull(rank)/iterations
