library(curl)

pool <- new_pool()

result <- list()

# results only available through call back function
cb <- function(req){
    result <<- append(result, list(rawToChar(req$content) %>% fromJSON()))
  }

# example vector of uris to loop through
uris <- url.vector[1:100]

# all scheduled requests are performed concurrently
sapply(uris, curl_fetch_multi, done=cb, pool=pool)

# This actually performs requests
out <- multi_run(pool = pool)


