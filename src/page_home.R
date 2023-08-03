## @knitr page_home

homePageUI <- function(id) {
  ns <- NS(id)
  fluidRow(
    div(style = "max-width: 1200px; margin: 0 auto;",
      tagList(
        tabItem(tabName = ns("home"),
                titlePanel("Canada Forest Fires Statistics"),
                h3("Project Objectives"),
                p("The objectives of this visualization project are:"),
                tags$ul(
                  tags$li("To offer an interactive tool that allows users to explore and understand the impact of forest fires in Canada."),
                  tags$li("To highlight the significant threats posed by forest fires to both the environment and properties."),
                  tags$li("To present detailed data on fire counts, the areas burned, and the property losses due to these fires.")
                ),
                h3("Visualization Contents"),
                p("This visualization project includes the demonstration of fire counts, burned area, and property losses. The contents of each section are:"),
                h4("Fire Counts"),
                tags$ul(
                  tags$li("Focuses on the number of fires that have occurred each month since 1990 in different jurisdictions in Canada."),
                  tags$li("An interactive graph shows the number of fires over the years."),
                  tags$li("Users can filter the data by Year, Month, and Jurisdiction in the table.")
                ),
                h4("Burned Area"),
                tags$ul(
                  tags$li("Delves into the impact of these fires, more specifically, the area these fires have burned each month."),
                  tags$li("Similar to the Fire Counts section, there is an interactive graph and a table."),
                  tags$li("Users can apply filters to the table for Year, Month, and Jurisdiction."),
                  tags$li("Analysis of this data helps to understand the scale of forest fires and to anticipate potential environmental consequences.")
                ),
                h4("Property Losses"),
                tags$ul(
                  tags$li("Provides data on the property losses resulting from these fires."),
                  tags$li("Similar to previous two sections, there is an interactive graph and a table."),
                  tags$li("Users can apply filters to the table for Year and Jurisdiction."),
                  tags$li("By examining these losses, we can better comprehend the human and economic costs of these fires and can guide efforts towards more effective protective measures and mitigation strategies.")
                ),
                tags$div(style = "display: flex; justify-content: flex-start;",
                         tags$img(src = paste0("data:image/jpg;base64,", image_string1), height = 200, width = 200),
                         tags$img(src = paste0("data:image/jpg;base64,", image_string2), height = 200, width = 200),
                         tags$img(src = paste0("data:image/jpg;base64,", image_string3), height = 200, width = 200)
                ),
                h3("Attribution"),
                tags$ul(
                  tags$li("DATA SOURCES: Canadian Council of Forest Ministers - Conseil canadien des ministres des forêts. (2020). The data used in this application is derived from the _National Forestry Database. This dataset is a product of Natural Resources Canada – Ressources naturelles Canada. DOI The National Forestry Database is archived on Zenodo.org. All releases can be accessed here."),
                  tags$li("CANADA FLAG ICON: Flags icons created by Freepik - Flaticon")
          )
        )
      )
    )
  )
}

homePage <- function(input, output, session) {
  # No server logic needed for home page as of now
}
