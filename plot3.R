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


#Making date and time vector
DateTime_Vect_F <- as.POSIXct(paste( as.Date(data_HPC_filtered$Date, tryFormats = "%d/%m/%Y" ), data_HPC_filtered$Time ))

#==========================
#======= Plotting =========
#======= Plot 3 ===========
par( bg = NA )

plot(  DateTime_Vect_F, data_HPC_filtered$Sub_metering_1, type="l", ylab="Energy Sub metering", xlab="", cex=0.8)
lines( DateTime_Vect_F, data_HPC_filtered$Sub_metering_2, col='Red')
lines( DateTime_Vect_F, data_HPC_filtered$Sub_metering_3, col='Blue')

legend( "topright", 
        col=c("black", "red", "blue"), 
        lty=1, 
        lwd=1, 
        legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
        cex=0.8 )

dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()