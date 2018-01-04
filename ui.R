library(shiny)
library(mixOmics)
library(ggplot2)
library(MetaboAnalystR)
library(dplyr)

navbarPage("Protein Restriction Metabolomics",
           tabPanel("Semi-Purified Titration",
                    sidebarLayout(
                      sidebarPanel(
                        selectInput('normMet', 'Sample Normalization Method',
                                    c('NULL', 'SumNorm', 'MedianNorm', 'QuantileNorm'), selected = 'QuantileNorm'),
                        selectInput('transMet', 'Data Transformation Method',
                                    c('NULL', 'LogNorm', 'CrNorm')),
                        selectInput('scaleMet', 'Data Scaling Method',
                                    c('NULL', 'MeanCenter', 'AutoNorm', 'ParetoNorm', 'RangeNorm')),
                        
                        selectInput('metab', 'Metabolite', "")
                                  ),
                      mainPanel(
                        fluidRow(
                        plotOutput('plot')
                        ),
                        fluidRow(
                          plotlyOutput('plotHeatMap')
                      )
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
                        
                        selectInput('metabDRPR', 'Metabolite', "")
                      ),
                      mainPanel(
                        plotOutput('plotDRPR')
                      )
                    )
           ),
           fluid = T
           
           
)

