library(shiny)

shinyUI(fluidPage(theme = "main.css",
    titlePanel("caution.parameter.actions Demo"),
    
    sidebarLayout(
        sidebarPanel(
            h4("1. Input LFDR estimates"),
            radioButtons(inputId = "choiceLFDRInput",
                         label = "Choose method of input", 
                         choices = c("File Import" = "fileIn", 
                                     "Text Input" = "textIn")),
            
            fileInput(inputId = "LFDREstimatesFile",
                      label = "Import LFDR values as a CSV file:", 
                      multiple = FALSE,
                      accept = c(".csv")),
            
            checkboxInput(inputId = "chooseFileHeader", 
                          label = "Contains header? (Checked if true.)", 
                          value = TRUE),
            
            strong("Input by using the text boxes below:"),
            helpText("Separate LFDR values by a comma 
                     and zero or more spaces."),
            
            textInput(inputId = "x1Input",
                      label = "Values of the first separate class (x1)", 
                      placeholder = "Input LFDR values", 
                      value = "0.14, 0.80, 0.16, 0.94"),
            textInput(inputId = "x2Input",
                      label = "Values of the second separate class (x2)", 
                      placeholder = "Input LFDR values", 
                      value = "0.21, 0.61, 0.12, 0.82"),
            
            h4("2. Input loss values"),
            
            helpText("Input values based on the cost/benefit ratio 
                      (l1 / (l1+l2)) of a true or false discovery."),
            
            textInput(inputId = "l1Input",
                      label = "l1: Loss due to type-I error", 
                      value = "4", 
                      placeholder = "Input numerical loss value"),
            
            textInput(inputId = "l2Input",
                      label = "l2: Loss due to type-II error", 
                      placeholder = "Input numerical loss value",
                      value = "1")
            ),
        
        
        mainPanel(
            
            strong("Based on your LFDR estimates and loss values, 
               your Zero-One method output is:"),
            verbatimTextOutput("ZeroOneOutput"), 
            #verbatimTextOutput("SELOutput"),
            downloadButton(outputId = "CSVOut", 
                           label = "Download Results"),
            hr(),
            wellPanel(
                h5("Credits"),
                p("This code is based on the caution.parameter.actions 
                  R function made by Ali Karimnezhad."), 
                p("RShiny app brought to you by Johnary Kim.")
            )
))))

