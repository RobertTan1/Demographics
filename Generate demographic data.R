# Load in customer data ---------------------------------------------------

# Generate names
customers <-
  data.frame(
    name = randomNames(5000, name.order = "first.last", name.sep = " "),
    email = NA
  )

# Separate into first and last names
customers <-
  customers %>% tidyr::extract(
    name,
    c("first.name", "last.name"),
    regex = "([^ ]+) (.*)"
  )

# Simulate emails  ------------------------------------

# Prepare some data to simulate emails

vector.domain <- 
  c(
    "outlook.com",
    "gmail.com",
    "yahoo.ca",
    "icloud.com",
    "hotmail.com"
  )

vector.interests <-
  c(
    "Reading",
    "Netflix",
    "Family",
    "Movies",
    "Fishing",
    "Computer",
    "Gardening",
    "Walking",
    "Exercise",
    "Music",
    "Hunting",
    "Sports",
    "Shopping",
    "Traveling",
    "Sleeping",
    "Socializing",
    "Sewing",
    "Golf",
    "Church",
    "Relaxing",
    "Crafts",
    "Bicycles",
    "Hiking",
    "Cooking",
    "Foodie",
    "Swimming",
    "Camping",
    "Skiing",
    "Cars",
    "Writing",
    "Boating",
    "Motorcycling",
    "Bowling",
    "Painting",
    "Running",
    "Dancing",
    "Horseriding",
    "Tennis",
    "Theater",
    "Billiarding",
    "Beach",
    "Volunteer"
  )

vector.separators <- c("_", "", "", "", ".", ".")

# Set number of data points we want to generate
n <- nrow(customers)

# Birthyears - 70% NAs, 20% of 2-digit birthyears, and 10% of 4 digit birthyears
generateNumberAffix <- function(n) {
  vector.temp <- as.character(rep(NA, n))
  choose <- runif(n)
  for (i in 1:n) {
    if (choose[i] < .7) {
      vector.temp[i] <- NA
    } else if (choose[i] < 0.9) {
      vector.temp[i] <-
        rtnorm(
          n = 1,
          mean = 1985,
          sd = 37.5 / 3,
          lower = 1930,
          upper = 2005
        ) %>% round %>% substr(3, 4) %>% str_pad(side = "left",
                                                 width = 2,
                                                 pad = 0)
    } else {
      vector.temp[i] <- rtnorm(
        n = 1,
        mean = 1985,
        sd = 37.5 / 3,
        lower = 1930,
        upper = 2005
      ) %>% round %>% as.character()
    }
  }
  return(vector.temp)
}

# First names - 20% using first character, 60% full first name, 30% NAs
generateFirst <- function(n, namevector) {
  vector.temp <- as.character(rep(NA, n))
  choose <- runif(n)
  for (i in 1:n) {
    if (choose[i] < .2) {
      vector.temp[i] <- substr(namevector[i], 0, 1)
    } else if (choose[i] < 0.7) {
      vector.temp[i] <- namevector[i] %>% stri_trans_tolower()
    } else {
      vector.temp[i] <- NA
    }
  }
  return(vector.temp)
}

# Last names - 70% using first character, 20% using full last name, 10% NAs
generateLast <- function(n, namevector) {
  vector.temp <- as.character(rep(NA, n))
  choose <- runif(n)
  for (i in 1:n) {
    if (choose[i] < .7) {
      vector.temp[i] <- substr(namevector[i], 0, 1)
    } else if (choose[i] < 0.9) {
      vector.temp[i] <- namevector[i]
    } else {
      vector.temp[i] <- NA
    }
  }
  return(vector.temp)
}

# Make vector of interests, 33% are NAs
generateInterest <- function(n) {
  vector.temp <- as.character(rep(NA, n))
  for (i in 1:n) {
    vector.temp[i] <-
      vector.interests[ceiling(length(vector.interests) * runif(1))] %>% 
      tolower
  }
  vector.temp[sample(n)[1:(n/3)]] <- NA
  return(vector.temp)
}

