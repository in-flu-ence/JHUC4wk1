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
system.time(data2 <- fread(tmp, sep=";", skip=c("1/2/2007"), nrows=nr, data.table=FALSE))
colnames(data2) <- sts
rm(temp, feb1, feb2, nr, sts, tmp)

data2$datetime <- as.POSIXct(paste(data2$Date, data2$Time), format="%d/%m/%Y %H:%M:%S")

png('plot2.png')
plot(data2$datetime, data2$Global_active_power, type="l", xlab = "", ylab = "Global Active Power (kilowatts)")
dev.off()