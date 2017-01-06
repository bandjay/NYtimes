#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(readr)
library(dplyr)
articles=read_csv("C:/Users/Jay/Desktop/Prof.Mike/ArticleDB/full_data.csv")
articles=unique(articles)
#write.csv(articles,"full_articles_data.csv",row.names = FALSE)
# Define UI for application that draws a histogram
ui <- fluidPage(
  
  title = 'Article Database viewer',
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "articles"',
        checkboxGroupInput('show_vars', 'Columns in datset to show:',
                           names(articles), selected = names(articles)),
         br(),
         textInput("text", label = h5("Date"), value = "Enter Date as YYYYMMDD"),
         fluidRow(column(8, verbatimTextOutput("value")))
        
      )
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel('articles', DT::dataTableOutput('mytable1'))
        
      )
    )
  )
  
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$value <- renderPrint({ input$text})
  # choose columns to display
   output$mytable1 <- DT::renderDataTable({
    DT::datatable(articles[articles$date==input$text,input$show_vars, drop = FALSE])
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

