# set the working directory
setwd("your/working/directory")

# load required packages
library(gtsummary) # to create publication ready tables
library(flextable) # improves `gtsummary` compatibility with Word
library(tidyverse) # umbrella library for unparalleled functionality
library(ggstatsplot) # for publication ready graphs with statistical results
library(reshape2) # to manipulate and reshape data

# import data
df <- read.csv("your/working/directory/data.csv",
               check.names = FALSE) # this will retain original column names if needed
df %>% colnames # get column names
attach(df) # this will attach data in the environment

# create a summary table
table1 <- df[,-c(1)] %>% 
            tbl_summary(type = list(where(is.numeric) ~ "continuous"))

table1 %>%
  as_flex_table() %>%
  save_as_docx(path = "Table 1.docx") # save the table as a .docx file to the working directory

# reshape the data from a wide format to a long format for repeated measures
df1 <- df %>%
        melt(id.vars = "ID", measure.vars = c("mMASI 1st Score", 
                                              "mMASI 2nd Score", 
                                              "mMASI 3rd Score", 
                                              "mMASI 4th Score"))

df2 <- df %>%
  melt(id.vars = "ID", measure.vars = c("Patient Scale 1st", 
                                        "Patient Scale 2nd", 
                                        "Patient Scale 3rd", 
                                        "Patient Scale 4th"))


# plot a graph, extract statistics, and save a high-quality plot
plot1 <- df1 %>%
          ggwithinstats(x = variable,
                        y = value,
                        type = "nonparametric",
                        violin.args = list(width = 0),
                        xlab = "",
                        ylab = "",
                        title = "Boxplots of mMASI Scores Over Time") # plot a repeated measures graph

extract_stats(plot1) # extract results of statistical tests used in the graph

ggsave(plot = plot1,
       filename = "Plot 1.png",
       height = 6,
       width = 12,
       dpi = 600) # save the plot in high quality

# the same for a different variable
plot2 <- df2 %>%
  ggwithinstats(x = variable,
                y = value,
                type = "nonparametric",
                violin.args = list(width = 0),
                xlab = "",
                ylab = "",
                title = "Boxplots of Patient-Reported Scores Over Time") # plot a repeated measures graph

extract_stats(plot2) # extract results of statistical tests used in the graph

ggsave(plot = plot2,
       filename = "Plot 2.png",
       height = 6,
       width = 12,
       dpi = 600) # save the plot in high quality
