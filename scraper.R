#!/usr/bin/Rscript

## This tracker was written to create an elementary analytics
## reporting system for a CKAN instance (data.hdx.rwlabs.org).
## The tracker queries the API every hour and records the resulting number
## in a database. That number is then visualize using ggplot2. 

library(RCurl)
library(rjson)
library(sqldf)


# Not necessary for most routines.
source('auth.R')

# Number of packages
num_packages_url <- 'http://data.hdx.rwlabs.org/api/action/package_list'
number_of_datasets <- nrow(data.frame(fromJSON(getURL(num_packages_url, userpwd = base_key))))

# Number of countries
num_countries_url <- 'http://data.hdx.rwlabs.org/api/action/group_list'
number_of_countries <- nrow(data.frame(fromJSON(getURL(num_countries_url, userpwd = base_key))))

# Number of organizations
num_organizations_url <- 'http://data.hdx.rwlabs.org/api/action/organization_list'
number_of_organizations <- nrow(data.frame(fromJSON(getURL(num_organizations_url, userpwd = base_key))))

# Number of users
num_user_url <- 'http://data.hdx.rwlabs.org/api/action/user_list'
users_result <- fromJSON(getURL(num_user_url, userpwd = base_key))
number_of_users <- length(users_result[3]$result)

# Creating a list of users.
for (i in 1:number_of_users) { 
    it <- users_result[3]$result[[i]]$name
    if (i == 1) { list_of_users <- it }
    else { list_of_users <- rbind(list_of_users, it)}
}
list_of_users <- data.frame(list_of_users)


# Number of tags
num_tags_url <- 'http://data.hdx.rwlabs.org/api/action/tag_list'
number_of_tags <- nrow(data.frame(fromJSON(getURL(num_tags_url, userpwd = base_key))))

# Number of licenses
num_licenses_url <- 'http://data.hdx.rwlabs.org/api/action/license_list'
licenses_result <- fromJSON(getURL(num_licenses_url, userpwd = base_key))
number_of_licenses <- length(licenses_result[3]$result)

# Collecting date and time.
date_and_time <- as.character(Sys.time())

# Making a single data.frame.
hdx_repo_analytics <- data.frame(number_of_datasets, number_of_countries, number_of_organizations, 
                                 number_of_users, number_of_tags, number_of_licenses, date_and_time)

# Adding pretty names.
names(hdx_repo_analytics) <- c("Number_of_Datasets", "Number_of_Countries", "Number_of_Organizations", "Number_of_Users", "Number_of_Tags", "Number_of_Licenses", "Date_and_Time")

# Storing results in a db. 
cat('Store 2 tables (results and user list) in a database.')
db <- dbConnect(SQLite(), dbname="scraperwiki.sqlite")

dbWriteTable(db, "hdx_repo_analytics", hdx_repo_analytics, row.names = FALSE, append = TRUE)
dbWriteTable(db, "list_of_users", list_of_users, row.names = FALSE, overwrite = TRUE)

# for testing purposes
# dbListTables(db)
# x <- dbReadTable(db, "hdx_repo_analytics")
# y <- dbReadTable(db, "list_of_users")

dbDisconnect(db)
cat('done')