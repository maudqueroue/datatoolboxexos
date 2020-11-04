rm(list= ls())

citations_raw <- read_csv('https://raw.githubusercontent.com/oliviergimenez/intro_tidyverse/master/journal.pone.0166570.s001.CSV')
citations_raw

citations %>%
  ggplot() +
  aes(x = nbtweets, y = woscitations) +
  geom_point()

citations <- citations_raw %>%
  rename(journal = 'Journal identity',
         impactfactor = '5-year journal impact factor',
         pubyear = 'Year published',
         colldate = 'Collection date',
         pubdate = 'Publication date',
         nbtweets = 'Number of tweets',
         woscitations = 'Number of Web of Science citations') %>%
  mutate(journal = as.factor(journal))


# Graph simple
citations %>%
  ggplot() +
  aes(x = nbtweets, y = woscitations) +
  geom_point(color="indianred4")

# Couleur dans l'aes : couleur en fonction des données et non pas tous les points comme dans geom
citations %>%
ggplot() +
  aes(x = nbtweets, y = woscitations, color = journal) +
  geom_point()

# Faire sur moins de journal
citations_ecology <- citations %>%
  mutate(journal = str_to_lower(journal)) %>% # all journals names lowercase
  filter(journal %in%
           c('journal of animal ecology','journal of applied ecology','ecology')) # filter
citations_ecology

#pour afficher tibble en entier faire : print(n=Inf)

# Plot sur moins de journal
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets, y = woscitations, shape = journal) +
  geom_point(size=2)

# Ajout de lignes
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets, y = woscitations) +
  geom_line() +
  scale_x_log10()


citations_ecology %>%
  arrange(woscitations) %>%
  ggplot() +
  aes(x = nbtweets, y = woscitations) +
  geom_line() +
  scale_x_log10()

# Point et ligne
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets, y = woscitations) +
  geom_line() +
  geom_point() +
  scale_x_log10()

# Ajout regression
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets, y = woscitations) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_x_log10()

# Ligne smooth qui passe
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets, y = woscitations) +
  geom_point() +
  geom_smooth() +
  scale_x_log10()

# Histogram
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets) +
  geom_histogram()

# Ajustement couleur
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets) +
  geom_histogram(fill = "indianred4", color = "black")

# Pour modifier les noms d'abcisses et ordonnées
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets) +
  geom_histogram(fill = "indianred4", color = "black") +
  labs(x = "Number of tweets",
       y = "Count",
       title = "Histogram of the number of tweets")

# Histogram par journal (magique !!!)
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets) +
  geom_histogram(fill = "indianred4", color = "black") +
  labs(x = "Number of tweets",
       y = "Count",
       title = "Histogram of the number of tweets") +
  facet_wrap(vars(journal))

# Boxplot
citations_ecology %>%
  ggplot() +
  aes(x = "", y = nbtweets) +
  geom_boxplot(fill = "indianred4") +
  scale_y_log10()

# Boxplot par journal
citations_ecology %>%
  ggplot() +
  aes(x = journal, y = nbtweets, fill = journal) +
  geom_boxplot() +
  scale_y_log10()

# Enlever le nom d'un axe
citations_ecology %>%
  ggplot() +
  aes(x = journal, y = nbtweets, fill = journal) +
  geom_boxplot() +
  scale_y_log10() +
  theme(axis.text.x = element_blank()) +
  labs(x = "")

# Choisir nous même les couleurs
citations_ecology %>%
  ggplot() +
  aes(x = journal, y = nbtweets, fill = journal) +
  geom_boxplot() +
  scale_y_log10() +
  scale_fill_manual(
    values = c("indianred4", "cornflowerblue", "darkseagreen4")) +
  theme(axis.text.x = element_blank()) +
  labs(x = "")

# Modifier la legende
citations_ecology %>%
  ggplot() +
  aes(x = journal, y = nbtweets, fill = journal) +
  geom_boxplot() +
  scale_y_log10() +
  scale_fill_manual(
    values = c("indianred4", "cornflowerblue", "darkseagreen4"),
    name = "Journal name",
    labels = c("Ecology", "J Animal Ecology", "J Applied Ecology")) +
  theme(axis.text.x = element_blank()) +
  labs(x = "")

# Faire calcul tout en tracant le plot
citations %>%
  count(journal) %>%
  ggplot() +
  aes(x = journal, y = n) +
  geom_col()

# Permutter le sens
citations %>%
  count(journal) %>%
  ggplot() +
  aes(x = n, y = journal) +
  geom_col()

# On ordonne la variable journal selon les effectifs, par défaut classe du plus grand au plus petit
# Directement dans aes
citations %>%
  count(journal) %>%
  ggplot() +
  aes(x = n, y = fct_reorder(journal, n)) +
  geom_col()

# On améliore les noms des axes
citations %>%
  count(journal) %>%
  ggplot() +
  aes(x = n, y = fct_reorder(journal, n)) +
  geom_col() +
  labs(x = "counts", y = "")

# Density plot styleeeee
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets, fill = journal) +
  geom_density() +
  scale_x_log10()

# On ajoute du transparent
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets, fill = journal) +
  geom_density(alpha = 0.5) +
  scale_x_log10()

# On change le fond
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets, fill = journal) +
  geom_density(alpha = 0.5) +
  scale_x_log10() +
  theme_bw()

# Thème classique
citations_ecology %>%
  ggplot() +
  aes(x = nbtweets, fill = journal) +
  geom_density(alpha = 0.5) +
  scale_x_log10() +
  theme_classic()
