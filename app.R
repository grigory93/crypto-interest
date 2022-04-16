#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(ggplot2)
library(scales)
library(ggthemes)
library(stringr)

# prepare data
source('crypto_data_load.R', local = TRUE)

# DT options
g_DT_options = list(info = FALSE,
                    paging = FALSE,
                    searching = FALSE)

# Crypto Data
platform_data = getPlatformData()
platform_rates = platform_data[["rates"]]
platform_penalties = platform_data[["penalties"]]
platform_refs = platform_data[["refs"]]
currencies = platform_data[["currencies"]]
about_savings = platform_data[["about"]]


makeCurrencyOptions <- function(pltf = NULL) {
  if (is.null(pltf))
    dd = platform_rates
  else
    dd = platform_rates[platform == pltf, ]
  setorder(dd, type, currency)[, option_text := sprintf("%s (%s)", network, currency)]
  dd = dd[, .SD[1,], currency]
  
  ddd = dd[, .(option_text = list(option_text),
               currency = list(currency)), by = type]
  options = apply(ddd, 1, function(x)
    setNames(x[[3]], x[[2]]))
  options = setNames(options, ddd[['type']])

  return(options)
}


makeCryptoEarnData <- function() {
  result = c()
  pltfs = c()
  logos = c()
  for (pltf in platform_refs$platform) {
    refs = platform_refs[platform == pltf,]
    text = refs$referral_text
    logo = refs$logo
    ref = refs$referral_ref
    if (!is.na(ref) && !is.na(text)) {
      logos = c(logos,
                paste0('<img src="', refs$logo, '" title="', pltf, '"></img>'))
      pltfs = c(pltfs, paste0("<a href='", ref, "'>", pltf, "</a>"))
      result = c(result,
                 paste0(text, ": <a href='", ref, "' target='_blank'>", ref, "</a>"))
    }
  }
  
  data.frame(platforms = pltfs, result)
}
g_crypto_earn_data = makeCryptoEarnData()


computeCompundInterest <- function(principle, rate, months) {
  return(principle * (1 + (rate / 100) / 12) ^ (months))
}


computeReturn <- function(amt, pltf, cur, months, returnApy = FALSE) {
  if (amt <= 0)
    return(0.0)
  
  rates = platform_rates[platform == pltf &
                           currency == cur & amt > amount_lower,
                         c("amount_lower", "amount_upper", "apy")]
  
  result = 0
  amt_left = amt
  for (i in 1:nrow(rates)) {
    tier = rates[i,]
    if (amt > tier$amount_upper) {
      amt_current = tier$amount_upper - tier$amount_lower
      amt_left = amt_left - amt_current
    } else {
      amt_current = amt_left
      amt_left = 0
    }
    
    if (returnApy)
      result = ifelse(amt_current > 0, tier$apy, result)/100
    else
      result = result + computeCompundInterest(amt_current, tier$apy, months)
  }
  
  return(result)
}


makeDisclaimers <- function(cur, limit, one_free, note) {
  caption_notes = c(
    "¹ Returns could be slightly inflated due to ignoring interest crossing into lower APY range (if applicable).",
    if (!is.na(cur) && !is.na(limit))
      paste(
        "²",
        cur,
        "are subject to a maximum withdrawal amount of",
        format(limit, big.mark = ",", scientific = FALSE),
        cur,
        "per rolling 7-day period."
      ),
    if (!is.na(one_free) && one_free)
      "One free withdrawal per calendar month available but ignored for this graph.",
    if (!is.na(note))
      note,
    "All APY’s are subject to change. APY's reflect effective yield based on monthly compounding. Actual yield will vary based on account activity and compliance with respective platforms’s terms and conditions.",
    "The above is for information purposes only. It is not intended to be investment advice.",
    "© 2022 Gregory Kanevsky Infographics."
  )
  # caption_text = paste(caption_notes[!sapply(caption_notes, is.na)], collapse = '\n')
  return(caption_notes)
}


