library(shiny)

shinyUI(fluidPage(
    titlePanel("caution.parameter.actions Demo"),
    
    sidebarPanel(
        h4("1. Input LFDR estimates"),
        radioButtons(inputId = "ChoiceLFDR",
                     label = "Choose method of input", 
                     c("File Import", "Text Input")),
        
        fileInput(inputId = "LFDRestimatesFile",
                  label = "Import LFDR values:", multiple = FALSE),
        
        p("Ensure that your LFDR estimates are separated 
             by a comma and a space (e.g. 0.1, 0.2)"),
        textInput(inputId = "x1Input",
                  label = "x1", value = "0"),
        textInput(inputId = "x2Input",
                  label = "x2", value = "0"),
        
        h4("2. Input loss values"),
        #sliderInput(inputId = "num",
        #           label = "Predefined threshold (%)",
        #           value = 25, min = 1, max = 100),
        
        textInput(inputId = "l1Input",
                  label = "l1", value = "4"),
        
        textInput(inputId = "l2Input",
                  label = "l2", value = "1")
    ),
    
    
    mainPanel(
       h5("Based on your LFDR estimates and loss values, your result is:"),
       verbatimTextOutput("ZeroOne"),
       downloadButton(outputId = "CSVOut")
    )
))

