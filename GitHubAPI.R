#install.packages
library(jsonlite)
library(httpuv)
library(httr)
install.packages("plotly")
require(devtools)
library(plotly)

oauth_endpoints("github")

myapp = oauth_app(appname = "APIGitHub",
                   key = "88664fb848ade320a2b8",
                   secret = "48b2d0e143b4701f2ea3226d58b0d2c16107eec7")

# Get OAuth credentials
github_token = oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken = config(token = github_token)
UserFollowingData = GET("https://api.github.com/users/jtleek/following", gtoken)
UserFollowingDataContent = content(UserFollowingData)
UserFollowingDataFrame = jsonlite::fromJSON(jsonlite::toJSON(UserFollowingDataContent))

followersLogins = c(UserFollowingDataFrame$login)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

#Interogating the GitHub API to extract data about my own account and summarise graphically

#Gets my data 
myData = fromJSON("https://api.github.com/users/leonara1tcd")

#Displays no. of followers
myData$followers

followers = fromJSON("https://api.github.com/users/leonara1tcd/followers")
followers$login #Gives user names of all my followers

myData$following #Displays the no. of people I am following

following = fromJSON("https://api.github.com/users/leonara1tcd/following")
following$login #Gives the names of all the people I am following

myData$public_repos #Displays the no. of repositories I have

repos = fromJSON("https://api.github.com/users/leonara1tcd/repos")
repos$name #Names of my public repositories
repos$created_at #Gives details of the dates the repositories were created 
repos$full_name #gives names of repositories
