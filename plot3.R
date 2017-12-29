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
system.time(data3 <- fread(tmp, sep=";", skip=c("1/2/2007"), nrows=nr, data.table=FALSE))
colnames(data3) <- sts
rm(temp, feb1, feb2, nr, sts, tmp)

data3$datetime <- as.POSIXct(paste(data3$Date, data3$Time), format="%d/%m/%Y %H:%M:%S")

png('plot3.png')
plot(data3$datetime, data3$Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering")
lines(data3$datetime, data3$Sub_metering_2, col="red")
lines(data3$datetime, data3$Sub_metering_3, col="blue")
legend("topright",legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = 1, col=c("black", "red", "blue"))
dev.off()