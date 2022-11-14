#importing updated data from council on foreign relations

library(readxl)
url <- "https://docs.google.com/spreadsheets/d/1_QY-l4xhMu5nZVluprOgRs6rUzgkkBemapdsg5lFzKU/pub?output=xlsx"
destfile <- "pub_output_xlsx.xls"
curl::curl_download(url, destfile)
pub_output_xlsx <- read_excel(destfile)

dataset <- read_xlsx("pub_output_xlsx.xls")
