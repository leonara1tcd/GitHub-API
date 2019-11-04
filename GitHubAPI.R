#install.packages
library(jsonlite)
library(httpuv)
library(httr)

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
