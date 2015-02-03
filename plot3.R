#!/usr/bin/env Rscript
# ================================================================================
#
# Coursera - Exploratory Data Analysis - Course Project 1
#
# Generate plot3.png - a graph of Energy sub metering

## downloadAndUnpackData()
#
# Download and unpack the source data.
#
# Note: will not update/overwrite existing copies of the data. Warnings are 
# reported if the source data file and/or the unpacked data directory already 
# exist.
#
# Usage:
#   downloadAndUnpackData()
#
downloadAndUnpackData <- function() {
  file_url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  file_name <- 'household_power_consumption.zip'
  data_file_name <- 'household_power_consumption.txt'
  # Download data archive.
  if(!file.exists(file_name)) {
    message('Downloading data from Internet')
    # If available use the 'downloader' package to deal with HTTPS sources.
    if(require(downloader, quietly=TRUE)) {
      download(file_url,destfile=file_name)
    }
    # Otherwise use the built-in (has problems with HTTPS on non-Windows platforms)
    else {
      download.file(file_url, file_name, mode='wb', method='auto')
    }
  }
  else {
    warning('Local copy of data archive found, not downloading')
  }
  # Unpack data archive if data not already present.
  if(!file.exists(data_file_name)) {
    message('Unpacking downloaded data archive.')
    unzip(file_name)
  }
  else {
    warning('Existing data file found, not unpacking data archive.')
  }
}

## loadSourceData()
#
# Load the source data into a single data.frame adding a 'datetime' column 
# based on the Date and Time columns in the source data.
#
# Usage:
#   srcData <- loadSourceData()
#
loadSourceData <- function() {
  # Read cached data if available.
  cacheDataFile <- 'household_power_consumption.rds'
  if(file.exists(cacheDataFile)) {
    data <- readRDS(cacheDataFile)
  }
  else {
    # Read data for 2007-02-01 and 2007-02-02
    srcData <- read.csv('household_power_consumption.txt', header=TRUE, sep=';', 
                     na.strings='?', stringsAsFactors=FALSE)
    data <- subset(srcData, Date == "1/2/2007" | Date == "2/2/2007")
    data$datetime <- strptime(sprintf('%s %s', data$Date, data$Time), format='%d/%m/%Y %T')
    # Save processed data to a cache file for faster loading.
    saveRDS(data, cacheDataFile)
  }
  data
}

## create_plot3()
#
# Generate a graph for Energy sub metering.
#
# Usage:
#   create_plot3()
#
create_plot3 <- function() {
  # Download and unpack the source data if required.
  downloadAndUnpackData()
  # Load the data.
  data <- loadSourceData()
  # Set plotting output to PNG.
  png(filename='plot3.png', width=480, height=480)
  # Plot a graph for Energy sub metering.
  plot(data$datetime, data$Sub_metering_1, type='l', xlab='',
       ylab='Energy sub metering')
  lines(data$datetime, data$Sub_metering_2, col='red')
  lines(data$datetime, data$Sub_metering_3, col='blue')
  legend('topright', col=c('black', 'red', 'blue'), lty=par('lty'),
         legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'))
  # Close the PNG device.
  dev.off()
}

# Run plot3 generation.
create_plot3()
