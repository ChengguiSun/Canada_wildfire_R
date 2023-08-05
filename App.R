# title: "Canada Forest Fires Statistics"
# output: html_document
# date: "2023-08-01"

source("./src/load_libraries.R")
source("./src/prepare_images.R")
source("./src/page_home.R")
source("./src/page_fire_counts.R")
source("./src/page_burned_area.R")
source("./src/page_property_losses.R")
source("./src/ui_elements.R")
source("./src/server_logic.R")
shinyApp(ui = ui, server = server)
