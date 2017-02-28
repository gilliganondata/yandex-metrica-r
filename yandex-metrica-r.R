# Script to pull some data from Yandex Metrics

library(httr)
library(tidyverse)

# Authorization. Lot's o' Greek to me.
app_name <- "yandex_metrica"
client_id <- "62cef6b1598d450ba306960aea621060"
pwd <- "fa81c235e1ce4e969df5b2bf09fcb51f"
resource_uri <- "https://oauth.yandex.com/authorize?response_type=code"

yandex_endpoint <- oauth_endpoint(authorize = "https://oauth.yandex.com/authorize?response_type=code",
                                  access = "https://oauth.yandex.com/access?response_type=code")

myapp <- oauth_app("yandex_metrica",
                   key = client_id,
                   secret = NULL)

mytoken <- oauth2.0_token(yandex_endpoint, myapp,
                          user_params = list(resource = resource_uri),
                          use_oob = FALSE)

test <- GET("https://api-metrika.yandex.ru/stat/v1/data",
            query = list(metrics = "ym:s:hits",
                         id = "42846864"))





# ID: 62cef6b1598d450ba306960aea621060
# Password: fa81c235e1ce4e969df5b2bf09fcb51f
# Callback URL: http://localhost:1410/

