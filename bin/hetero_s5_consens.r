## Packages used 
library(ggplot2)
library(dplyr)
library(tidyr)

## Working direcory
setwd("~/GBS_Bioinf_Process_Mamm/bin")

## Start with a fresh brain
rm(list = ls())

## Cluster Treshhold ##

## List the directories 
folders_clust <- intersect(list.files("../out/ipyrad_outfiles/parameters/", pattern = "clust"), list.files("../out/ipyrad_outfiles/parameters/", pattern = "80_consens"))

## Create a dataframe empty
df_het_clust <- data.frame()

## Extract tables for Cluster Treshhold
for (i in folders_clust){
    
    ## Find the file name pattern
    name <- stringr::str_extract(string = i, pattern = "clust_[0-9]+_[0-9]+")
    
    tab_hetero <- read.table(paste0("../out/ipyrad_outfiles/parameters/", i, "/s5_consens_stats.txt", row.names = NULL))
    
    ## Create a dataframe repeating the identifier according to with the number of row of the table 
    name_row <- data.frame(rep(name, times = nrow(tab_hetero)))
    
    ## Change the name of identifier column
    colnames(name_row) <- "Id"
    
    ## combine the data frames by columns
    final <- cbind(name_row, tab_hetero)
    
    ## combine the data frames by rows    
    df_het_clust <- rbind(df_het_clust, final)
}

## Reorder the data frame, separate the column parameters by "_" 
## Change the numeric columns to factors
clust_thresh_het <- df_het_clust %>% 
  separate(Id, c("param", "value", "min_sam"), "_") %>%
  mutate(value = factor(value, levels = c(82, 85, 86, 87, 88, 89, 91, 94))) %>%
  mutate(min_sam = factor(min_sam, levels = c(80)))

## Create the plot 
pl_heter <- clust_thresh_het %>% 
  ggplot(aes(x=value, y=heterozygosity)) +
  geom_boxplot() + 
  xlab("Clustering Threshold (% similarity)") + 
  ylab("% heterozygous sites") 

pl_heter

## Save plot in EPS Extension
ggsave(pl_heter, file="../out/R_plots/Clust_Tresh_heter.png", device="png", dpi = 100)
