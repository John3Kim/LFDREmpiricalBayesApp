library(shiny)
library(shinyBS)

shinyUI(fluidPage(theme = "main.css",
   titlePanel("LFDREmpiricalBayes Data Analysis Demo"),

   wellPanel(
      tags$div(class = "description",
         HTML(paste("The functions associated with this 
                 app is based on the R package LFDREmpricalBayes and can 
                 be installed by issuing the following command:", 
                 tags$span(class = "code",
                 "install.packages('LFDREmpiricalBayes')"),".",
                 br(),br(),
                 "The LFDREmpiricalBayes Data Analysis Demo allows 
                 users to test out the functions", tags$span(class = "code",
                 "caution.parameter.actions"),"and",
                 tags$span(class = "code","SEL.caution.parameter"), 
                 "given two sets of LFDR estimates provided below.", sep = " "))
              ), 
         br(),
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
                   h4("a. Input LFDR estimates"), 
                   h5("Choose method of input: "),
                   helpText("Choose the method of input below and fill out 
                            their corresponding fields on the right."),
                   radioButtons(inputId = "choiceLFDRInput",
                                label = NULL, 
                                choices = c("File Import" = "fileIn", 
                                            "Text Input" = "textIn"))
                  ), 
             
            column(9, 
                uiOutput("ui")
                   )
         )),
      
      wellPanel(
         fluidRow(
            column(3,
               h4("b. Input loss values"),
               helpText(HTML(paste("(Used only in the Zero-One Loss 
                                   output.)", br(), br(),
                                   "Input values based on the cost/benefit 
                                   ratio, or the threshold of a true or false 
                                   discovery.", sep=""))) 
                  ),
            
            column(4,
               tags$p(tags$strong("Equation for threshold:"),br(),
                      tags$span(class = "math-font", 
                                "threshold =  (l",tags$sub("I"), 
                      " / (l",tags$sub("I")," + l",tags$sub("II"), 
                      "))")),
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
         fluidRow( 
         wellPanel("Hover your mouse over the results or 
                   the underlined text to see definitions."),
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
               tags$span(class = "help-output", tableOutput("ZeroOneOutput")) 
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

            wellPanel(
                tags$div(class = "help-output", tableOutput("SELOutput"))) 
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
            HTML(paste("The RShiny app and code modifications to Ali's R code
               is brought to you by Johnary Kim.",br(),br(), "The source code can be located ",
                 tags$a(href = "https://github.com/John3Kim/LFDREmpiricalBayesApp","here"),".",sep = "")), 
            br(), br(),
            HTML(paste("The work of the R package and documentation was done 
                       under the supervision of Dr. David R. Bickel. Some of 
                       his other work can be found ", 
                 tags$a(href = "https://davidbickel.com","here"),".",sep = ""))
                  ), 
         wellPanel(
             h4("Legal"), 
             HTML(paste("LFDREmpiricalBayes Data Analysis Demo is licensed under ", 
                  tags$a(href ="https://www.gnu.org/licenses/gpl-3.0.en.html","GPL-3"),"."
                  ,sep =""))
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