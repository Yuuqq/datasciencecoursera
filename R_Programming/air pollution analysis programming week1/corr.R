corr <- function(directory, threshold = 0) {
	## subset the completely cases above threshold
	comcases <- complete(directory)
	aboveThreshold <- comcases[which(comcases$nobs > threshold),]
	aboveID <- aboveThreshold$id

	if (length(aboveID) == 0) {
        return(numeric(0))
    }

	## input files for only above threshold
	filePath <- file.path(directory, sprintf("%03d.csv", aboveID))
	tmp <- lapply(filePath, read.csv)
	airpollutant <- do.call(rbind, tmp)

	subcases <- data.frame()
	for (i in aboveID){
		subcases <- rbind(subcases,airpollutant[which(airpollutant$ID == i),])		
	}
	good <- complete.cases(subcases)
	subcases <- subcases[good,]
	## caculate the correlation of two variables
	cr <- numeric()
	for (x in aboveID){
		minisub <- subcases[which(subcases$ID == x),]
      	nitrateAbove <- minisub$nitrate
      	sulfateAbove <- minisub$sulfate
      	cr <- append(cr,cor(nitrateAbove,sulfateAbove))
    }
    cr
}
