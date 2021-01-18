data = read.csv(file.choose())
str(data)  # Checking the data types

# Changing the data types:
data$Currency = as.character(data$Currency)
data$Date = as.Date(data$Date, format = "%b %d, %Y")
data$Open = as.numeric(data$Open)
data$High = as.numeric(data$High)
data$Low = as.numeric(data$Low)
data$Close = as.numeric(data$Close)
data$Volume = as.numeric(gsub(",","",data$Volume))
data$Market.Cap = as.numeric(gsub(",","",data$Market.Cap))
summary(data)

# Missing Values:
apply(is.na(data), 2, any)
library(mice)  # Importing "mice" package
md.pattern(data)  # Display missing-data patterns
