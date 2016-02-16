library("dygraphs")
library("xts")
lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C")
df <- read.csv("http://rmecab.jp/dat.csv")
valueRange <- rev(range(df$Rank))
valueRange[1] <- valueRange[1] + 100
valueRange[2] <- valueRange[2] - 100
x <- xts(df$Rank, strptime(df$Time, "%a %b %d %H:%M:%S %Y"))
Sys.setlocale("LC_TIME", lct)

ui <- fluidPage(
  titlePanel('Amazon Rank'),
  sidebarLayout(
    sidebarPanel(
      h3('Buy it now!!!'),
      a("http://www.amazon.co.jp/gp/product/432012393X", href="http://www.amazon.co.jp/gp/product/432012393X", target="_blank"),
      hr(),
      checkboxInput("showgrid", label = "Show Grid", value = TRUE)
    ),
    mainPanel(
      dygraphOutput("dygraph")
    )
  )
)

server <- function(input, output) {
  output$dygraph <- renderDygraph({
    dygraph(x, main = "") %>%
      dyOptions(drawGrid = input$showgrid) %>%
      dyAxis("y", label = "Amazon Rank", valueRange = valueRange) %>%
      dyOptions(drawPoints = TRUE, pointSize = 3)
  })
}

shinyApp(ui = ui, server = server)