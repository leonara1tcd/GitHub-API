install.packages("plotly")
library(plotly)
library(jsonlite)
library(httpuv)
library(httr)
require(devtools)

oauth_endpoints("github")

myapp = oauth_app(appname = "APIGitHub",
                  key = "88664fb848ade320a2b8",
                  secret = "48b2d0e143b4701f2ea3226d58b0d2c16107eec7")

# Get OAuth credentials
github_token = oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

#Error handling
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

#Interogating the GitHub API to extract data about my own account and summarise graphically


myData = GET("https://api.github.com/users/mbostock/followers?per_page=100;", gtoken)
extract = content(myData)
stop_for_status(myData)
githubDB = jsonlite::fromJSON(jsonlite::toJSON(extract))
githubDB$login

#Create an empty vector and data.frame
users = c()
usersDB = data.frame(
  username = integer(),
  following = integer(),
  followers = integer(),
  repos = integer(),
  dateCreated = integer()
)

#Retrieve a list of usernames
id = githubDB$login
user_ids = c(id)

#Loops through users and adds to list
for(i in 1:length(user_ids))
{
  followingURL = paste("https://api.github.com/users/", user_ids[i], "/following", sep = "")
  followingRequest = GET(followingURL, gtoken)
  followingContent = content(followingRequest)
  
  if(length(followingContent) == 0)
  {
    next
  } 
  followingDF = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
  followingLogin = followingDF$login
  
  for (j in 1:length(followingLogin))
  {
    if (is.element(followingLogin[j], users) == FALSE)
    {
      users[length(users) + 1] = followingLogin[j]
      
      #Obtaining information from each user
      followingUrl2 = paste("https://api.github.com/users/", followingLogin[j], sep = "")
      following2 = GET(followingUrl2, gtoken)
      followingContent2 = content(following2)
      followingDF2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent2))
      
      #Retrieving who user is following
      followingNumber = followingDF2$following
      
      #Retrieving users followers
      followersNumber = followingDF2$followers
      
      #Retrieving how many repository the user has 
      reposNumber = followingDF2$public_repos
      
      #Retrieving year which each user joined Github
      yearCreated = substr(followingDF2$created_at, start = 1, stop = 4)
      
      #Add users data to a new row in dataframe
      usersDB[nrow(usersDB) + 1, ] = c(followingLogin[j], followingNumber, followersNumber, reposNumber, yearCreated)
      
    }
    next
  }
  #Stop when there are more than 150 users
  if(length(users) > 150)
  {
    break
  }
  next
}

#Created link to plotly which creates online interactive graphs.
Sys.setenv("plotly_username"="leonara1")
Sys.setenv("plotly_api_key"="yiFJeOMQXwYvetnbAdYq")

#Plot 1 graphs repositories vs followers by year.
#The data is represented by a scatter plot.
#X-axis displays 'repositories' which shows the no. of repositories per user.
#Y-axis displays 'followers' which shows the no. of followers of each each of mbostock's followers.
plot1 = plot_ly(data = usersDB, x = ~repos, y = ~followers, text = ~paste("Followers: ", followers, "<br>Repositories: ", repos, "<br>Date Created:", dateCreated), color = ~dateCreated)
plot1

#Sends graph to plotly - located at https://plot.ly/~leonara1/1/#/
api_create(plot1, filename= "Followers vs Repos")

#Plot 2 graphs following vs followers by year.
#The data is represented by a scatter plot.
#X-axis displays 'following' which shows the no. of users followed by each of mbostock's followers.
#Y-axis displays 'followers' which shows the no. of followers of each of mbostock's followers.
plot2 = plot_ly(data = usersDB, x = ~following, y = ~followers, text = ~paste("Followers: ", followers, "<br>Following: ", following), color = ~dateCreated)
plot2

#Sends graph to plotly - located at https://plot.ly/~leonara1/3/#/
api_create(plot2, filename = "Following vs Followers")
