library(httr)
library(jsonlite)
library(data.table)

# Using coincap.io Crypto API 2.0
# https://docs.coincap.io/#intro

coincap_io_desc = 
  "Your Api Key is Ready!
  
  Your key: 937c64d0-02c1-4a4e-b4e3-e4c8c3ffdbb4
Expires on 4/16/2033"
coincap_io_API_KEY = "937c64d0-02c1-4a4e-b4e3-e4c8c3ffdbb4"

load_assets <- function() {
  resp = GET("https://api.coincap.io/v2/assets?limit=2000",
               add_headers(
                 `Accept-Encoding` = 'gzip`x-rapidapi-host',
                 `Authorization`=paste('Bearer', coincap_io_API_KEY)))
  content = content(resp)[[1]]
  coins = rbindlist(content, use.names = TRUE, fill = TRUE)
  # remove exception entry for Luna Coin that contains duplicate symbol LUNA
  coins = coins[id!='luna-coin',]
  changeCols = c("rank", "supply", "maxSupply", "marketCapUsd", "volumeUsd24Hr", "priceUsd", "changePercent24Hr", "vwap24Hr")
  coins[, (changeCols) := lapply(.SD, as.numeric), .SDcols = changeCols]
  return(coins)
}


load_exchanges <- function() {
  resp = GET("https://api.coincap.io/v2/exchanges?limit=2000",
                  add_headers(
                    `Accept-Encoding` = 'gzip`x-rapidapi-host',
                    `Authorization`=paste('Bearer', coincap_io_API_KEY)))
  content = content(resp)[[1]]
  exchanges = rbindlist(content, use.names = TRUE, fill = TRUE)
  changeCols = c("rank", "percentTotalVolume", "volumeUsd", "tradingPairs", "updated")
  exchanges[, (changeCols) := lapply(.SD, as.numeric), .SDcols = changeCols]
  return(exchanges)
}

