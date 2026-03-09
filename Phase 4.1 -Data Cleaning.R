setwd(this.path::this.dir())

# Packages ----------------------------------------------------------------
library(tidyverse)
library(readr)
library(rvest)
library(stringr)

# Creating "event", "kämpfe", attendance & "gewichtsklasse" ----------------------------------------------------
table_list <- read_html("https://en.wikipedia.org/wiki/List_of_UFC_events") %>% 
  html_table() 
   attendance <- table_list[[2]]

events <- read_csv("data/Events.csv") %>% 
  as_tibble()

kampfe <- read_csv("data/fights.csv")



# Merging the Data
events_fights <- inner_join(kampfe, events, by = "Event_Id")

# Formating Fight Outcomes to match SQL restrictions
events_fights <- events_fights %>% 
  mutate(Method = case_when(
    str_detect(Method, "SUB") ~ "Sub",
    str_detect(Method, "DQ")  ~ "Disq",
    str_detect(Method, "DEC") ~ "Dec",
    TRUE                      ~ "Other"
  )
  )

# Unifying Fight Nights
events_fights <- events_fights %>% 
  mutate(
    Name = str_replace(
      Name,
      regex("^(ufc\\s\\d{1,3}).*", ignore_case = TRUE),
      "\\1"
    )
  )

# Same for the attendance DF
attendance <- attendance %>% 
  mutate(
    Name = str_replace(
      Event,
      regex("^(ufc\\s\\d{1,3}).*", ignore_case = TRUE),
      "\\1"
    )
  )


# Removing the comma in order to convert the character column to an integer
attendance <- attendance %>% 
  mutate(Attendance = 
           gsub(",", "", Attendance)
  ) %>% 
  mutate(Attendance =
           as.numeric(Attendance))

# Replacing NA's with 999 because otherwise we cannot read it into SQL
attendance <- attendance %>% 
  mutate(
    Attendance = replace_na(Attendance, 999)
  )

# Removing weightclasses that don't exist anymore
events_fights <- events_fights %>% filter(!(Weight_Class %in% c("Super Heavyweight", "Open Weight", "Catch Weight")))

# Extracting and renaming the columns we will use in the actual database ("Kampf" Table)
kampf <- events_fights %>% 
  mutate(
    ID = Fight_Id,
    rundenzahl = Round,
    ergebnisart = Method,
    siegrunde = Round,
    siegminute = Fight_Time,
    enthalten_in = Name,
    stattgefunden_in = Weight_Class,
    
    .keep = "none"
  )

# Same for the "event" table
event <- events_fights %>%
  mutate(
    in_land = str_replace(Location, "^.*?,\\s*([^,]+)\\s*$", "\\1"),
    datum = Date,
    name = Name,
    
    .keep = "none"
  ) %>% 
  distinct(name, .keep_all = TRUE)

# Same for the attendance table (temporary table that will be merged with "event" in SQL)
attendance <- attendance %>% 
  mutate(
    name = Name,
    Zuschauerzahl = Attendance,
    .keep = "none"
  )

# Creating the "land" table
land <- event %>% 
  distinct(in_land) %>% 
  mutate(
    land = in_land,
    .keep = "unused"
  )

# Creating the CSV's
write_csv(land, "land.csv")
write_csv(event, "event.csv")
write_csv(gewichtsklasse, "gewichtsklasse.csv")
write_csv(kampf, "kampf.csv")

  
# CREATING GEWICHTSKLASSE
gewichtsklasse <- tibble(
  name = unique(events_fights$Weight_Class),
  maximalgewicht = c( 135,  # Bantamweight
                      125,  # Flyweight
                      205,  # Light Heavyweight
                      155,  # Lightweight
                      125,  # Women's Flyweight
                      185,  # Middleweight
                      145,  # Featherweight
                      170,  # Welterweight
                      265,  # Heavyweight
                      115,  # Women's Strawweight
                      135,  # Women's Bantamweight
                      145  # Women's Featherweight
  ),
  minimalgewicht = c( 126,  # Bantamweight
                      0,   # Flyweight
                      186,  # Light Heavyweight
                      146,  # Lightweight
                      116,   # Women's Flyweight
                      171,  # Middleweight
                      136,  # Featherweight
                      156,  # Welterweight
                      206,  # Heavyweight
                      0,   # Women's Strawweight
                      126,   # Women's Bantamweight
                      136   # Women's Featherweight
  )
)

write_csv(gewichtsklasse, "gewichtsklasse.csv")


# Creating "Kampfer" --------------------------------------------
kampfer_df <- read_csv("data/fighters.csv")
kampfer_stats <- read_csv("data/fighters Stats.csv")
kampfer_stats_raw <- read_csv("raw_data/raw_details.csv")

#' Marking NA's with [999
kampfer_df <- kampfer_df %>%
  mutate(across(everything(),
    ~replace_na(., 999)
  )
  )

kampfer_stats <- kampfer_stats %>%
  mutate(across(everything(),
                ~replace_na(., 999)
  )
  )

# Merging the tables
kampfer_merged <- left_join(kampfer_df, kampfer_stats, by = "Fighter_Id")

# Converting height to cm
kampfer_merged <- kampfer_merged %>% 
  mutate(Ht. = {
    parts <- str_split_fixed(Ht..x, "\\.", 2)
    feet   <- as.numeric(parts[, 1])
    inches <- as.numeric(parts[, 2])
    (feet * 12 + inches) * 2.54
  }
  )

# Renaming Everything and making sure each fighter is there only once and replacing missing values
kampfer <- kampfer_merged %>% 
  mutate(
    name = `Full Name.x`,
    gewicht = Wt..x,
    grosse = Ht..x,
    reichweite = Reach*2.54,
    sizereachratio = reichweite/grosse,
    auslage = Stance.x,
    background = `Fighting Style`,
    
    .keep = "none"
  ) %>%
   distinct(name, .keep_all = TRUE) %>% 
  mutate(
    across(where(is.numeric), ~ tidyr::replace_na(., 999)),
    across(where(is.character), ~ tidyr::replace_na(., "999"))
  )

write_csv(kampfer, "kampfer.csv")


# Creating "kampf_kampfer" -----------------------------------------------------------
kampf_kampfer <- events_fights %>% 
  mutate(
    kampf = Fight_Id,
    rundenzahl = Round,
    ergebnisart = Method,
    siegrunde = Round,
    siegminute = Fight_Time,
    enthalten_in = Name,
    stattgefunden_in = Weight_Class,
    kampfer1 = Fighter_1,
    kampfer2= Fighter_2,
    ergebnis1 = Result_1,
    ergebnis2 = Result_2,
    sig_treffer1 = STR_1,
    sig_treffer2 = STR_2,
    takedowns1 = TD_1,
    takedowns2 = TD_2,
    
    .keep = "none"
  ) %>% 
  pivot_longer(
    cols = matches("^(kampfer|ergebnis|sig_treffer|takedowns)\\d+$"),
    names_to = c(".value", "seite"),
    names_pattern = "^(kampfer|ergebnis|sig_treffer|takedowns)(\\d+)$"
  ) %>%
  select(kampf, kampfer, takedowns, sig_treffer) %>%
  filter(kampfer %in% kampfer_df$`Full Name`) %>% # Making sure I only get fighters which also appear in the "kampfer"-table, otherwise the SQL import will fail due to the key constraints
  write_csv("kampf_kampfer.csv")
