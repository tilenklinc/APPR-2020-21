library(shinydashboard)
library(shinythemes)
library(ggplot2)
library(forecast)
library(tseries)
library(quantmod)
#------------------------UI------------------------#
skin <- Sys.getenv("DASHBOARD_SKIN")
skin <- tolower(skin)
if (skin == "")
  skin <- "blue"

#HEADER
header <- dashboardHeader(
  title = "Predikcija cen"
)

#SIDEBAR
sidebar <- dashboardSidebar(disable = TRUE,
    sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"))
  )
)

#BODY
body <- dashboardBody(
  tabItems(
    tabItem("dashboard",
            
            # Okvircki
            fluidRow(
              box( # input imena
                title = "Vnesi ime delnice", width = 3, solidHeader = TRUE, status = "primary",
                textInput("StockCode", "StockCode", value = "GOOGL"),
                radioButtons("seasonal", "Izberi natančnost", c(NonSeasonal = "Non Seasonal", Seasonal = "Seasonal")),
                actionButton(inputId = "click", label = "Predvidi")
              )
            ),
            
      fluidRow(
        #okence za prikaz tabele
        box( 
          title = "Graf - Seasonal",
          status = "primary",
          plotOutput("arima.seasonal", height = 360),
          height = 420,
          position = "top"
        ),
        box(
          title = "Tabela - Seasonal",
          status = "success",
          width = 6,
          tableOutput("arima.seasonal.table"),
          height = 420
        ),
        
      ),
      
      fluidRow(
        box(
          title = "Graf - Non Seasonal",
          status = "primary",
          plotOutput("auto.arima", height = 360),
          height = 420
        ),
        box(
          title = "Tabela - Non Seasonal",
          status = "success",
          width = 6,
          tableOutput("auto.arima.table"),
          height = 420
        )
        
      )
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = skin, shinytheme("readable"))


#------------------------SERVER--------------------------#
server <- function(input, output) {
  
#-------------------GRAF_NonSEASONAL---------------------#  
#Auto.Arima - GRAF1
  output$auto.arima <- renderPlot({
    
    data <- eventReactive(input$click, {
      (input$StockCode)
    })
    Stock <- as.character(data())
    print(Stock)
    
    # pridobitev podatkov
    Stock_df<-as.data.frame(getSymbols(Symbols = Stock, 
                                   src = "yahoo", from = "2020-10-12", env = NULL))
    # preimenovaje stolpcev
    Stock_df$Open = Stock_df[,1]
    Stock_df$High = Stock_df[,2]
    Stock_df$Low = Stock_df[,3]
    Stock_df$Close = Stock_df[,4]
    Stock_df$Volume = Stock_df[,5]
    Stock_df$Adj = Stock_df[,6]
    Stock_df <- Stock_df[,c(7,8,9,10,11,12)] 
    
    # moving average
    Stock_df$v7_MA = ma(Stock_df$Close, order=7)
    Stock_df$v30_MA <- ma(Stock_df$Close, order=30)
    
    #STL
    rental_ma <- ts(na.omit(Stock_df$v7_MA), frequency=30)
    decomp_rental <- stl(rental_ma, s.window="periodic")
    adj_rental <- seasadj(decomp_rental)
    
    
    #arima PLOT
    fit <- auto.arima(Stock_df$Close,ic="bic")
    fit.forecast <- forecast(fit)
    plot(fit.forecast,  main= Stock, xlab="Zadnjih 80 Dni", ylab="Vrednost delnice [$]",
         col.main = "blue", lwd = 2)
   
 })
  
#--------------------TABELA_NonSEASONAL--------------------#
#auto.arima.table - TABELA1
  
     output$auto.arima.table <- renderTable({
     
      data <- eventReactive(input$click, {
        (input$StockCode)
       })
      Stock <- as.character(data())
      print(Stock)
     
      
     Stock_df<-as.data.frame(getSymbols(Symbols = Stock,
                                        src = "yahoo", from = "2020-10-12", env = NULL))
     Stock_df$Open = Stock_df[,1]
     Stock_df$High = Stock_df[,2]
     Stock_df$Low = Stock_df[,3]
     Stock_df$Close = Stock_df[,4]
     Stock_df$Volume = Stock_df[,5]
     Stock_df$Adj = Stock_df[,6]
     Stock_df <- Stock_df[,c(7,8,9,10,11,12)]

     Stock_df$v7_MA = ma(Stock_df$Close, order=7)
     Stock_df$v30_MA <- ma(Stock_df$Close, order=30)

     #STL
     rental_ma <- ts(na.omit(Stock_df$v7_MA), frequency=30)
     decomp_rental <- stl(rental_ma, s.window="periodic")
     adj_rental <- seasadj(decomp_rental)
     

     #arima
     fit <- auto.arima(Stock_df$Close,ic="bic")
     fit.forecast <- forecast(fit)
     fit.forecast
   })

#------------------------GRAF_SEASONAL-------------------------#

#Auto.Arima Seasonal - GRAF2
     output$arima.seasonal <- renderPlot({
       if (input$seasonal == "NonSeasonal")
         return()
       
       data <- eventReactive(input$click, {
         (input$StockCode)
       })
       Stock <- as.character(data())
       print(Stock)
       Stock_df<-as.data.frame(getSymbols(Symbols = Stock,
                                          src = "yahoo", from = "2020-10-12", env = NULL))
       Stock_df$Open = Stock_df[,1]
       Stock_df$High = Stock_df[,2]
       Stock_df$Low = Stock_df[,3]
       Stock_df$Close = Stock_df[,4]
       Stock_df$Volume = Stock_df[,5]
       Stock_df$Adj = Stock_df[,6]
       Stock_df <- Stock_df[,c(7,8,9,10,11,12)]
       
       # moving average
       Stock_df$v7_MA = ma(Stock_df$Close, order=7)
       Stock_df$v30_MA <- ma(Stock_df$Close, order=30)
       
       #STL
       rental_ma <- ts(na.omit(Stock_df$v7_MA), frequency=30)
       decomp_rental <- stl(rental_ma, s.window="periodic")
       adj_rental <- seasadj(decomp_rental)
       
       
       fit_s<-auto.arima(adj_rental, seasonal=TRUE)
       fcast_s <- forecast(fit_s, h=10)
       plot(fcast_s, xlab = "Obdobja [v mesecih]", main = "Napoved za naslednje obdobje",
            ylab = "Vrednost delnice [$]", col.main = "blue", lwd = 2)
     })

#------------------------TABELA_SEASONAL-------------------------#
     #Auto.Arima Seasonal TABELA2
     output$arima.seasonal.table <- renderTable({
       if (input$seasonal == "NonSeasonal")
         return()
       
       data <- eventReactive(input$click, {
         (input$StockCode)
       })
       Stock <- as.character(data())
       print(Stock)
       Stock_df<-as.data.frame(getSymbols(Symbols = Stock,
                                          src = "yahoo", from = "2020-10-12", env = NULL))
       Stock_df$Open = Stock_df[,1]
       Stock_df$High = Stock_df[,2]
       Stock_df$Low = Stock_df[,3]
       Stock_df$Close = Stock_df[,4]
       Stock_df$Volume = Stock_df[,5]
       Stock_df$Adj = Stock_df[,6]
       Stock_df <- Stock_df[,c(7,8,9,10,11,12)]
      
       
       Stock_df$v7_MA = ma(Stock_df$Close, order=7)
       Stock_df$v30_MA <- ma(Stock_df$Close, order=30)
       
       #STL
       rental_ma <- ts(na.omit(Stock_df$v7_MA), frequency=30)
       decomp_rental <- stl(rental_ma, s.window="periodic")
       adj_rental <- seasadj(decomp_rental)
       
       
       #arima
      fit_s<-auto.arima(adj_rental, seasonal=TRUE)
      fcast_s <- forecast(fit_s, h=10)
      fcast_s
     })
  
  
}

#------------------------APP-------------------------#
shinyApp(ui, server)
