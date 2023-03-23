
commit_date <- read.table(file = "commits_author_date.csv",
                         header = FALSE,
                         sep = ",",
                         quote = "\"" )


head(commit_date)

library(stringr)
library(dplyr)
library("ggplot2")

commit_date_author <- commit_date %>%
  mutate(date = as.Date(V2, format="%Y-%m-%d")) %>%
  mutate(author = V1) %>%
  select(author, date) %>%
  as.data.frame()

commit_by_date <- commit_date_author %>%
  group_by(date) %>%
  summarise(commit_count=n()) %>%
  as.data.frame()

group_by_month <- commit_date_author %>%
  group_by(month = format(date,"%Y-%m")) %>%
  summarise(commit_count=n()) %>%
  as.data.frame()

group_by_year <- commit_date_author %>%
  group_by(year = format(date,"%Y")) %>%
  summarise(commit_count=n()) %>%
  as.data.frame()


png(filename="barplot_commits_by_month.png", units="in", width=5, height=5, res=300)

barplot(group_by_month$commit_count,
        names.arg=group_by_month$month,
        main="commit count by month",
        xlab="month",
        ylab="Count"
)
dev.off()

png(filename="barplot_commits_by_year.png", units="in", width=5, height=5, res=300)
barplot(group_by_year$commit_count,
        names.arg=group_by_year$year,
        main="commit count by year",
        xlab="year",
        ylab="Count"
)
dev.off()

png(filename="lineplot_commits_by_date.png",units="in", width=5, height=5, res=300)

ggplot(commit_by_date, aes(x = date, y = commit_count)) +
  geom_line() +
  scale_x_date(date_labels = "%Y-%m")

dev.off()
