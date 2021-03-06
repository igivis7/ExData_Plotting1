# clean environment
rm(list=ls())

# clean console
cat("\014")  

# clear all plots in RStudio
if (length(dev.list())!=0) dev.off(dev.list()["RStudioGD"])

# read data from file
data_HPC <- read.table(file="../household_power_consumption.txt", sep = ";", header = TRUE, na.strings="?" )

#Create separate vector of Dates to study
Date_Vect <- as.Date(data_HPC$Date, tryFormats = "%d/%m/%Y" )

# Find out which data should be exactly
# Filter Dates to keep only Thursdays and Fridays of February 2007 
# "Freitag" and "Donnerstag" are for German names of the days. Due to system adjustment
data_HPC_2007Feb_ThFrs <- data_HPC[
  which(
    (format(Date_Vect, format="%m%Y") == "022007")
    &(
      weekdays(Date_Vect) == "Freitag"
      |
      weekdays(Date_Vect) == "Donnerstag"
    )  )  ,]

ind_diff <- which(diff(as.numeric( as.POSIXct(data_HPC_2007Feb_ThFrs$Date[], tryFormats = "%d/%m/%Y") ) ) > 0)
# plot( as.Date(   data_HPC_2007Feb_ThFrs$Date[],    tryFormats="%d/%m/%Y"), type ="l")
#From the plot in previous line: The date change shows that the 1st pair of Thursday-Friday corresponding to indexes 1:ind_diff[2]
data_HPC_filtered <- data_HPC_2007Feb_ThFrs[1:ind_diff[2],]

#==========================
#======= Plotting =========
#======= Plot 1 ===========
par( bg = NA )

hist(data_HPC_filtered$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red", cex.sub=0.8)

# export file
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()