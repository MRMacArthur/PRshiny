library(shiny)
library(mixOmics)
library(ggplot2)
library(MetaboAnalystR)
library(dplyr)
library(ggthemr)
library(plotly)
library(heatmaply)

navbarPage("Protein Restriction Metabolomics",
           tabPanel("Semi-Purified Titration",
                    fluidRow(
                      column(2,
                        
                          selectInput('normMet', 'Sample Normalization Method',
                                      c('NULL', 'SumNorm', 'MedianNorm', 'QuantileNorm'), selected = 'QuantileNorm'),
                          selectInput('transMet', 'Data Transformation Method',
                                      c('NULL', 'LogNorm', 'CrNorm')),
                          selectInput('scaleMet', 'Data Scaling Method',
                                      c('NULL', 'MeanCenter', 'AutoNorm', 'ParetoNorm', 'RangeNorm')),
                          
                          selectInput('metab', 'Metabolite', 
                                      colnames(read.csv("./Data/metabolomicsRaw2.csv")),
                                      selected = "glyoxylate"),
                          checkboxInput('sigOnly', 'Heatmap: Only show significant', value = T)
                                    ),
                      column(10,
                             plotOutput('plot')
                             )),
                    
                    fluidRow(
                      column(4,
                             verbatimTextOutput('anva')
                             ),
                      column(8,
                             plotlyOutput('plotHeatMap')
                             )
                    
                      )
                    ),
           
           tabPanel("DR PR Thermoneutrality",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('normMetDRPR', 'Sample Normalization Method',
                                    c('NULL', 'SumNorm', 'MedianNorm', 'QuantileNorm'), selected = 'QuantileNorm'),
                        selectInput('transMetDRPR', 'Data Transformation Method',
                                    c('NULL', 'LogNorm', 'CrNorm')),
                        selectInput('scaleMetDRPR', 'Data Scaling Method',
                                    c('NULL', 'MeanCenter', 'AutoNorm', 'ParetoNorm', 'RangeNorm')),
                        
                        selectInput('metabDRPR', 'Metabolite', 
                                    colnames(read.csv("./Data/DRPRMetabolomicsAll.csv")),
                                    "Vitamin_C")
                      ),
                      mainPanel(
                        plotOutput('plotDRPR')
                      )
                    )
           ),
           fluid = T
           
           
)

