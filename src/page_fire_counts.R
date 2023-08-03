## @knitr page_fire_counts
# Load data
fireNumber <- read.csv(file="./data/Cleaned_Number_of_fires_by_month.csv", header=TRUE, sep=",")

# Create a named vector to map month names to numbers
month_map <- setNames(1:12, month.name)

# Map the month names in fireNumber$Month to numbers
fireNumber$MonthNum <- month_map[fireNumber$Month]

# Create the sorted list of unique jurisdictions
unique_jurisdictions_num <- sort(unique(fireNumber$Jurisdiction))
unique_jurisdictions_num <- unique_jurisdictions_num[unique_jurisdictions_num != "Canada"]
unique_jurisdictions_num <- c(unique_jurisdictions_num, "Canada")

fireCountsPageUI <- function(id) {
  ns <- NS(id)
  tagList(
    # Page title
    fluidRow(
      div(style = "max-width: 1100px; margin: 0 auto;",
          titlePanel("Number of Forest Fires by Month from 1990 to 2020")
      )
    ),
    tags$br(),
    tags$br(),
    tags$br(),
    # Tab name
    tabItem(tabName = "fire_counts",
            # Display the plot
            fluidRow(
              div(style = "max-width: 1100px; margin: 0 auto;",
                  plotlyOutput(ns("plot_num"))
              )
            ),
            # Add space
            tags$br(),
            tags$br(),
            tags$br(),
            # Start fluidRow
            fluidRow(
              div(style = "max-width: 1100px; margin: 0 auto;",
              # Column for filters
                column(width = 6,
                       selectInput(ns("selected_value1_year"),
                                   "Filter by Year",
                                   choices = c("", unique(fireNumber$Year)),
                                   selected = NULL,
                                   multiple = TRUE),
                       selectInput(ns("selected_value1_month"),
                                   "Filter by Month",
                                   choices = c("", month.name),
                                   selected = NULL,
                                   multiple = TRUE),
                       selectInput(ns("selected_value1_jurisdiction"),
                                   "Filter by Jurisdiction",
                                   choices = c("", unique_jurisdictions_num),
                                   selected = NULL,
                                   multiple = TRUE)
                ),
                # Column for table
                column(width = 6,
                       tableOutput(ns("table_num"))
              )
            )
        )
    )
  )
}


fireCountsPage <- function(input, output, session) {
  
  # Create reactive values for filtering
  filtered_num <- reactive({
    
    # If no filter is applied, return the last 5 rows
    if ((is.null(input$selected_value1_year) || input$selected_value1_year == "") && 
        (is.null(input$selected_value1_month) || input$selected_value1_month == "") && 
        (is.null(input$selected_value1_jurisdiction) || input$selected_value1_jurisdiction == "")) {
      
      return(tail(fireNumber, 5))
    }
    
    # Start with the entire dataset
    df <- fireNumber
    
    # If a year is selected, filter the data for that year
    if (!is.null(input$selected_value1_year) && input$selected_value1_year != "") {
      df <- df %>%
        filter(Year == input$selected_value1_year)
    }
    
    # If a month is selected, filter the data for that month
    if (!is.null(input$selected_value1_month) && input$selected_value1_month != "") {
      df <- df %>%
        filter(MonthNum == month_map[input$selected_value1_month])
    }
    
    # If a jurisdiction is selected, filter the data for that jurisdiction
    if (!is.null(input$selected_value1_jurisdiction) && input$selected_value1_jurisdiction != "") {
      df <- df %>%
        filter(Jurisdiction == input$selected_value1_jurisdiction)
    }
    
    return(df)
  })
  
  
  # Render table based on input
  output$table_num <- renderTable({
    # Check if no filters applied, only display the last 5 rows
    df <- filtered_num()
    # Exclude 'X', 'Time', and 'MonthNum' columns
    df <- df[ , !(names(df) %in% c("X", "Time", "MonthNum"))]
    df
    }
)
  
  
  output$plot_num <- renderPlotly({
    # Create time column from year and month
    fireNumber$Time <- as.Date(paste(fireNumber$Year, fireNumber$MonthNum, "01"), format = "%Y %m %d")
    
    # Create an empty plotly object
    fig_num <- plot_ly()
    
    # Loop over each unique jurisdiction
    for(jurisdiction in unique_jurisdictions_num) {
      
      # Create a new dataframe for each jurisdiction
      jurisdiction_df <- fireNumber[fireNumber$Jurisdiction == jurisdiction,]
      print(head(jurisdiction_df, 5))
      
      # Add a line to the figure for the current jurisdiction
      fig_num <- fig_num %>% add_trace(x = ~Time, y = ~Number, name = jurisdiction, type = 'scatter', mode = 'lines', data = jurisdiction_df)
    }
    
    # Set the title and labels
    fig_num <- fig_num %>% layout(xaxis = list(title = "Time", showgrid = FALSE), yaxis = list(title = "Number", showgrid = FALSE), legend = list(x = -0.75, y = 0.75, orientation = "h"), autosize = TRUE)
    
    fig_num
  })
}

