# Script to pull some data from Yandex Metrics

# Details of when the app was set up in Yandex's dev console:
# ID: 62cef6b1598d450ba306960aea621060
# Password: fa81c235e1ce4e969df5b2bf09fcb51f
# Callback URL: http://localhost:1410/

library(httr)
library(tidyverse)

# Authorization. Lot's o' Greek to me.

# This is fine -- not really *used* for OAuth, part of the oauth_app() call
app_name <- "yandex_metrica"

# This seems right -- the ID from the Yandex API app I set up
client_id <- "62cef6b1598d450ba306960aea621060"

# This is the "password" from that Yandex API app. It seems different from
# a "client secret" -- not really sure if it's needed at all.
pwd <- "fa81c235e1ce4e969df5b2bf09fcb51f"

# I'm not sure if this is actually getting used in the right place
resource_uri <- "https://oauth.yandex.com/authorize?response_type=code"

# The "authorize" URL seems right. I'm not so sure about the "access" value. I think
# that may be where things are breaking, except I *am* getting a .httr-oauth file 
# created that sure looks like a token.
yandex_endpoint <- oauth_endpoint(authorize = "https://oauth.yandex.com/authorize?response_type=code",
                                  access = "https://oauth.yandex.com/token?response_type=code")

myapp <- oauth_app(app_name,
                   key = client_id,
                   secret = pwd)

mytoken <- oauth2.0_token(yandex_endpoint, myapp,
                          user_params = list(resource = resource_uri),
                          use_oob = FALSE)

token_full <- readRDS(".httr-oauth")
token <- names(token_full[1])

test_data <- GET("https://api-metrika.yandex.ru/stat/v1/data.csv",
                 query = list (id = "42846864",
                               metrics="ym:s:avgPageViews",
                               dimensions="ym:s:operatingSystem",
                               limit= "5",
                               oauth_token=token))

# test_data <- GET("https://api-metrika.yandex.ru/stat/v1/data",
#                  query = list (id = "42846864",
#                                metrics="ym:s:avgPageViews",
#                                dimensions="ym:s:operatingSystem",
#                                limit= "5",
#                                oauth_token="9e25df6a69731d3ac1738071c5a04bf5"))

check_stat <- http_status(test_data)






