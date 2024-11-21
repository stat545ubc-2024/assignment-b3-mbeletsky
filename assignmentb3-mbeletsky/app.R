library(shiny)
library(tidyverse)
#Photo attribution: kamchatka on FreePik
grizzly <- read.csv("grizzly.csv", stringsAsFactors = FALSE)
ui <- fluidPage(
  titlePanel("Grizzly Population - British Columbia, Canada (2015 and 2018)"),
  sidebarLayout(
    sidebarPanel(
      selectInput("year", "Year:",
                  c("2015" = "EST_POP_2015",
                    "2018" = "EST_POP_2018")),
    ),
    mainPanel(
      tags$figure(
        class = "centerFigure",
        tags$img(
          src = "grizzly.png",
          width = 600,
          alt = "Picture of two grizzly bears in water."),
        tags$figcaption("Photo attribution: kamchatka on FreePik")),
      tableOutput("grzly_year")
    )
  )
)
server <- function(input, output) {
  output$grzly_year <- renderTable({
    grizzly[, c("REGION_RESPONSIBLE_NAME", input$year), drop = FALSE]
  }, rownames = TRUE)
}
shinyApp(ui = ui, server = server)
