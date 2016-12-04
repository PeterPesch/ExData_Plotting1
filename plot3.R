## plot3.R
##
## This code creates the file plot3.png, containing plot 1 from the assignment.
##
## Peter Pesch, 4 december 2016
##

############ Reusable part (would normaly go into separate R file) ############
##                                                                           ##
##  (The assignment states that each source file should contain the code     ##
##   for reading the data.)                                                  ##
##                                                                           ##

## Make sure there is a data subfolder:
dataDir <- "./data"
if (!file.exists(dataDir)) {dir.create(dataDir)}
## We need a subset of the complete dataset. First check whether it is already there:
subsetPath <- "./data/hpcSubset.csv"
if (!file.exists(subsetPath)) {
    ## subset doesn't exist, so we'll need the complete dataset.
    ## First check whether the complete data file is already there:
    hpcFilePath <- "./data/household_power_consumption.txt"
    if (!file.exists(hpcFilePath)){
        ## complete data file not found, so we'll need the zipfile
        zipFilePath <- "./data/household_power_consumption.zip"
        if (!file.exists(zipFilePath)){
            ## zipfile not found, so let's download it.
            zipFileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
            download.file(zipFileUrl, destfile=zipFilePath)
            print("Downloading the zip file ...")
            rm(zipFileUrl)
        }
        ## Now we have the zipfile, so let's extract the data file
        print("Extracting the data file ...")
        unzip(zipFilePath, files="household_power_consumption.txt", exdir=dataDir)
        rm(zipFilePath)
    }
    ## No we have the complete data file so let's use it.
    print("Reading the complete data file ...")
    completeRawData  <- read.csv2(hpcFilePath, na.strings = "?")
    rm(hpcFilePath)
    ## Now we have the complete dataset, and we have to make the subset
    filter <- (completeRawData$Date == "1/2/2007") |    ## 1 feb 2007
              (completeRawData$Date == "2/2/2007")      ## 2 feb 2007
    hpcSubset <- completeRawData[filter, ]
    ## Let's save the subset, so we can reuse it anytime we want.
    write.csv(hpcSubset, file=subsetPath)
    rm(completeRawData)
    rm(filter)
} else {
    ## subset already exists, so let's reuse it.
    print("Reading the subset ...")
    hpcSubset <- read.csv(file=subsetPath, row.names=1)
}
rm(subsetPath)
rm(dataDir)

##                                                                           ##
## Now we have hpcSubset, which consists of the 2880 lines from 1-2 feb 2007 ##
##                                                                           ##
#########################  End of reusable part  ##############################

## Correct classes:
hpcSubset <- with(hpcSubset,
    data.frame(
        DateTime                = as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S"),
        Global_active_power     = as.numeric(as.character(Global_active_power)),
        Global_reactive_power   = as.numeric(as.character(Global_reactive_power)),
        Voltage                 = as.numeric(as.character(Voltage)),
        Global_intensity        = as.numeric(as.character(Global_intensity)),
        Sub_metering_1          = as.numeric(as.character(Sub_metering_1)),
        Sub_metering_2          = as.numeric(as.character(Sub_metering_2)),
        Sub_metering_3          = as.numeric(as.character(Sub_metering_3))
    )
)

## Creating Plot 3:
png(filename="plot3.png",
    width=480, height=480
)
with(hpcSubset, {
    plot(DateTime, Sub_metering_1,
         type="l", col="gray40",
         xlab="",ylab="Energy sub metering")
    points(DateTime, Sub_metering_2,
         type="l", col="red")
    points(DateTime, Sub_metering_3,
         type="l", col="blue")
    legend("topright", lty = 1,
       col = c("gray40", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
dev.off()
print("Created Plot 3.")
