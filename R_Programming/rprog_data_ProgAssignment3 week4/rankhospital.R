rankhospital <- function(state, outcome, num = "best") {
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
      ## Return hospital name in that state with the given rank
      subdata[subdata[,2] == "Not Available", 2] <- NA

      good <- complete.cases(subdata[,2])
      subdata <- subdata[good,]
      subdata[,2] <- as.numeric(subdata[,2])
      rankeddata <- subdata[order(subdata[,2],subdata$Hospital.Name),]
      x <- character()
      if (num == "best"){
            x <- rankeddata[1,1]
      } else if (num == "worst"){
            x <- rankeddata[nrow(rankeddata),1]
      } else {
            x <- rankeddata[num,1]
      }
      x
}
