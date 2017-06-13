# Demo script to pull some data from Yandex Metrica

# This requires setting up an OAuth access token, which you can do
# by clicking on "API" in the global navigation once logged into Yandex Metrics.

# Set the callback URL to: http://localhost:1410/

# Add the ID and password to a .Renviron file that looks like this (without the
# "# " on each line, and without the "[]" brackets):

# YANDEX_APP_ID=[the client ID for your app]
# YANDEX_APP_PWD=[the password for your app]
# YANDEX_COUNTER_ID=[the ID for your counter (site), this will be 
#                    in your reporting interface and will be a ~8-digit #]

# We're only using a couple of libraries. 
library(httr)
library(tidyverse)

###################
# Settings

# Read the values from the .Renviron file
client_id <- Sys.getenv("YANDEX_APP_ID")
pwd <- Sys.getenv("YANDEX_APP_PWD")
counter_id <- Sys.getenv("YANDEX_COUNTER_ID")

# Set the preferred language for the results. I assume this is some ISO 2-letter code.
lang <- "en"

# Set up the dimension to be used. Currently, this only supports a single
# dimension, as the cleanup later on only works with one. The API totally
# supports multiple dimensions -- that's just not coded here (yet).
dimensions <- "ym:s:operatingSystem"

# Set up one or multiple metrics
metrics <- c("ym:s:visits","ym:s:pageviews","ym:s:bounces")

# Set the start and end date in "YYYY-MM-DD" format
start_date <- "2017-02-20"
end_date <- "2017-03-05"

###################
# Authentication Lot's o' Greek to me.

# This is fine -- not really *used* for OAuth, part of the oauth_app() call
app_name <- "yandex_metrica"

# I'm not sure if this is actually getting used in the right place... but it seems to work
resource_uri <- "https://oauth.yandex.com/authorize?response_type=code"

# Generate the "endpoint." This should prompt as to whether to generate
# a .httr-oauth file to use as a future reference.
yandex_endpoint <- oauth_endpoint(authorize = "https://oauth.yandex.com/authorize?response_type=code",
                                  access = "https://oauth.yandex.com/token?response_type=code")

# Create the "app?" Maybe?
myapp <- oauth_app(app_name,
                   key = client_id,
                   secret = pwd)

# Get the full token.
mytoken <- oauth2.0_token(yandex_endpoint, myapp,
                          user_params = list(resource = resource_uri),
                          use_oob = FALSE)

# Get the actual token string to be used in the query(ies)
token <- mytoken$credentials$access_token

###################
# Get the data

# This actually pulls the data. See https://tech.yandex.com/metrika/doc/api2/api_v1/intro-docpage/
# for details on the various parameters that can be used.
web_data <- GET("https://api-metrika.yandex.ru/stat/v1/data",
                 query = list (id = counter_id,
                               date1 = start_date,
                               date2 = end_date,
                               metrics = paste(metrics, collapse = ","),
                               dimensions = paste(dimensions, collapse = ","),
                               lang = lang,
                               oauth_token = token))

# What gets returned has more in it than we really want, so we need to get
# just the *content* of the request and then pretty that up a bit
web_data_content <- content(web_data)
web_data_content <- web_data_content$data 

# Convert that data to a data frame. 
web_data_df <- data.frame(matrix(unlist(web_data_content), 
                                 nrow=length(web_data_content), byrow=T),stringsAsFactors=FALSE)

# Drop a few columns that are meta data that we're not going to use (for now)
web_data_df <- select(web_data_df, -X2, -X3, -X4, -X5)

# Rename the columns
names(web_data_df) <- c(dimensions, metrics)
