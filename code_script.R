#importing updated data from council on foreign relations

library(readxl)
library(dplyr)
library(ggplot2)
library(curl)
library(XLS)

url <- "https://docs.google.com/spreadsheets/d/1_QY-l4xhMu5nZVluprOgRs6rUzgkkBemapdsg5lFzKU/pub?output=xlsx"
destfile <- "pub_output_xlsx.xls"
curl::curl_download(url, destfile)
pub_output_xlsx <- read_xlsx(destfile)

dataset <- read_xlsx("pub_output_xlsx.xls")

#filtering data for events in Lagos state 
#Also filtering events where perpetrator is the police against civilians
 Lagos_events <- dataset %>% 
   filter(State == "Lagos" )%>%
 filter(!is.na(`State Actor (P)`))%>%
   mutate(Incident = 1)
 
 #We will create a column of Year to determine events by the year in which the occurred 
 Police_killing_lagos <- Lagos_events %>% 
   mutate(year = format(Date,format = "%Y")) %>%
   select(year,Date,`Community (city,town, ward)`,Incident,`Civilian (V)`,'Gun',Latitude,Longitude)%>%
  mutate(`Civilian (V)` = ifelse(is.na(`Civilian (V)`),0,`Civilian (V)`)) %>%
  mutate(cummulative_death = cumsum(`Civilian (V)`))

#plotting a time series plot

ggplot(Police_killing_lagos,aes(Date,cummulative_death)) +
geom_line(linewidth = 1) +
geom_vline(xintercept = as.POSIXct(as.Date("2020-10-20")),linetype = "dashed") +
annotate("text",x =  as.POSIXct(as.Date("2020-7-20")),y = 150,angle = 90,label = "ENDSARS PROTEST")
   
 
Death_by_year <-Police_killing_lagos %>%
  group_by(year)%>%
  summarise(Total_death = sum(`Civilian (V)`),Total_incident = sum(Incident))

#To find out the number of people that die between the month of October,2020.
End_sars_deaths <- Lagos_events%>%
  filter(between(Date, as.POSIXct("2020-10-01"),as.POSIXct("2020-10-31")))%>%
  summarise(sum(`Civilian (V)`,na.rm = TRUE))

End_sars_events <- Lagos_events%>%
  filter(between(Date, as.POSIXct("2020-10-01"),as.POSIXct("2020-10-31")))