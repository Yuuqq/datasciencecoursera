best <- function(state, outcome) {
      ## Read outcome data
      outcomedata <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
      ## Check that state and outcome are valid
      # check the state
      stateName <- unique(outcomedata$State)
      if (!(state %in% stateName)){
            stop("invalid state")
      }
      # check the outcome
      if (outcome == "heart attack"){
            subdata <- outcomedata[which(outcomedata$State == state),c(2,11)]
      } else if (outcome == "heart failure"){
            subdata <- outcomedata[which(outcomedata$State == state),c(2,17)]
      } else if (outcome == "pneumonia"){
            subdata <- outcomedata[which(outcomedata$State == state),c(2,23)]
      } else {
            stop("invalid outcome")
      }
      ## Return hospital name in that state with lowest 30-day death
      subdata[,2] <- suppressWarnings(as.numeric(subdata[,2]))
      good <- complete.cases(subdata)
      subdata <- subdata[good,]

      min_val <- min(subdata[,2])
      best_hospitals <- subdata[subdata[,2] == min_val, 1]

      ## return first alphabetically
      x <- sort(best_hospitals)[1]

      ## rate
      x
}
