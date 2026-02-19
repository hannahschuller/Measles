# load packages
library(dplyr)
library(tidyr)
library(tidyverse)
library(readxl)
library(httr)
library(jsonlite)
library(ukhsadatR)

# global MMR1 + 2 vaccine rates

## read data
measles_global_v1 <- read_excel("/Users/hannah.schuller/Desktop/measles_global/measles_global_vax1.xlsx")
measles_global_v2 <- read_excel("/Users/hannah.schuller/Desktop/measles_global/measles_global_vax2.xlsx")

## remove footnote 
measles_global_v1 <- measles_global_v1[measles_global_v1$GROUP != "Exported: 2026-19-2 9:21 UTC", ]
measles_global_v2 <- measles_global_v2[measles_global_v2$GROUP != "Exported: 2026-19-2 9:22 UTC", ]

## filter by 2024 data 
v1_2024 <- measles_global_v1 %>%
  filter(YEAR == 2024,
         COVERAGE_CATEGORY == "WUENIC") %>%
  select(-GROUP, -YEAR, -ANTIGEN, -COVERAGE_CATEGORY,
         -COVERAGE_CATEGORY_DESCRIPTION, -TARGET_NUMBER, -DOSES) %>%
  rename(vax1_coverage = COVERAGE)

v2_2024 <- measles_global_v2 %>%
  filter(YEAR == 2024,
         COVERAGE_CATEGORY == "WUENIC") %>%
  select(-GROUP, -YEAR, -ANTIGEN, -COVERAGE_CATEGORY,
         -COVERAGE_CATEGORY_DESCRIPTION, -TARGET_NUMBER, -DOSES) %>%
  rename(vax2_coverage = COVERAGE)

## join to produce global 2024 measles vaccination coverage (vax 1 + 2)
measles_2024_vax_coverage <- left_join(
  v1_2024,
  v2_2024 %>% select(CODE, NAME, vax2_coverage),
  by = c("CODE", "NAME") 
)

## save
write.csv(measles_2024_vax_coverage,
          "/Users/hannah.schuller/Desktop/measles_2024_vax_coverage.csv",
          row.names = FALSE)