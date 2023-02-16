#Loading the necessary packages

library(readxl)
library(dplyr)
library(ggplot2)
library(curl)
library(XLS)

#importing data from "council on foreign relations"

url <- "https://docs.google.com/spreadsheets/d/1_QY-l4xhMu5nZVluprOgRs6rUzgkkBemapdsg5lFzKU/pub?output=xlsx"
destfile <- "pub_output_xlsx.xls"
curl::curl_download(url, destfile)
pub_output_xlsx <- read_xlsx(destfile)

dataset <- read_xlsx("pub_output_xlsx.xls")

#filtering events where either the army or police perpetrated violence against civilians

police_army_violence <- dataset %>% 
  filter(!is.na(`State Actor (P)`)) %>%
  filter(!is.na(`Civilian (V)`))

ggmap(police_army_violence,aes(`Longitude`,`Latitude`))
