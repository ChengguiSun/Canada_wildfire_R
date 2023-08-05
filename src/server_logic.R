server <- function(input, output, session) {
  callModule(homePage, "home")
  callModule(fireCountsPage, "fire_counts")
  callModule(burnedAreaPage, "burned_area")
  callModule(propertyLossPage, "property_losses")
}