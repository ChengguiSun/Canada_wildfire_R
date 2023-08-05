# Load data
fireLoss <- read.csv("./data/Cleaned_Property_losses.csv", header=TRUE, sep=",")

# Create the sorted list of unique jurisdictions
unique_jurisdictions_loss <- sort(unique(fireLoss$Jurisdiction))
unique_jurisdictions_loss <- unique_jurisdictions_loss[unique_jurisdictions_loss != "Canada"]
province_unique_jurisdictions_loss <- rev(unique_jurisdictions_loss)
unique_jurisdictions_loss <- c(unique_jurisdictions_loss, "Canada")

propertyLossPageUI <- function(id) {
  ns <- NS(id)
  tagList(
    # Page title
    fluidRow(
      div(style = "max-width: 1100px; margin: 0 auto;",
          titlePanel("Property Losses Caused by Forest Fires by year from 1990 to 2020")
      )
    ),
    tags$br(),
    tags$br(),
    tags$br(),
    # Tab name
    tabItem(tabName = "property_losses",
            # Display the plot
            fluidRow(
              div(style = "max-width: 1100px; margin: 0 auto;",
                  plotlyOutput(ns("plot_loss"))
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
                         selectInput(ns("selected_value1_year_loss"),
                                     "Filter by Year",
                                     choices = c("", unique(fireLoss$Year)),
                                     selected = NULL,
                                     multiple = TRUE),
                         selectInput(ns("selected_value1_jurisdiction_loss"),
                                     "Filter by Jurisdiction",
                                     choices = c("", unique_jurisdictions_loss),
                                     selected = NULL,
                                     multiple = TRUE)
                  ),
                  # Column for table
                  column(width = 6,
                         tableOutput(ns("table_loss"))
                  )
              )
            )
    )
  )
}


propertyLossPage <- function(input, output, session) {
  
  # Create reactive values for filtering
  filtered_loss <- reactive({
    # If no filter is applied, return the last 5 rows
    if ((is.null(input$selected_value1_year_loss) || input$selected_value1_year_loss == "") && 
        (is.null(input$selected_value1_jurisdiction_loss) || input$selected_value1_jurisdiction_loss == "")) {
      
      return(tail(fireLoss, 5))
    }
    # Start with the entire dataset
    df_loss <- fireLoss
    
    # If a year is selected, filter the data for that year
    if (!is.null(input$selected_value1_year_loss) && input$selected_value1_year_loss != "") {
      df_loss <- df_loss %>%
        filter(Year == input$selected_value1_year_loss)
    }
    
    # If a jurisdiction is selected, filter the data for that jurisdiction
    if (!is.null(input$selected_value1_jurisdiction_loss) && input$selected_value1_jurisdiction_loss != "") {
      df_loss <- df_loss %>%
        filter(Jurisdiction == input$selected_value1_jurisdiction_loss)
    }
    
    return(df_loss)
  })
  
  
  # Render table based on input
  output$table_loss <- renderTable({
    # Check if no filters applied, only display the last 5 rows
    df_loss <- filtered_loss()
    # Exclude 'X', 'Date', and 'MonthNum' columns
    df_loss <- df_loss[ , !(names(df_loss) %in% c("X"))]
    df_loss
  }
  )
  
  
  output$plot_loss <- renderPlotly({
    
    # Create an empty plotly object
    fig_loss <- plot_ly()
    
    # Loop over each unique jurisdiction
    for(jurisdiction_loss in province_unique_jurisdictions_loss) {
      
      # Create a new dataframe for each jurisdiction
      jurisdiction_df_loss <- fireLoss[fireLoss$Jurisdiction == jurisdiction_loss,]
      
      # Add a bar to the figure for the current jurisdiction
      fig_loss <- fig_loss %>% add_trace(x = ~Year, y = ~Dollars, name = jurisdiction_loss, type = 'bar', data = jurisdiction_df_loss)
    }
    
    # Set the title and labels
    fig_loss <- fig_loss %>% layout(xaxis = list(title = "Year", showgrid = FALSE), yaxis = list(title = "Dollars", showgrid = FALSE), legend = list(x = -0.75, y = 0.75, orientation = "h"), autosize = TRUE, barmode = 'stack')
    
    fig_loss
  })
}