# Make function to generate and glue together first names, last, interest, and birthyears
generateEmail <- function(n) {
  email <- rep("", n)
  
  vector.temp.first <- generateFirst(n, customers$first.name)
  vector.temp.last <- generateLast(n, customers$last.name)
  vector.temp.interests <- generateInterest(n)
  vector.temp.numberAffix <- generateNumberAffix(n)
  vector.temp.domain <- sample(vector.domain, n, replace=T)
  
  for (i in 1:n) {
    email[i] <- paste0(
      na.omit(sample(
        c(
          vector.temp.first[i],
          vector.temp.last[i],
          vector.temp.interests[i]
        )
      )) %>% as.vector() %>%  paste0(collapse = vector.separators[ceiling(runif(1) * length(vector.separators))]) %>% 
        as.character(),
      vector.temp.numberAffix[i] %>% na.omit() %>% c() %>% as.character(),
      "@",
      vector.temp.domain[i]
    )
  }
  return(email)
}



# Generate postal codes from latlongs -------------------------------------
lat <-
  rtnorm(
    n,
    lower = 43.630060,
    upper = 43.761095,
    mean = 43.648917,
    sd = (43.761095-43.630060)/5
  ) %>% round(6)

long <- 
  rtnorm(
    n,
    lower = -79.453596,
    upper = -79.305476,
    mean = -79.387681,
    sd = (79.453596-79.305476)/3
  ) %>% round(6)

latlong <- paste(lat,long, sep=",")


# Append data to customers dataset ----------------------------------------

# Append emails to customers dataset
customers$email <- generateEmail(n)

# Guess gender

temp <- gender(customers$first.name) %>% unique() %>% select(name,gender)

customers <- customers %>% left_join(temp,by=c("first.name"="name"))

# Guess ethnicity

ethn.temp <- predict_race(voter.file = tibble(surname=customers$last.name), surname.only = T)
ethn.temp %<>% gather(race, value, 2:6)
ethn.temp %<>% group_by(surname) %>% arrange(desc(value)) %>% top_n(1, value)

ethn.temp$race %<>% recode(
  "pred.whi" = "white",
  "pred.oth" = "other",
  "pred.his" = "hispanic",
  "pred.bla" = "black",
  "pred.asi" = "asian"
)

customers <- customers %>% 
  left_join(ethn.temp[,-3], by=c("last.name"="surname")) %>% 
  distinct() %>% head(n=5000)

customers <- customers[1:5000,]

# Reverse geocode

url.vector <- paste0("https://maps.googleapis.com/maps/api/geocode/json?latlng=",
                    lat,
                    ",",
                    long,
                    "&key=",
                    key)

chunk_size <- 50

parsed_url_geocode <- list()

# Reverse geocode in chunks
for (i in 1:ceiling(length(url.vector) / chunk_size)) {
  parsed_url_geocode[[i]] <-
    getURLAsynchronous(url.vector[(i + (i - 1) * (chunk_size - 1)):(i * chunk_size)])
  Sys.sleep(.1)
}

z=1

for (i in 1:length(parsed_url_geocode)) {
  for (j in 1:length(parsed_url_geocode[[i]])) {
    cleaned_df[z] <- jsonlite::fromJSON(parsed_url_geocode[[i]][j])
    z = z + 1
  }
}

final.df <- data.frame(NA)

bad_calls <- which(cleaned_df=="You have exceeded your rate-limit for this API.")

good_calls <- 1:5000

good_calls <- good_calls[-bad_calls]

final.df <- rep(NA,5000)

for (i in good_calls) {
  final.df[i] <-
    cleaned_df[[i]]$address_components[[1]][cleaned_df[[1]]$address_components[[1]]$types ==
                                              "postal_code", ]$long_name
}

latlong.postal <- data.frame(latlong = latlong, postal_code <- final.df)

customers <- customers %>% bind_cols(latlong.postal)

customers %<>% na.omit
