pollutantmean <- function(directory, pollutant, id = 1:332) {
	## input files
	filePath <- file.path(directory, sprintf("%03d.csv", id))
	tmp <- lapply(filePath, read.csv)
	airpollutant <- do.call(rbind, tmp)

	## caculate mean
	Mean <- mean(airpollutant[,pollutant], na.rm = TRUE)
    Mean
}
