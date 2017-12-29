require(data.table)

temp <- tempfile()
if (!file.exists("household_power_consumption.txt")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  unzip(temp, "household_power_consumption.txt")
}

tmp = "household_power_consumption.txt"
sts <- unlist(strsplit(readLines(tmp)[1], ";"))
feb1 <- grep("1/2/2007", readLines(tmp), fixed=TRUE)[1]
feb2 <- grep("3/2/2007", readLines(tmp), fixed=TRUE)[1]
nr <- feb2 - feb1
system.time(data4 <- fread(tmp, sep=";", skip=c("1/2/2007"), nrows=nr, data.table=FALSE))
colnames(data4) <- sts
rm(temp, feb1, feb2, nr, sts, tmp)

data4$datetime <- as.POSIXct(paste(data4$Date, data4$Time), format="%d/%m/%Y %H:%M:%S")

png('plot4.png')
par(mfrow = c(2,2), mar = c(5,5,3,2))
with(data4, {
  plot(datetime, Global_active_power, type="l", xlab = "", ylab = "Global Active Power")
  plot(datetime, Voltage, type="l")
  plot(datetime, Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering")
  lines(datetime, Sub_metering_2, col="red")
  lines(datetime, Sub_metering_3, col="blue")
  legend("topright",legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = 1, col=c("black", "red", "blue"))
  plot(datetime, Global_reactive_power, type="l")
})
dev.off()