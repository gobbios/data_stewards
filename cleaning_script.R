xdata <- read.csv("data/reconcilation_data_v2.csv")

if (!is.data.frame(xdata)) stop("input is not a data frame")

if (any(duplicated(xdata$CaseNr))) stop("duplicated CaseNr")

xdata$PartSex <- tolower(substr(xdata$PartSex, 1, 1))
temp <- table(xdata$Partner, xdata$PartSex, useNA = "always") > 0
check <- rownames(temp[rowSums(temp) > 1 ,])
if (length(check) > 0) {
  stop("Partner ids in 'check' have sex issues")
}

check <- which(xdata$Subject == xdata$Partner)
if (length(check) > 0) {
  stop("rows in check: partner is the same as the subject")
}

