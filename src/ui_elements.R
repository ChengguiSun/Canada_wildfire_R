## @knitr ui_elements
ui <- dashboardPage(
  dashboardHeader(title = "My Shiny App"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Fire Counts", tabName = "fire_counts", icon = icon("fire")),
      menuItem("Burned Area", tabName = "burned_area", icon = icon("tree")),
      menuItem("Property Losses", tabName = "property_losses", icon = icon("building"))
    )
  ),
  dashboardBody(
    tabItems(
     tabItem("home", homePageUI("home")),
     tabItem("fire_counts", fireCountsPageUI("fire_counts")),
     tabItem("burned_area", burnedAreaPageUI("burned_area")),
     tabItem("property_losses", propertyLossPageUI("property_losses"))
      )
    )
)
