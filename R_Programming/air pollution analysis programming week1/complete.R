complete <- function(directory, id = 1:332) {
	## input files
	filePath <- file.path(directory, sprintf("%03d.csv", id))
	tmp <- lapply(filePath, read.csv)
	airpollutant <- do.call(rbind, tmp)
	## create an empty data frame
	comcases <- data.frame()
	## compute the complete cases
	for (i in id){
		subset <- airpollutant[which(airpollutant$ID == i),]
		com <- sum(complete.cases(subset))
		case <- c(i,com)
		comcases <- rbind.data.frame(comcases,case)
	}
	## change data frame colnames
	names(comcases)[1] <- "id"
	names(comcases)[2] <- "nobs"
	## return value
	comcases
}
