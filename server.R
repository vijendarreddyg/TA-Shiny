#######################################################
#              POSTAGGING USING UDPIPE                #
#######################################################

shinyServer(function(input,output,session){
  set.seed=013432
  
   dataFile <- reactive({
     if(is.null(input$file)){return(NULL)}
     else{
       text_Data = readLines(input$file$datapath)
       return(text_Data)
     }
   })#end of datafile function
   
  
   #choose the model
   model <- reactive({
     
     if(input$selectModel == "english-ewt"){
         model_name <- udpipe_load_model("english-ewt-ud-2.4-190531.udpipe")
       
     }else if(input$selectModel == "english-gum"){
       model_name <- udpipe_load_model("english-gum-ud-2.4-190531.udpipe")
       
     }else if(input$selectModel =="english-lines"){
       model_name <- udpipe_load_model("english-lines-ud-2.4-190531.udpipe")
       
     }else if(input$selectModel =="english-partut"){
       model_name <- udpipe_load_model("english-partut-ud-2.4-190531.udpipe")
     }else{
       model_name <- udpipe_load_model("english-ewt-ud-2.4-190531.udpipe")
       
     }
   return(model_name)
     })#end of model
   
annotated = reactive({
  tData = dataFile()
  clean_Data = str_replace_all(tData,"<.*?>","")
  annotatedDf <- udpipe_annotate(model(),clean_Data)
  finalAnnotate <- select(as.data.frame(annotatedDf),-sentence)
  finalAnnotate
  head(finalAnnotate,input$annoSlide)
}) 

#display the data
output$annotate <- renderDataTable({
   annotated()
}) #end of display the data

#wordcloud functions
output$wordCloud1 <- renderPlot({
   data <- annotated()
   all_nouns = data %>% subset(., upos %in% "NOUN"); all_nouns$token[1:20]
   top_nouns = txt_freq(all_nouns$lemma)
   wordcloud(words = top_nouns$key, 
             freq = top_nouns$freq, 
             min.freq = input$range[1], 
             max.words = input$range[2],
             random.order = FALSE, 
             colors = brewer.pal(6, "Dark2"))
   }) #end of output$wc1
output$wordCloud2 <- renderPlot({
   data <- annotated()
   all_verbs = data %>% subset(., upos %in% "VERB"); all_verbs$token[1:20]
   top_verbs = txt_freq(all_verbs$lemma)
   wordcloud(words = top_verbs$key, 
             freq = top_verbs$freq, 
             min.freq = input$range[1], 
             max.words = input$range[2],
             random.order = FALSE, 
             colors = brewer.pal(6, "Dark2"))
}) #end of wordcloud2

output$cogGraphs <- renderPlot({
   data <- annotated()
   print(c(input$input_selection))
   plot_cooc <- cooccurrence(     # try `?cooccurrence` for parm options
     
      x = subset(data, upos %in% c(input$input_selection)), 
      term = "lemma", 
      group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
   wordnetwork <- head(plot_cooc, input$cogSlide)
   wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
   
   ggraph(wordnetwork, layout = "fr") +  
      
      geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      
      labs(title = "Cooccurrences within 3 words distance", subtitle = "Cooccurence for Different POS")
   
   }) #end of coocc graphs

#complete dataframe
fullAnnotated = reactive({
   tData = dataFile()
   clean_Data = str_replace_all(tData,"<.*?>","")
   annotatedDf <- udpipe_annotate(model(),clean_Data)
   finalAnnotate <- select(as.data.frame(annotatedDf),-sentence)
   return(finalAnnotate)
})

output$downloadData <- downloadHandler(
   filename = function() {
   "data.csv"
   },
   content = function(file) {
      write.csv(fullAnnotated(), file)
   }
)
   }
)#end of shinyserver
