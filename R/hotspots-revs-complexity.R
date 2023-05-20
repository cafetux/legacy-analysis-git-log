
filesStats <- read.table(file = "cloc_and_revisions.csv",
                         header = TRUE,
                         sep = ",",
                         quote = "\"" )


head(filesStats)

library(stringr)
library(dplyr)
library(treemapify)
library(ggplot2)


max_revisions = max(filesStats$nb_revision)
max_loc = max(filesStats$nb_line_of_code)


codeBase <- filesStats %>% select(
  file,
  language,
  nb_line_of_code,
  nb_revision) %>%
  filter(language == "Java") %>%
  mutate(type = str_match(file, "^src/([^/]+)")[,2]) %>%
  #mutate(type = str_match(file, "^[^/]+/src/([^/]+)")[,2]) %>%
  #mutate(module = str_extract(file, "^[^/]+")) %>%
  mutate(filename = str_extract(file, "[^/]+$")) %>%
  mutate(indiceLoc = nb_line_of_code/max_loc) %>%
  mutate(indiceRevs = nb_revision/max_revisions) %>%
  as.data.frame()


png(filename="tree_map_hotspots.png", units="in", width=30, height=20, res=300)
#ggplot(codeBase, aes(area = nb_line_of_code, fill = nb_revision, label = filename, subgroup = module, subgroup2 = type)) +
ggplot(codeBase, aes(area = nb_line_of_code, fill = nb_revision, label = filename, subgroup = type)) +
  geom_treemap() +
  geom_treemap_subgroup_border(colour = "white", size = 6) +
#  geom_treemap_subgroup2_border(colour = "green", size = 1) +
  geom_treemap_subgroup_text(place = "centre", grow = TRUE,
                             alpha = 0.35, colour = "white",
                             fontface = "italic") +
  geom_treemap_text(colour = "white",
                    place = "centre",
                    size = 15)
dev.off()