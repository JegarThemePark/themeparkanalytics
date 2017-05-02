library("rvest")
url <- "http://en.wikipedia.org/wiki/List_of_Disney_theme_park_attractions"
population <- url %>%
  html() %>%
  html_nodes(xpath='//*[@id="mw-content-text"]/table[1]') %>%
  html_table()
population <- population[[1]]

head(population)