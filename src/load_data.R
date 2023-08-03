# load data
# it's bad practice to load all dataframes all at once as global variables
fireNumber <<- read.csv(file="./data/Cleaned_Number_of_fires_by_month.csv", header=TRUE, sep=",")
fireArea <<- read.csv("./data/Cleaned_Area_burned_by_month.csv", header=TRUE, sep=",")
fireLoss <<- read.csv("./data/Cleaned_Property_losses.csv", header=TRUE, sep=",")