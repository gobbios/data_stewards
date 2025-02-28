xdata <- read.csv("data/reconcilation_data_v2.csv", header = TRUE, dec = ".")

if (!is.data.frame(xdata)) stop("input is not a data frame")

if (nrow(xdata) != 914) stop("not enough lines in the data")

if (any(duplicated(xdata$CaseNr))) stop("duplicated CaseNr")


str(xdata)
xdata$PartSex <- tolower(substr(xdata$PartSex, 1, 1))

if (length(na.omit(unique(xdata$PartSex))) != 2) stop("more than two sexes")

xdata$RconDur <- as.numeric(gsub(pattern = ",", replacement = ".", x = xdata$RconDur, fixed = TRUE))


temp <- table(xdata$Partner, xdata$PartSex, useNA = "always") > 0
check <- rownames(temp[rowSums(temp) > 1 ,])
if (length(check) > 0) {
  stop("Partner ids in 'check' have sex issues")
}


head(table(xdata$Partner, xdata$PartSex))
# 'And' as male occurs once, but it could be 'Ant'










