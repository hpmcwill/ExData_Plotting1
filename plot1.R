#!/usr/bin/env Rscript
# ================================================================================
#
# Coursera - Exploratory Data Analysis - Course Project 1
#
# Generate plot1.png - a histogram of Global Active Power

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

## create_plot1()
#
# Generate a histogram for Global Active Power.
#
# Usage:
#   create_plot1()
#
create_plot1 <- function() {
  # Download and unpack the source data if required.
  downloadAndUnpackData()
  # Load the data.
  data <- loadSourceData()
  # Set plotting output to PNG.
  png(filename='plot1.png', width=480, height=480)
  # Plot the Global Active Power data as a histogram.
  hist(data$Global_active_power, col='red', main='Global Active Power', 
       xlab='Global Active Power (kilowatts)')
  # Close the PNG device.
  dev.off()
}

# Run plot1 generation.
create_plot1()
