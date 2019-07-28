library("shiny")
library(igraph)
library(ggraph)
library(ggplot2)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
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
                           inline = FALSE),
        downloadButton("downloadData","Export to CSV")),
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Introduction",
                             h4(p("Data input")),
                             p("This app supports any text (.txt) data file. txt data file may or may not have headers",align="justify"),
                              p("This app provides the user to browse the text file to be loaded frm the file system and at the backend will run the logics for displaying the wordclouds, cooccurence graphs and the annotated adata frame."),
                             # a(href="https://github.com/sudhir-voleti/sample-data-sets/blob/master/Segmentation%20Discriminant%20and%20targeting%20data/ConneCtorPDASegmentation.csv"
                             #   ,"Sample data input file"),   
                             br(),
                              h4('How to use this App'),
                              p('To use this app, click on', 
                                span(strong("Upload text file")),
                                'and upload the txt data file. you can also select the type of english model of your inrereset from the Model dropdown there is a parts of speech taga available which is given as an option  to ')
                    ),
                    tabPanel("Annotated documents", 
                             sliderInput("annoSlide", "Data Frame Size:",
                                         min = 50, max = 1000,
                                         value = 100),
                              dataTableOutput('annotate')),
                    
                    tabPanel("WordClouds for Nouns and Verbs",
                             sliderInput("range", "WordCloud Range:",
                                         min = 1, max = 1000,
                                         value = c(2,100)),
                             column(width =6,align='left',plotOutput('wordCloud1',height=700,width=600)),
                             column(width=6,align='right',plotOutput('wordCloud2',height=700,width=600))
                             ),
                             
                    
                    tabPanel("Co-occurrences ",
                             sliderInput("cogSlide", "Data Frame Size:",
                                         min = 10, max = 1000,
                                         value = 30),
                             
                             plotOutput('cogGraphs'))
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI


