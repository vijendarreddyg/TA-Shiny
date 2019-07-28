library("shiny")
library(igraph)
library(ggraph)
library(ggplot2)
library(stringr)

# Define ui function
shinyUI(
  fluidPage(
    
    titlePanel("Building a Shiny App around the UDPipe NLP workflow"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file", "Upload a text file "),
        selectInput("selectModel", "Model", 
                    c("english-ewt", "english-gum", "english-lines", "english-partut"), selected = "english-ewt"),
        checkboxGroupInput("input_selection", "select list of Universal part-of-speech tags (upos)",
                           c("adjective (ADJ)" = "ADJ",
                             "noun(NOUN)" = "NOUN",
                             "proper noun (PROPN)" = "PROPN",
                             "adverb (ADV)" = "ADV",
                             "verb (VERB)" = "VERB"),
                           selected = c("adjective (ADJ)" = "ADJ",
                                        "noun(NOUN)" = "NOUN",
                                        "proper noun (PROPN)" = "PROPN"),
                           inline = FALSE)),
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Introduction",
                             h4(p("Data input"))
                             # p("This app supports only comma separated values (.csv) data file. CSV data file should have headers and the first column of the file should have row names.",align="justify"),
                             # p("Please refer to the link below for sample csv file."),
                             # a(href="https://github.com/sudhir-voleti/sample-data-sets/blob/master/Segmentation%20Discriminant%20and%20targeting%20data/ConneCtorPDASegmentation.csv"
                             #   ,"Sample data input file"),   
                             # br(),
                             # h4('How to use this App'),
                             # p('To use this app, click on', 
                             #   span(strong("Upload data (csv file with header)")),
                             #   'and uppload the csv data file. You can also change the number of clusters to fit in k-means clustering')
                    ),
                    tabPanel("Annotated documents", 
                             dataTableOutput('annotate')),
                    
                    tabPanel("WordClouds for Nouns and Verbs",
                             column(width =6,align='left',plotOutput('wordCloud1',height=700,width=600)),
                             column(width=6,align='right',plotOutput('wordCloud2',height=700,width=600))
                             ),
                             
                    
                    tabPanel("Co-occurrences ",
                             plotOutput('cogGraphs'))
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI


