library(shiny)
library(ggplot2)
library(dplyr)
library(readxl)
library(httr)
library(tidyr)
library(readr)

# Load required library
library(readr)

# Define the raw URL
url <- "https://raw.githubusercontent.com/nabindrak7/Naby_DATA332/ae7e954c7b00cd414a80015d445a7b698e0dfb06/CountingCars/Vehicle_data.csv"

# Read the CSV file from the raw GitHub URL
vehicle_data <- read_csv(url)

# View the first few rows
head(vehicle_data)



# Preprocessing
vehicle_data$Time <- as.POSIXct(vehicle_data$Time, format = "%H:%M")
vehicle_data$SpeedCategory <- cut(vehicle_data$`Speed (mph)`,
                                  breaks = c(0, 30, 40, 100),
                                  labels = c("Within Limit", "Slightly Over", "Significantly Over"))

# UI
ui <- fluidPage(
  titlePanel("Vehicle Speed Analysis - Rock Island, IL"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("show_all", "Show All Students", value = TRUE),
      selectInput("student", "Select Student(s):",
                  choices = unique(vehicle_data$Student), selected = NULL, multiple = TRUE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Speed Distribution", plotOutput("speedDist")),
        tabPanel("Speeding Summary", tableOutput("speedSummary")),
        tabPanel("Student Stats", tableOutput("studentStats")),
        tabPanel("Overall Stats", tableOutput("overallStats")),
        tabPanel("Scatterplot: Time vs Speed", plotOutput("scatterTimeSpeed")),
        tabPanel("Car Type Speeds", plotOutput("carTypeSpeed")),
        tabPanel("Mean vs Median (All Students)", plotOutput("meanMedianAllPlot")),
        tabPanel("Car Type & Speed Limit", plotOutput("carTypeLimitPlot"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  filtered_data <- reactive({
    if (input$show_all || is.null(input$student)) {
      vehicle_data
    } else {
      filter(vehicle_data, Student %in% input$student)
    }
  })
  
  output$speedDist <- renderPlot({
    df <- filtered_data()
    df <- df %>% mutate(SpeedCategory = case_when(
      `Speed (mph)` <= 30 ~ "Within Limit",
      `Speed (mph)` <= 40 ~ "Slightly Over",
      TRUE ~ "Significantly Over"
    ))
    
    ggplot(df, aes(x = SpeedCategory)) +
      geom_bar(fill = "steelblue") +
      labs(title = "Distribution of Vehicle Speeds", x = "Speed Category", y = "Count") +
      theme_minimal()
  })
  
  output$speedSummary <- renderTable({
    df <- filtered_data()
    within_limit <- sum(df$`Speed (mph)` <= 30, na.rm = TRUE)
    slightly_over <- sum(df$`Speed (mph)` > 30 & df$`Speed (mph)` <= 40, na.rm = TRUE)
    significantly_over <- sum(df$`Speed (mph)` > 40, na.rm = TRUE)
    speeding_total <- slightly_over + significantly_over
    total <- nrow(df)
    
    data.frame(
      Category = c("Within Limit", "Slightly Over", "Significantly Over", "Total Speeding", "Total Vehicles", "% Speeding"),
      Count = c(within_limit, slightly_over, significantly_over, speeding_total, total, round(speeding_total / total * 100, 2))
    )
  })
  
  output$studentStats <- renderTable({
    df <- filtered_data()
    df %>%
      group_by(Student) %>%
      summarise(Min = min(`Speed (mph)`, na.rm = TRUE),
                Max = max(`Speed (mph)`, na.rm = TRUE),
                Mean = round(mean(`Speed (mph)`, na.rm = TRUE), 2),
                Median = median(`Speed (mph)`, na.rm = TRUE))
  })
  
  output$overallStats <- renderTable({
    df <- filtered_data()
    data.frame(
      Metric = c("Minimum", "Maximum", "Mean", "Median"),
      Value = c(min(df$`Speed (mph)`, na.rm = TRUE),
                max(df$`Speed (mph)`, na.rm = TRUE),
                round(mean(df$`Speed (mph)`, na.rm = TRUE), 2),
                median(df$`Speed (mph)`, na.rm = TRUE))
    )
  })
  
  output$scatterTimeSpeed <- renderPlot({
    df <- filtered_data()
    ggplot(df, aes(x = Time, y = `Speed (mph)`, color = Student)) +
      geom_point() +
      labs(title = "Vehicle Speed vs Time of Day", x = "Time", y = "Speed (mph)") +
      theme_minimal()
  })
  
  output$carTypeSpeed <- renderPlot({
    df <- filtered_data()
    car_summary <- df %>%
      filter(!is.na(`Car Type`), `Car Type` != "") %>%
      group_by(`Car Type`) %>%
      summarise(AvgSpeed = mean(`Speed (mph)`, na.rm = TRUE)) %>%
      arrange(AvgSpeed)
    
    if (nrow(car_summary) == 0) return(NULL)
    
    ggplot(car_summary, aes(x = reorder(`Car Type`, AvgSpeed), y = AvgSpeed)) +
      geom_col(fill = "coral") +
      coord_flip() +
      labs(title = "Average Speed by Car Type", x = "Car Type", y = "Average Speed (mph)") +
      theme_minimal()
  })
  
  output$meanMedianAllPlot <- renderPlot({
    summary_df <- vehicle_data %>%
      group_by(Student) %>%
      summarise(Mean = mean(`Speed (mph)`, na.rm = TRUE),
                Median = median(`Speed (mph)`, na.rm = TRUE)) %>%
      pivot_longer(cols = c(Mean, Median), names_to = "Metric", values_to = "Speed")
    
    ggplot(summary_df, aes(x = Student, y = Speed, fill = Metric)) +
      geom_col(position = "dodge") +
      labs(title = "Mean vs Median Speed for All Students", x = "Student", y = "Speed (mph)") +
      theme_minimal()
  })
  
  output$carTypeLimitPlot <- renderPlot({
    df <- filtered_data()
    df <- df %>%
      filter(!is.na(`Car Type`), `Car Type` != "") %>%
      mutate(SpeedingStatus = ifelse(`Speed (mph)` > 30, "Over Limit", "Within Limit")) %>%
      group_by(`Car Type`, SpeedingStatus) %>%
      summarise(Count = n(), .groups = "drop")
    
    if (nrow(df) == 0) return(NULL)
    
    ggplot(df, aes(x = reorder(`Car Type`, -Count), y = Count, fill = SpeedingStatus)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Number of Vehicles per Car Type (Over/Under Speed Limit)",
           x = "Car Type", y = "Number of Vehicles", fill = "Speeding Status") +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)
