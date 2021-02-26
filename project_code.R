# Libraries Used:
library(dplyr)
library(forecast)


# Data:
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
data_str = data[order(data$Date),]
summary(data_str)

# Missing Values:
apply(is.na(data_str), 2, any)  # Columns containing missing data
round(sum(complete.cases(data_str))*100/nrow(data_str),4)  # Percentage of Data that is free of NA
data_list = list()

for(i in 1:length(unique(data_str$Currency)))
  data_list[[i]] = data_str %>% filter(Currency == unique(data_str$Currency)[i])
names(data_list) = unique(data_str$Currency)
for(i in 1:length(unique(data_str$Currency)))
  if(any(is.na(data_list[[i]]$Close))==T)
    cat(unique(data_list[[i]]$Currency), i,"\n")  # Which currencies have missing data 

# Estimating missing values:
for(i in c(4,7,10)){
  data_list[[i]]$Close = na.interp(data_list[[i]]$Close)
}

# Computation of logreturns and study of the closing prices:
for(i in 1:length(unique(data_str$Currency)))
  for(j in 2:nrow(data_list[[i]]))
    data_list[[i]]$logreturns[j]=log(abs(data_list[[i]]$Close[j]-data_list[[i]]$Close[j-1]))
par(mfrow=c(1,2))
for(i in 1:length(unique(data_str$Currency))){
  hist(data_list[[i]]$Close, main=paste("Histogram of closing price of",unique(data_str$Currency)[i]), xlab="Closing Price")
  hist(data_list[[i]]$logreturns, main=paste("Histogram of logreturns of",unique(data_str$Currency)[i]), xlab="Logreturns")
  cat("For",unique(data_str$Currency)[i],":\n")
  print(summary(data_list[[i]]$logreturns))
  cat("\n\n")
}
