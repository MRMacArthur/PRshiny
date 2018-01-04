library(shiny)
library(mixOmics)
library(ggplot2)
library(MetaboAnalystR)
library(dplyr)
library(ggthemr)
library(heatmaply)

ggthemr('fresh')

#./Data/metabolomicsRaw2.csv
#C:\\Users\\mrj55\\Documents\\Harvard\\Mitchell\\shinyApps\\PRmetabShiny\\Data\\metabolomicsRaw2.csv
function(input, output, session) {
  
  normData <- function() {
    
    metData <-InitDataObjects("specbin", "stat", FALSE)
    metData<-Read.TextData(metData, "./Data/metabolomicsRaw2.csv", 
                           "rowtu", 
                           "disc");
    metData<-SanityCheckData(metData)
    metData<-ReplaceMin(metData);
    
    nMetData <- 
      reactive({
      suppressWarnings(
        ANOVA.Anal(Normalization(metData, 
                    input$normMet, 
                    input$transMet, 
                    input$scaleMet, 
                    "p0_1", 
                    ratio = F, 
                    ratioNum = 20),
                 F, 0.05, "fisher")
      )
    })
    
    nMetFrame <- nMetData()$dataSet$norm
    
    nMetFrame$expGroup <- factor(nMetData()$dataSet$cls, 
                                 levels = c("pct0", "pct2", "pct6", "pct10", "pct14", "pct18"),
                                 labels = c("0%", "2%", "6%", "10%", "14%", "18%"))
    
    heatMapMat <- data.frame(nMetData()$analSet$aov$sig.mat)

    return(list(nMetFrame, heatMapMat))
    
  }
  
  observe({
    updateSelectInput(session, "metab",
                      choices = colnames(normData()[[1]]))
  })  
  
  output$anva <- renderPrint({
    
    list(summary(aov(lm(as.formula(paste(input$metab, "expGroup", sep = " ~ ")), data = normData()[[1]]))), 
         TukeyHSD(aov(lm(as.formula(paste(input$metab, "expGroup", sep = " ~ ")), data = normData()[[1]]))))
  })
  
  output$plot <- renderPlot({
    
    p <- ggplot(data = normData()[[1]], aes_string(x="expGroup", y=input$metab, group = "expGroup")) + 
      geom_boxplot(aes_string(fill = "expGroup")) +
      labs(x = NULL)
    
    print(p)
    
  })
  
  output$plotHeatMap <- renderPlotly({
    
    if (input$sigOnly)
      heatmaply(normData()[[1]][, colnames(normData()[[1]]) %in% c(rownames(normData()[[2]]), "expGroup")], 
                 scale = "column",
                 colors = colorRampPalette(colors = c("blue", "white", "red")),
                 k_col = 2, k_row = 2, labRow = NULL, labCol = NULL,
                 margins = c(10, 10, 10, 10))
    else
      heatmaply(normData()[[1]], 
                scale = "column",
                colors = colorRampPalette(colors = c("blue", "white", "red")),
                k_col = 2, k_row = 2, labRow = NULL, labCol = NULL,
                margins = c(10, 10, 10, 10))
    
  })
  
  #./Data/DRPR MetabolomicsAll.csv
  #C:\\Users\\mrj55\\Documents\\Harvard\\Mitchell\\shinyApps\\PRmetabShiny\\Data\\DRPRMetabolomicsAll.csv
  normDataDRPR <- function() {
    
    metDataDRPR <-InitDataObjects("pktable", "ts", FALSE)
    metDataDRPR<-SetDesignType(metDataDRPR, "g2")
    metDataDRPR <-Read.TextData(metDataDRPR, "./Data/DRPRMetabolomicsAll.csv", 
                                "rowts", "disc");
    metDataDRPR <-SanityCheckData(metDataDRPR)
    metDataDRPR <-ReplaceMin(metDataDRPR);
    
    nMetDataDRPR <- reactive({
      Normalization(metDataDRPR, 
                    input$normMetDRPR, 
                    input$transMetDRPR, 
                    input$scaleMetDRPR, 
                    "C_AL_22_1", 
                    ratio = F, 
                    ratioNum = 20)
    })
    
    
    
    nMetFrameDRPR <- nMetDataDRPR()$dataSet$norm
    
    nMetFrameDRPR$Temp <- factor(nMetDataDRPR()$dataSet$facB, 
                                 levels = c("RT", "ThermoN"), 
                                 labels = c("RoomTemp", "Thermoneutral"))
    
    nMetFrameDRPR$Diet <- factor(nMetDataDRPR()$dataSet$facA,
                                 levels = c("Complete", "DR", "PR", "DR_PR"))
    
    nMetFrameDRPR$DietTemp <- interaction(nMetFrameDRPR$Diet, nMetFrameDRPR$Temp)
    
    return(nMetFrameDRPR)
    
  }
  
  observe({
    updateSelectInput(session, "metabDRPR",
                      choices = colnames(normDataDRPR()))
  })
  
  
  output$plotDRPR <- renderPlot({
    q <- ggplot(data = normDataDRPR(), aes_string(x = "DietTemp", y = input$metabDRPR,
                                                  group = "DietTemp")) +
      geom_boxplot(aes_string(fill = "DietTemp")) +
      labs(x = NULL)
    
    print(q)
    
  }, height=700)
  
}