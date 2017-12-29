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
system.time(data1 <- fread(tmp, sep=";", skip=c("1/2/2007"), nrows=nr, data.table=FALSE))
colnames(data1) <- sts
rm(temp, feb1, feb2, nr, sts, tmp)

png('plot1.png')
hist(data1$Global_active_power, col="red", main = 'Global Active Power', 
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency")
dev.off()