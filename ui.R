library(shiny)

shinyUI(fluidPage(theme = "main.css",
   titlePanel("LFDREmpiricalBayes Data Analysis Demo"),
    
   wellPanel(
      h4("About"), 
      p("The LFDREmpiricalBayes Data Analysis Demo allows the 
         users to test out the functions caution.parameter.actions 
         and SEL.caution.parameter given two sets of LFDR estimates.  
         This RShiny app is based on the package LFDREmpiricalBayes 
         and will be available soon."), 
      p("Follow the steps labelled on the tabs.")
       ),
   
      hr(),
        
   tabsetPanel( 
      tabPanel("1. Set Parameters",
      # Row by row is easiest to loook at
      wellPanel(
         fluidRow( 
            column(3,
                   h4("1. Input LFDR estimates"),
                   radioButtons(inputId = "choiceLFDRInput",
                                label = "Choose method of input:", 
                                choices = c("File Import" = "fileIn", 
                                            "Text Input" = "textIn"))
                                    
                  ), 
             
            column(4, 
                   fileInput(inputId = "LFDREstimatesFile",
                             label = "Import LFDR estimates as a CSV file:", 
                             multiple = FALSE,
                             accept = c(".csv")),
                                    
                   checkboxInput(inputId = "chooseFileHeader", 
                                 label = "Contains header? (Check if true.)", 
                                 value = FALSE)
                   ),
            
            column(5,
                   strong("Input by using the text boxes below:"),
                   helpText("Separate LFDR estimates by a comma 
                             and zero or more spaces."),
                                    
                   textInput(inputId = "x1Input",
                             label = "Values of the first separate class (x1)", 
                             placeholder = "Input LFDR values", 
                             value = "0.14, 0.80, 0.16, 0.94"),
                   
                   textInput(inputId = "x2Input",
                             label = "Values of the second separate class (x2)", 
                             placeholder = "Input LFDR values", 
                             value = "0.21, 0.61, 0.12, 0.82")
                                    ))),
      wellPanel(
         fluidRow(
            column(3,
               h4("2. Input loss values"),
               helpText("Input values based on the cost/benefit ratio 
                        (l1 / (l1+l2)) of a true or false discovery. (Used only
                        in the Zero-One Loss output.)") 
                  ),
            
            column(4,
               textInput(inputId = "l1Input",
                         label = "Loss due to type-I error (l1):", 
                         value = "4", 
                         placeholder = "Input numerical loss value")),
                             
            column(4,
               textInput(inputId = "l2Input",
                         label = "Loss due to type-II error (l2):", 
                         placeholder = "Input numerical loss value",
                         value = "1")
                             ) 
                  ))),
            
      tabPanel("2. See Results",
         strong("Based on your LFDR estimates and loss values, 
                 your Zero-One output is:"),
         verbatimTextOutput("ZeroOneOutput"), 
                    
         br(),
         strong("Based on your LFDR estimates, your SEL output is:"),
         verbatimTextOutput("SELOutput"),
                         
         downloadButton(outputId = "CSVOut", 
                        label = "Download Results (.csv)")
               ), 
                
      tabPanel("About", 
         wellPanel(
            h4("Credits"),
            p("This code is based on the caution.parameter.actions 
               R function made by Ali Karimnezhad."), 
            p("The RShiny app brought to you by Johnary Kim.")  
                  )
              )
)))

