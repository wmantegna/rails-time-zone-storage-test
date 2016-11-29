[![Code Climate](https://codeclimate.com/github/wmantegna/rails-time-zone-storage-test/badges/gpa.svg)](https://codeclimate.com/github/wmantegna/rails-time-zone-storage-test)

Rails app that reads & writes datetime & timezone data accurately.

This app was my exploration to solve a problem of what 13:00 EST really means to Rails/Ruby/Postgres.
I was having trouble identifying exactly when an event would begin, due to issues with how Rails interacts with DateTime objects & TimeZones.
Essentially, even though a DateTime may be stored in memory to a specific time-zone, this is not always the case when persisted to a database.