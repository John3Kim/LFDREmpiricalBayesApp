library(shiny)
library(shinyBS)


shinyUI(fluidPage(theme = "main.css",
   titlePanel("LFDREmpiricalBayes Data Analysis Demo"),

   wellPanel(
      tags$div(class = "description",
         HTML(paste(tags$strong("Note: "), "The functions associated with this 
                 app is based on LFDREmpricalBayes and will be 
                 available soon to install on R.",br(),br(),

                 "The LFDREmpiricalBayes Data Analysis Demo allows 
                 users to test out the functions", tags$span(class = "code",
                 "caution.parameter.actions"),"and",
                 tags$span(class = "code","SEL.caution.parameter"), 
                 "given two sets of LFDR estimates provided below.", sep = " "))
              ), 
         br(),
         tags$p("In order to use the file import option, ensure that 
                you have a .csv file in the following order: gene name,
                reference class one and reference class two."), 
         p("To use this app, follow steps 1 to 3 as labelled on 
                the tabs.")
            ),
        
   tabsetPanel( 
      tabPanel("1. Set Parameters",
      br(),
      # Row by row is easiest to look at
      wellPanel(
         fluidRow( 
            column(3,
                   h4("1. Input LFDR estimates"), 
                   h5("Choose method of input: "),
                   helpText("Choose the method of input below and fill out 
                            their corresponding fields on the right."),
                   radioButtons(inputId = "choiceLFDRInput",
                                label = NULL, 
                                choices = c("File Import" = "fileIn", 
                                            "Text Input" = "textIn")), 
                   conditionalPanel(condition = "input.fileIn == true")  
                  ), 
             
            column(4, 
                   fileInput(inputId = "LFDREstimatesFile",
                             label = "Import LFDR estimates as a CSV file:", 
                             multiple = FALSE,
                             accept = c(".csv")),
                                    
                   checkboxInput(inputId = "chooseFileHeader", 
                                 label = ".csv file contains header? 
                                 (Check if true.)", 
                                 value = FALSE)
                   ),
            
            column(5,
                   strong("Input LFDR estimates by text input:"),
                   helpText("Separate LFDR estimates by a comma. (Can optionally 
                            be separated by a space in addition to a comma.)"),
                                    
                   textInput(inputId = "x1Input",
                             label = "Values of the first reference class", 
                             placeholder = "Input LFDR values", 
                             value = "0.14, 0.80, 0.16, 0.94"),
                   
                   textInput(inputId = "x2Input",
                             label = "Values of the second reference class", 
                             placeholder = "Input LFDR values", 
                             value = "0.21, 0.61, 0.12, 0.82")
                   
                   ))),
      wellPanel(
         fluidRow(
            column(3,
               h4("2. Input loss values"),
               helpText(HTML(paste("(Used only in the Zero-One Loss 
                                   output.)", br(), br(),
                                   "Input values based on the cost/benefit 
                                   ratio, or the threshold of a true or false 
                                   discovery.", sep=""))) 
                  ),
            
            column(4,
               tags$p(tags$strong("Equation for threshold:"),br(),
                      "Threshold =  (l",tags$sub("I"), 
                      " / (l",tags$sub("I")," + l",tags$sub("II"), 
                      "))"),
               textInput(inputId = "l1Input",
                         label = HTML(paste("Loss due to type-I error (l"
                                            ,tags$sub("I"),"):", 
                                            sep = "")), 
                         value = "4", 
                         placeholder = "Input numerical loss value"),
               
               textInput(inputId = "l2Input",
                         label = HTML(paste("Loss due to type-II error (l"
                                            ,tags$sub("II"),"):",sep = "")), 
                         placeholder = "Input numerical loss value",
                         value = "1")
               ),
                             
            column(5,
               strong("Threshold:"), 
               helpText("This is the threshold used 
                        to reject or fail to reject the null hypothesis based on 
                        the given LFDR estimates."),
               verbatimTextOutput("cautionThreshold")
                  )
                  ))),
            
      tabPanel("2. See Results",
         br(),
         
         wellPanel( 
             HTML(paste("To know what", strong("CGM0, CGM1,"),"and", 
                        strong("CGM0.5"), 
                        "represent, click on the result boxes below after", 
                        "inputting LFDR", 
                        "estimates and loss values.", sep = " "))
             
            ),
         
         fluidRow(
         column(7,
            HTML(paste(strong("Based on your LFDR estimates and loss values, 
                 your "), tags$span(id = "zero-one-def", "Zero-One output"), 
                       strong(" is:"), sep = "")), 
            bsPopover(id = "zero-one-def",
                      title = "Zero-One output",
                      content = paste("Fail to reject or reject a null hypothesis.",
                                      "  0 denotes failure to reject; ",
                                      " 1 denotes reject.", sep=""),
                      placement = "top"),

            wellPanel(
               tableOutput("ZeroOneOutput") 
                     )
         ),
      
         column(5,
            HTML(paste(strong("Based on your LFDR estimates, your"), 
                       tags$span(id = "sel-def", "SEL output"), 
                       strong(" is:"),
                       sep = " ")),
            bsPopover(id = "sel-def",
                      title = "SEL output",
                      content = paste("The", 
                                      strong("squared error loss"), "function.",
                                      "It denotes the odds ratio and", 
                                      "quantifies",
                                      "the association of a gene to a ",
                                      "partitcular disease", sep = " "),
                      placement = "top"),

            wellPanel(tableOutput("SELOutput")) 
            
               ))), 
      
      tabPanel("3. Download", 
        br(), 
        wellPanel(
            HTML(paste(tags$strong("Note: ")," Some users have experienced 
                       some issues with downloading the file with the 
                       correct extension.  If you are experiencing this 
                       problem, please ensure that you type in .csv after 
                       the output file name.", sep = ""))
        ),
        strong("Download your results here:"), 
        br(), 
        downloadButton(outputId = "CSVOut", 
               label = "Download Results (.csv)")
               ),
      
      tabPanel("About", 
         br(),
         wellPanel(
            h4("Credits"),
            HTML(paste("The R functions ",
               tags$span(class = "code", "caution.parameter.actions"), 
               " and ", tags$span(class = "code", "SEL.caution.parameter"), 
               " were originally created by Ali Karimnezhad.", sep = "")), 
            p("The RShiny app and code modifications to Ali's R code
               is brought to you by Johnary Kim.") 
                  ), 
         wellPanel( 
             h4("Contact"), 
             HTML(paste("For any issues regarding the RShiny app and its 
                        underlying scripts, please contact the authors below.", 
                        br(),
                        br(), tags$strong("Ali Karimnezhad:  "),
                        tags$a(href = "mailTo:ali_karimnezhad@yahoo.com", 
                               "ali_karimnezhad@yahoo.com"),
                        br(), tags$strong("Johnary Kim:  "),  
                        tags$a(href = "mailTo:jkim226@uottawa.ca",
                               "jkim226@uottawa.ca"),
                        sep = ""))
             ),
         wellPanel( 
             h4("References"), 
             HTML(paste("Karimnezhad, A. and Bickel, D. R. (2016). Incorporating 
                        prior knowledge about genetic variants into the analysis 
                        of genetic association data: An empirical Bayes approach. 
                        Working paper. Retrieved from ",
                        tags$a(href = "http://hdl.handle.net/10393/34889", 
                               "http://hdl.handle.net/10393/34889"),".", 
                        sep = ""))
             
              ) 
         
         ) 
       
)))

