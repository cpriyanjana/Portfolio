
library(tidyverse)
library(lubridate)
library(janitor)

urls <- c(
  "https://github.com/cpriyanjana/CountingCars/blob/main/vehicle_data.csv"
)

veh_raw <- urls |>
  map(read_csv, show_col_types = FALSE) |>
  bind_rows()     

veh <- veh_raw |>
  clean_names() |>
  mutate(
    date      = mdy(date),                                      
    time      = parse_time(time, format = "%H:%M"),          
    datetime  = make_datetime(year(date), month(date), day(date),
                              hour(time), minute(time)),
    car_type  = str_to_title(car_type),
    over_speed_limit = as.logical(over_speed_limit),
    slowed_down      = slowed_down == "Yes"
  ) |>
  arrange(datetime, student)                                  

