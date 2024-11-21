library(shiny)
library(colourpicker)
library(tidyverse)
grizzly <- read.csv("grizzly.csv", stringsAsFactors = FALSE)
ui <- fluidPage(
  titlePanel("Grizzly Bear Population - British Columbia, Canada (2015 and 2018)"),
  sidebarLayout(
    sidebarPanel(
# Feature 1: "Year" filter to view grizzly bear population data.
# This feature is useful because it allows the user to select the year they
# want to view population data for.
      selectInput("year", "Year:",
                  c("2015" = "EST_POP_2015",
                    "2018" = "EST_POP_2018")),
    ),
    mainPanel(
# Feature 2: Grizzly bear photo. This feature is useful because it immediately
# gives the viewer a visual relating to the data they're viewing. It also makes
# the app more pleasing to look at rather than viewing a dry table and plot.
      tags$figure(
        class = "centerFigure",
        tags$img(
          src = "grizzly.png",
          width = 600,
          alt = "Picture of two grizzly bears in water."),
        tags$figcaption("Photo attribution: kamchatka on FreePik")),
      p(),
      p(strong("This table shows 240 grizzly bear population sub-units in BC and the number of bears in each one.")),
      tableOutput("grzly_year"),
# Feature 3: Interactive colouring of the plot. This feature is useful because
# it enhances user engagement level by allowing them to play and interact with
# the plot, and they can adjust the data points to a colour that makes it
# easiest for them to view and interpret the data.
      colourInput("col", "Select colour", "blue"),
      plotOutput("id_scatterplot"),
    )
  )
)
server <- function(input, output) {
# This table is produced based on the year input of the user (Feature 1).
  output$grzly_year <- renderTable({
    grizzly[, c("REGION_RESPONSIBLE_NAME", input$year), drop = FALSE]
  }, rownames = TRUE)
# This plot is produced based on the year input of the user (Feature 1) and
# the colour of the points is also determined by the user (Feature 3).
  output$id_scatterplot <- renderPlot({
    ggplot(grizzly, aes_string(x="AREA_KM2", y= input$year)) +
      geom_point(col = input$col) +
      labs(caption = "Population size is dependent on area in km^2. \n Each point represents an individual grizzly population in BC. \n Area in km^2 of a population's territory is on the x-axis \n Number of bears in the population sub-unit is on the y-axis.") +
      theme(plot.caption = element_text(size = 12))
      })
}
shinyApp(ui = ui, server = server)
