# Load data
fireArea <- read.csv("./data/Cleaned_Area_burned_by_month.csv", header=TRUE, sep=",")

fireArea <- rename(fireArea, `Area (hectares)` = `Area..hectares.`)

# Create a named vector to map month names to numbers
month_map <- setNames(1:12, month.name)

# Map the month names in fireArea$Month to numbers
fireArea$MonthNum <- month_map[fireArea$Month]

# Create the sorted list of unique jurisdictions
unique_jurisdictions_area <- sort(unique(fireArea$Jurisdiction))
unique_jurisdictions_area <- unique_jurisdictions_area[unique_jurisdictions_area != "Canada"]
unique_jurisdictions_area <- c(unique_jurisdictions_area, "Canada")

burnedAreaPageUI <- function(id) {
  ns <- NS(id)
  tagList(
    # Page title
    fluidRow(
      div(style = "max-width: 1100px; margin: 0 auto;",
          titlePanel("Burned Area of Forest Fires by Month from 1990 to 2020")
      )
    ),
    tags$br(),
    tags$br(),
    tags$br(),
    # Tab name
    tabItem(tabName = "burned_area",
            # Display the plot
            fluidRow(
              div(style = "max-width: 1100px; margin: 0 auto;",
                  p("To interact with the Plot below: hover over the plot to view data values, and use the legend on the left to toggle visibility of different jurisdictions.",
                    style = "font-size: 16px;"),
                  plotlyOutput(ns("plot_area"))
              )
            ),
            # Add space
            tags$br(),
            tags$br(),
            tags$br(),
            # Start fluidRow
            fluidRow(
              div(style = "max-width: 1100px; margin: 0 auto;",
                  p("To explore the table below, utilize the filters to narrow down specific years, months, or jurisdictions. 
                     By default, the table displays 5 rows. However, once filters are applied, all entries meeting the criteria will be displayed.",
                    style = "font-size: 16px;"),
                  # Column for filters
                  column(width = 6,
                         selectInput(ns("selected_value1_year_area"),
                                     "Filter by Year",
                                     choices = c("", unique(fireArea$Year)),
                                     selected = NULL,
                                     multiple = TRUE),
                         selectInput(ns("selected_value1_month_area"),
                                     "Filter by Month",
                                     choices = c("", month.name),
                                     selected = NULL,
                                     multiple = TRUE),
                         selectInput(ns("selected_value1_jurisdiction_area"),
                                     "Filter by Jurisdiction",
                                     choices = c("", unique_jurisdictions_area),
                                     selected = NULL,
                                     multiple = TRUE)
                  ),
                  # Column for table
                  column(width = 6,
                         tableOutput(ns("table_area"))
                  )
              )
            )
    )
  )
}


burnedAreaPage <- function(input, output, session) {
  
  # Create reactive values for filtering
  filtered_area <- reactive({
    # If no filter is applied, return the last 5 rows
    if ((is.null(input$selected_value1_year_area) || input$selected_value1_year_area == "") && 
        (is.null(input$selected_value1_month_area) || input$selected_value1_month_area == "") && 
        (is.null(input$selected_value1_jurisdiction_area) || input$selected_value1_jurisdiction_area == "")) {
      
      return(tail(fireArea, 5))
    }
    # Start with the entire dataset
    df_area <- fireArea
    
    # If a year is selected, filter the data for that year
    if (!is.null(input$selected_value1_year_area) && input$selected_value1_year_area != "") {
      df_area <- df_area %>%
        filter(Year == input$selected_value1_year_area)
    }
    
    # If a month is selected, filter the data for that month
    if (!is.null(input$selected_value1_month_area) && input$selected_value1_month_area != "") {
      df_area <- df_area %>%
        filter(MonthNum == month_map[input$selected_value1_month_area])
    }
    
    # If a jurisdiction is selected, filter the data for that jurisdiction
    if (!is.null(input$selected_value1_jurisdiction_area) && input$selected_value1_jurisdiction_area != "") {
      df_area <- df_area %>%
        filter(Jurisdiction == input$selected_value1_jurisdiction_area)
    }
    
    return(df_area)
  })
  
  
  # Render table based on input
  output$table_area <- renderTable({
    # Check if no filters applied, only display the last 5 rows
    df_area <- filtered_area()
    # Exclude 'X', 'Time', and 'MonthNum' columns
    df_area <- df_area[ , !(names(df_area) %in% c("X", "Time", "MonthNum"))]
    df_area
  }
  )
  
  
  output$plot_area <- renderPlotly({
    # Create Time column from year and month
    fireArea$Date <- as.Date(paste(fireArea$Year, fireArea$MonthNum, "01"), format = "%Y %m %d")
    
    # Create an empty plotly object
    fig_area <- plot_ly()
    
    # Loop over each unique jurisdiction
    for(jurisdiction_area in unique_jurisdictions_area) {
      
      # Create a new dataframe for each jurisdiction
      jurisdiction_df_area <- fireArea[fireArea$Jurisdiction == jurisdiction_area,]
      
      # Add a line to the figure for the current jurisdiction
      fig_area <- fig_area %>% add_trace(x = ~Time, y = ~`Area (hectares)`, name = jurisdiction_area, type = 'scatter', mode = 'lines', data = jurisdiction_df_area)
    }
    
    # Set the title and labels
    fig_area <- fig_area %>% layout(xaxis = list(title = "Time", showgrid = FALSE), yaxis = list(title = "Area (hectares)", showgrid = FALSE), legend = list(x = -0.75, y = 0.75, orientation = "h"), autosize = TRUE)
    
    fig_area
  })
}