getTableauPalette <- function(count, style = 'regular') {
  tableau_pals = data.frame(
    regular = c("Tableau 10", "Tableau 20"),
    classic = c("Classic 10", "Classic 20")
  )
  if (count <= 10)
    index = 1
  else
    index = 2
  
  return(tableau_pals[[index, style]])
}


makeCurrencyNetwork <- function(cur) {
  network = currencies[currency == cur,]$network
  return(paste0(network, " (", cur, ")"))
}


makeAPYReturnForCurrency <- function(cur, amount, months) {
  df = data.table(platform = character(0),
                  cat = character(0),
                  value = numeric(0))
  for (pltf in unique(platform_rates[currency == cur,]$platform)) {
    fee = platform_penalties[platform == pltf & currency == cur, fee]
    ret = computeReturn(amount, pltf, cur, months) - amount - fee
    apy = computeReturn(amount, pltf, cur, months, returnApy = TRUE)
    df = rbind(df, data.frame(
      platform = pltf,
      cat = c('Earnings', 'APY'),
      value = c(ret, apy)
    ))
  }
  
  return(df)
}


# Define UI for application that draws a histogram
ui <- fluidPage(
  shinyjs::useShinyjs(),
  # to initialize shinyjs
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),
  
  # Application title
  titlePanel("Research and Compare Crypto Savings Accounts"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      # div(style="display: inline-block;vertical-align:top; width: 70%;",
      fluidRow(
        column(
          8,
          selectInput(
            inputId = "platform",
            label = h5("Choose Platform:"),
            choices = names(g_crypto_platforms),
            selected = "BlockFi",
            multiple = FALSE
          )
        ),
        column(
          4,
          uiOutput("whitespace1"),
          uiOutput("referralRef")
        )),
      fluidRow(#div(style="display: inline-block;vertical-align:top; width: 30%;", uiOutput("referralRef")),
        column(
          8,
          selectInput(
            inputId = "ticker",
            label = h5("Choose Coin:"),
            choices = NULL,
            selected = NULL,
            multiple = FALSE
          )
        ),
        column(
          4, 
          uiOutput("whitespace2"),
          uiOutput("currencyRef")
        )),
      sliderInput(
        inputId = "months",
        label = h5("Investment Term (months):"),
        min = 1,
        max = 60,
        value = 12
      ),
      sliderInput(
        inputId = "upperRange",
        label = h5("", id = "maxInvestmentText"),
        min = 0,
        max = 1.,
        value = 1.,
        step = 0.1
      ),
      actionLink("linkToAboutPlatforms", "About Crypto Savings Accounts")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        id = "tabset",
        tabPanel(
          title = "Returns over Time",
          value = "compoundOverTime",
          icon = icon("usd", class = "about-icon", lib = "glyphicon"),
          # icon=icon("chart-simple"),
          # hr(),
          plotOutput("investmentPlot"),
          h5(textOutput("ratesDataHeader")),
          DT::dataTableOutput("ratesData"),
          h5(textOutput("limitsFeesDataHeader")),
          DT::dataTableOutput("limitsFeesData")
        ),
        tabPanel(
          title = "Compare Returns by Platforms",
          value = "compareReturns",
          icon = icon("stats", class = "about-icon", lib = "glyphicon"),
          tabsetPanel(
            id = "compare_returns_tabset",
            tabPanel(
              title = "Compare APY's and Returns",
              icon = icon("equalizer", class = "about-icon", lib = "glyphicon"),
              plotOutput("compareAPYsAndReturnsPlot")
            ),
            tabPanel(
              title = "Compare APY's",
              icon = icon("credit-card", class = "about-icon", lib = "glyphicon"),
              plotOutput("compareAPYsPlot")
            ),
            tabPanel(
              title = "Compare Returns",
              icon = icon("piggy-bank", class = "about-icon", lib = "glyphicon"),
              plotOutput("compareReturnsPlot")
            )
          )
        ),
        tabPanel(
          title = "Compare APY's by Assets",
          value = "compareReturnsCoins",
          icon = icon("stats", class = "about-icon", lib = "glyphicon"),
          plotOutput("compareReturnsCoinsPlot")
        ),
        tabPanel(
          title = "Crypto Interest Explainer",
          value = "aboutInterestPlatforms",
          icon = icon("question-sign", class = "about-icon", lib = "glyphicon"),
          tabsetPanel(
            id = "about_tabset",
            tabPanel(
              title = "About",
              icon = icon("info-sign", class = "about-icon", lib = "glyphicon"),
              DT::dataTableOutput("aboutCryptoSavingsHeader")
            ),
            tabPanel(
              title = "How It Works",
              icon = icon("cog", class = "about-icon", lib = "glyphicon"),
              DT::dataTableOutput("aboutCryptoSavingsHowWorks")
            ),
            tabPanel(
              title = "Are there any risks?",
              icon = icon("random", class = "about-icon", lib = "glyphicon"),
              DT::dataTableOutput("aboutCryptoSavingsRisks")
            ),
            tabPanel(
              title = "Who is it ideal for?",
              icon = icon("check", class = "about-icon", lib = "glyphicon"),
              DT::dataTableOutput("aboutCryptoSavingsWhosFor")
            ),
            tabPanel(
              title = "References",
              icon = icon("book", class = "about-icon", lib = "glyphicon"),
              DT::dataTableOutput("aboutCryptoSavingsRefs")
            )
          )
        ),
        tabPanel(
          title = "Resources",
          value = "resources",
          icon = icon("info-sign", class = "about-icon", lib = "glyphicon"),
          tabsetPanel(
            id = "resource_tabset",
            tabPanel(
              title = uiOutput("resourePlatformTabPanelTitle"),
              # "Platform",
              icon = icon("cloud", class = "about-icon", lib = "glyphicon"),
              h4(textOutput("platformRefsHeader")),
              p(textOutput("platformAbout")),
              DT::dataTableOutput("platformRefs")
            ),
            tabPanel(
              title = uiOutput("resoureCoinTabPanelTitle"),
              # "Coin",
              icon = icon("bitcoin", class = "about-icon"),
              #, lib = "glyphicon"),
              h4(textOutput("currencyRefsHeader")),
              DT::dataTableOutput("currencyRefs")
            )
          )
        ),
        tabPanel(
          title = "Earn Crypto",
          value = "earnCrypto",
          icon = icon("piggy-bank", class = "about-icon", lib = "glyphicon"),
          # HTML('<img src="blockfi_logo.svg" alt="BlockFi" >'),
          h4(textOutput("earnCryptoHeader")),
          DT::dataTableOutput("earnCryptoData")
        )
      )
    )
  ),
  hr(),
  h5(textOutput("disclaimersHeader")),
  tableOutput("disclaimers")
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  # output$whichPanel <- renderText({paste0("You are viewing tab \"", input$tabset, "\"")})
  
  observeEvent(input$linkToAboutPlatforms, {
    updateTabsetPanel(session, "tabset", "aboutInterestPlatforms")
  })
  
  observeEvent(input$tabset, {
    if (input$tabset == "compareReturns") {
      shinyjs::disable("platform")
      shinyjs::enable("ticker")
      
      #choices = sort(unique(platform_rates$currency))
      choices = makeCurrencyOptions()
      selected = input$ticker
      updateSelectInput(session,
                        "ticker",
                        choices = choices,
                        selected = selected) #choices[[1]])
      label_prefix = "Investment ("
      shinyjs::html("maxInvestmentText",
                    paste0(label_prefix, input$ticker, "):"))
    } else if (input$tabset == "compareReturnsCoins") {
      shinyjs::disable("ticker")
      shinyjs::enable("platform")
      
    } else {
      shinyjs::enable("platform")
      shinyjs::enable("ticker")
      
      #choices = sort(unique(platform_rates[platform == input$platform,]$currency))
      choices = makeCurrencyOptions(input$platform)
      updateSelectInput(session,
                        "ticker",
                        choices = choices,
                        selected = choices[[1]][[1]])
    }
  })
  
  observeEvent(input$platform, {
    #choices = sort(unique(platform_rates[platform == input$platform, ]$currency))
    choices = makeCurrencyOptions(input$platform)
    choices_elements = do.call(c, choices)
    if (input$ticker %in% choices_elements)
      selected = input$ticker
    else
      selected = choices[[1]][[1]]
    updateSelectInput(session,
                      "ticker",
                      choices = choices,
                      selected = selected)
  })
  
  observeEvent(input$ticker, {
    maxValue = lookupMaxValueCrypto(input$ticker)
    updateSliderInput(
      inputId = "upperRange",
      max = maxValue * 3,
      value = maxValue,
      step = maxValue / 10
    )
    # update label
    label_prefix = ifelse(input$tabset == "compareReturns",
                          "Investment (",
                          "Maximum Investment (")
    shinyjs::html("maxInvestmentText",
                  paste0(label_prefix, input$ticker, "):"))
  })
  
  
  output$whitespace1 <- renderUI({HTML('<br/>')})
    
  
  
  output$whitespace2 <- renderUI({HTML('<br/>')})
  
  
  output$disclaimersHeader <-
    renderText({
      "Importan Info and Disclaimers"
    })
  
  
  output$limitsFeesData <- DT::renderDataTable({
    req(input$platform, input$ticker)
    pltf = input$platform
    cur = input$ticker
    
    penalties = platform_penalties[platform == pltf &
                                     currency == cur,]
    
    # check first that currency is valid for platform
    
    if (nrow(penalties) > 0)
      if (pltf == "BlockFi")
        dt = with(penalties, data.frame(
          desc = c("Withdrawal Limit",
                   "Fee",
                   "Limitations"),
          value = c(
            sprintf("%s %s per %s period", limit, currency, period),
            sprintf("%s %s", fee, currency),
            ifelse(
              is.na(note),
              ifelse(
                one_free,
                "Eligible for one free crypto withdrawal per calendar month",
                "Not currently eligible for free withdrawals"
              ),
              note
            )
          )
        ))
    else if (pltf == "Crypto.com")
      dt = with(penalties, data.frame(
        desc = c("Fee", "Term"),
        value = c(sprintf("%s %s", fee, currency),
                  term)
      ))
    else
      dt = with(penalties, data.frame(
        desc = c("Fee", "Note"),
        value = c(sprintf("%s %s", fee, currency),
                  note)
      ))
    else
      dt = data.table()
    
    DT::datatable(
      dt,
      # caption = "Interest Account Withdrawal Limits & Fees",
      options = c(g_DT_options,  list(dom = 't', bSort = FALSE)),
      rownames = FALSE,
      colnames = ""
    )
  })
  
  
  output$ratesDataHeader <- renderText({
    req(input$platform, input$ticker)
    pltf = input$platform
    cur = input$ticker
    
    "Interest Rates"
  })
  
  output$limitsFeesDataHeader <-
    renderText({
      "Interest Account Withdrawal Limits & Fees"
    })
  
  output$platformRefsHeader <- renderText({
    req(input$platform)
    pltf = input$platform
    
    paste(pltf, "Platform")
  })
  
  output$currencyRefsHeader <- renderText({
    req(input$ticker)
    cur = input$ticker
    makeCurrencyNetwork(cur)
  })
  
  
  output$resourePlatformTabPanelTitle = renderText({
    req(input$platform)
    pltf = input$platform
    
    paste(pltf, "Platform")
  })
  
  output$resoureCoinTabPanelTitle = renderText({
    req(input$ticker)
    cur = input$ticker
    makeCurrencyNetwork(cur)
  })
  
  output$platformAbout <- renderText({
    req(input$platform)
    pltf = input$platform
    
    platform_refs[platform == pltf,]$about_text
  })
  
  output$earnCryptoHeader <- renderText({
    "Sign Up with Bonus (using referral code)"
  })
  
  
  output$ratesData <- DT::renderDataTable({
    req(input$platform, input$ticker)
    pltf = input$platform
    cur = input$ticker
    
    rates = platform_rates[platform == pltf & currency == cur, ]
    
    rates$amount_str = with(rates, ifelse(
      amount_upper == Inf,
      sprintf(">%s %s", amount_lower, currency),
      sprintf("%s - %s %s", amount_lower , amount_upper, currency)
    ))
    
    rates$apy_str = with(rates, sprintf("%s%%", apy))
    
    DT::datatable(
      data.frame(amount = rates$amount_str, APY = rates$apy_str),
      # caption = "Interest Rates",
      options = g_DT_options,
      rownames = FALSE
    )
  })
  
  
  output$platformRefs <- DT::renderDataTable({
    req(input$platform)
    pltf = input$platform
    
    refs = platform_refs[platform == pltf,]
    
    rate_ref_text = paste(pltf, "rate page")
    rate_ref_url = paste0(
      rate_ref_text,
      ": <a href='",
      refs$rate_ref,
      "' target='_blank'>",
      refs$rate_ref,
      "</a>"
    )
    
    fee_ref_text = paste(pltf, "fee page")
    fee_ref_url = paste0(
      fee_ref_text,
      ": <a href='",
      refs$fee_ref,
      "' target='_blank'>",
      refs$fee_ref,
      "</a>"
    )
    
    referral_text = refs$referral_text
    referral_url = paste0(
      referral_text,
      ": <a href='",
      refs$referral_ref,
      "' target='_blank'>",
      refs$referral_ref,
      "</a>"
    )
    
    DT::datatable(
      data.frame(# c(rate_ref_text, fee_ref_text, referral_text)),
        c(
          rate_ref_url, fee_ref_url, referral_url
        )),
      # caption = paste(pltf, "Platform"),
      options = c(g_DT_options,  list(dom = 't', bSort = FALSE)),
      rownames = FALSE,
      colnames = "",
      escape = FALSE
    )
  })
  
  
  output$currencyRefs <- DT::renderDataTable({
    req(input$ticker)
    cur = input$ticker
    
    refs = currencies[currency == cur,]
    
    network = refs$network
    desc = refs$desc
    whitepaper_url = paste0(
      "Whitepaper: <a href='",
      refs$whitepaper,
      "' target='_blank'>",
      refs$whitepaper,
      "</a>"
    )
    website_url = paste0(
      "Official website: <a href='",
      refs$website,
      "' target='_blank'>",
      refs$website,
      "</a>"
    )
    
    DT::datatable(
      data.frame(c(desc, whitepaper_url, website_url)),
      # caption = makeCurrencyNetwork(cur),
      options = c(g_DT_options,  list(dom = 't', bSort = FALSE)),
      rownames = FALSE,
      colnames = "",
      escape = FALSE
    )
    
  })
  
  
  output$aboutCryptoSavingsHeader <- DT::renderDataTable({
    DT::datatable(
      data.frame(about_savings[["header"]]),
      options = c(g_DT_options,  list(dom = 't', bSort = FALSE)),
      rownames = FALSE,
      colnames = "",
      escape = FALSE
    )
  })
  
  
  output$aboutCryptoSavingsHowWorks <- DT::renderDataTable({
    DT::datatable(
      data.frame(about_savings[["how_it_works"]]),
      options = c(g_DT_options,  list(dom = 't', bSort = FALSE)),
      rownames = FALSE,
      colnames = "",
      escape = FALSE
    )
  })
  
  
  output$aboutCryptoSavingsRisks <- DT::renderDataTable({
    DT::datatable(
      data.frame(str_split_fixed(about_savings[["risks"]], ". ", 2)),
      options = c(g_DT_options,  list(dom = 't', bSort = FALSE)),
      rownames = FALSE,
      colnames = "",
      escape = FALSE
    )
  })
  
  
  output$aboutCryptoSavingsWhosFor <- DT::renderDataTable({
    DT::datatable(
      data.frame(about_savings[["whos_for"]]),
      options = c(g_DT_options,  list(dom = 't', bSort = FALSE)),
      rownames = FALSE,
      colnames = "",
      escape = FALSE
    )
  })
  
  
  output$aboutCryptoSavingsRefs <- DT::renderDataTable({
    refs = about_savings[["about_refs"]]
    
    DT::datatable(
      data.frame(
        src = refs$source,
        ref = paste0(
          "<a href='",
          refs$website,
          "' target='_blank'>",
          refs$name,
          "</a>"
        )
      ),
      options = c(g_DT_options,  list(dom = 't', bSort = FALSE)),
      rownames = FALSE,
      colnames = "",
      escape = FALSE
    )
  })
  
  
  output$earnCryptoData <- DT::renderDataTable({
    DT::datatable(
      g_crypto_earn_data,
      # caption = makeCurrencyNetwork(cur),
      options = c(g_DT_options,  list(dom = 't', bSort = FALSE)),
      rownames = FALSE,
      colnames = "",
      escape = FALSE
    )
  })
  
  
  output$referralRef <- renderUI({
    req(input$platform)
    pltf = input$platform
    
    ref = platform_refs[platform == pltf,]$referral_ref
    text = paste("Explore", pltf)
    return(tagList(h6(em(
      a(text, href = ref, target = "_blank")
    ))))
  })
  
  
  output$currencyRef <- renderUI({
    req(input$ticker)
    cur = input$ticker
    
    ref = currencies[currency == cur,]
    website = ref$website
    network = ref$network
    text = paste0("Explore ", network, " (", cur, ")")
    return(tagList(h6(em(
      a(text, href = website, target = "_blank")
    ))))
  })
  
  
  output$disclaimers <- renderTable({
    req(input$platform, input$ticker)
    pltf = input$platform
    cur = input$ticker
    
    cur_row = platform_penalties[platform == pltf &
                                   currency == cur,]
    if (nrow(cur_row) > 0) {
      limit = cur_row$limit
      one_free = cur_row$one_free
      note = cur_row$note
      caption_notes = makeDisclaimers(cur, limit, one_free, note)
      data.frame(caption_notes)
    } else
      data.frame()
  }, colnames = FALSE)
  
  
  output$investmentPlot <- renderPlot({
    req(input$platform,
        input$ticker,
        input$months,
        input$upperRange)
    pltf = input$platform
    cur = input$ticker
    months = input$months
    upperRange = input$upperRange
    
    range_multiplyer = 2
    x_step_freq = 100
    
    cur_row = platform_penalties[platform == pltf &
                                   currency == cur,]
    
    # check that currency is valid for platform
    if (nrow(cur_row) == 0)
      return(NULL)
    
    limit = cur_row$limit
    one_free = cur_row$one_free
    note = cur_row$note
    caption_notes = makeDisclaimers(cur, limit, one_free, note)
    caption_text = paste(caption_notes, collapse = '\n')
    
    values = platform_rates[platform == pltf &
                              currency == cur, amount_lower]
    rates = platform_rates[platform == pltf & currency == cur, apy]
    fee = platform_penalties[platform == pltf &
                               currency == cur, fee]
    fee = ifelse(is.na(fee), 0, fee)
    
    x_start = 0
    # if only one rate then compute range using fee
    x_stop = max(ifelse(length(values) > 1,
                        values[length(values)] * range_multiplyer,
                        fee  * 100),
                 upperRange)
    x_step = (x_stop - x_start) / x_step_freq
    
    x = seq(x_start, x_stop, x_step)
    y = sapply(x, computeReturn, pltf, cur, months) - x - fee

    r = factor(sapply(x, function(v, bfr)
      bfr[v < amount_upper & v >= amount_lower, ]$apy,
      platform_rates[platform == pltf &
                       currency == cur,]),
      labels = rev(paste0(platform_rates[platform == pltf &
                                           currency == cur,]$apy, "%")))
    
    neg_return_threshold = ifelse(which(y >= 0)[[1]], x[[which(y >= 0)[[1]]]], max(x))
    vlines = c(
      if (length(values) > 1)
        sapply(values[2:length(values)], function(xint, lt, c, s)
          geom_vline(
            xintercept = xint,
            linetype = "dotted",
            color = "black",
            size = 0.6
          )),
      geom_vline(
        xintercept = neg_return_threshold,
        linetype = "dotted",
        color = "red",
        size = 0.6
      ),
      geom_hline(
        yintercept = 0.0,
        linetype = "dotted",
        color = "red"
      )
    )
    
    df = data.frame(x = x, y = y)
    color = cut(y, c(-Inf, 0, Inf), labels = c("red", "green"))
    
    p = ggplot(data = df, aes(x, y, color = color)) +
      geom_point(aes(shape = r, group = 1)) +
      vlines +
      # scale_x_continuous(breaks = c(pretty(df$x), neg_return_threshold, values[2:length(values)])) +
      scale_x_continuous(breaks = c(neg_return_threshold, values[2:length(values)], x_stop)) +
      scale_color_manual(values = c("red", "darkgreen"),
                         labels = c("loss", "gain")) +
      scale_shape_manual(values = c(3, 1, 6, 7, 8, 9)) +
      labs(
        title = paste0(
          pltf,
          " Compound Returns¹ for ",
          cur,
          ifelse(!is.na(limit), "²", ""),
          " after ",
          months,
          " Months"
        ),
        subtitle = paste(
          "Break even deposit = ",
          neg_return_threshold,
          cur,
          "due to withdrawal fee = ",
          fee,
          cur
        ),
        x = paste("Deposit,", cur),
        y = paste("Compound Interest,", cur),
        shape = 'APY',
        color = 'Worth It?',
        caption = caption_text
      ) +
      theme_tufte(ticks = FALSE, base_size = 16) +
      theme(
        legend.position = "right",
        plot.caption = element_text(color = "black",face = "italic",size = 10)
      )
    
    return(p)
  })
  
  
  output$compareAPYsAndReturnsPlot <- renderPlot({
    req(input$ticker, input$months, input$upperRange)
    cur = input$ticker
    cur_network = makeCurrencyNetwork(cur)
    months = input$months
    amount = input$upperRange
    
    df = makeAPYReturnForCurrency(cur, amount, months)
    
    caption_notes = makeDisclaimers(cur, NA, NA, NA)
    caption_text = paste(caption_notes, collapse = '\n')
    
    p = ggplot(data = df, aes(platform, value, fill = platform)) +
      geom_bar(stat = 'identity') +
      facet_wrap( ~ cat, scales = "free_y", nrow = 2) +
      scale_fill_manual(palette = tableau_color_pal(palette = getTableauPalette(length(
        unique(df$platform)
      )))) +
      labs(
        title = paste(cur_network, "Compound Returns¹ and APY's by Platform"),
        subtitle = paste("Interest earned on",amount,cur,"after",months,"months"),
        x = NULL,
        y = NULL,
        caption = caption_text
      ) +
      theme_tufte(ticks = FALSE, base_size = 16) +
      theme(
        legend.position = "none",
        plot.caption = element_text(color = "black", face = "italic", size = 10)
      )
    
    return(p)
  })
  
  output$compareAPYsPlot <- renderPlot({
    req(input$ticker, input$months, input$upperRange)
    cur = input$ticker
    cur_network = makeCurrencyNetwork(cur)
    months = input$months
    amount = input$upperRange
    
    df = makeAPYReturnForCurrency(cur, amount, months)
    df = df[cat == "APY" ,]
    
    caption_notes = makeDisclaimers(cur, NA, NA, NA)
    caption_text = paste(caption_notes, collapse = '\n')
    
    p = ggplot(data = df, aes(platform, value, fill = platform)) +
      geom_bar(stat = 'identity') +
      scale_y_continuous(labels = percent) +
      scale_fill_manual(palette = tableau_color_pal(palette = getTableauPalette(length(
        unique(df$platform)
      )))) +
      labs(
        title = paste(cur_network, "Compound APY's by Platform"),
        subtitle = paste("Earnings on",amount,cur,"after",months,"months"),
        x = NULL,
        y = "APY",
        caption = caption_text
      ) +
      theme_tufte(ticks = FALSE, base_size = 18) +
      theme(
        legend.position = "none",
        plot.caption = element_text(color = "black", face = "italic", size = 10)
      )
    
    return(p)
  })
  
  
  output$compareReturnsPlot <- renderPlot({
    req(input$ticker, input$months, input$upperRange)
    cur = input$ticker
    cur_network = makeCurrencyNetwork(cur)
    months = input$months
    amount = input$upperRange
    
    df = makeAPYReturnForCurrency(cur, amount, months)
    df = df[cat == "Earnings" ,]
    
    caption_notes = makeDisclaimers(cur, NA, NA, NA)
    caption_text = paste(caption_notes, collapse = '\n')
    
    p = ggplot(data = df, aes(platform, value, fill = platform)) +
      geom_bar(stat = 'identity') +
      #scale_y_continuous(labels = percent) +
      scale_fill_manual(palette = tableau_color_pal(palette = getTableauPalette(length(
        unique(df$platform)
      )))) +
      labs(
        title = paste(cur_network, "Compound APY's by Platform"),
        subtitle = paste("APY promised on",amount,cur),
        x = NULL,
        y = paste0("Earnings (",cur,")"),
        caption = caption_text
      ) +
      theme_tufte(ticks = FALSE, base_size = 18) +
      theme(
        legend.position = "none",
        plot.caption = element_text(color = "black", face = "italic", size = 10)
      )
    
    return(p)
  })
  
  
  output$compareReturnsCoinsPlot <- renderPlot({
    req(input$platform)
    pltf = input$platform
    
    df = platform_rates[platform == pltf,]
    df = df[df[, .I[apy == max(apy)], by = currency]$V1]
    
    caption_notes = makeDisclaimers(NA, NA, NA, NA)
    caption_text = paste(caption_notes, collapse = '\n')
    
    p = ggplot(data = df, aes(reorder(currency,-apy), apy / 100, fill =
                                currency)) +
      geom_bar(stat = 'identity') +
      scale_y_continuous(labels = scales::percent) +
      scale_fill_manual(palette = tableau_color_pal(palette = getTableauPalette(length(
        unique(df$currency)
      )))) +
      labs(
        title = paste(pltf, "APY's by Assets"),
        # subtitle = paste0("Interest earned on ",amount," ",cur," after ",months," months"),
        x = NULL,
        y = NULL,
        caption = caption_text
      ) +
      theme_tufte(ticks = FALSE, base_size = 16) +
      theme(
        legend.position = "none",
        plot.caption = element_text(
          color = "black",
          face = "italic",
          size = 10
        )
      )
    
    return(p)
    
  })
}





# TODO - image rendering
# HTML('<img src="smiley.gif" alt="Smiley face" height="42" width="42">')


# Run the application
shinyApp(ui = ui, server = server)
