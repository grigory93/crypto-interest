library(memoise)
library(properties)
library(httr)
library(jsonlite)
library(data.table)

# define cache with timeout
cm = cachem::cache_mem(max_age = 5 * 60)

# Using coincap.io Crypto API 2.0
# https://docs.coincap.io/#intro
props = read.properties("config.properties")
coincap_io_API_KEY = props$coincap_io_api_key

load_assets <- function(currencies) {
  if (is.null(currencies)) 
    stop("Loading assets without currency list not possible.")
  
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
  
  coins = coins[symbol %in% currencies$currency]
  currencies = coins[currencies, on=c(symbol="currency_join")]
  currencies[, network := ifelse(is.na(name), network, name)]
  
  return(currencies)
}
m_load_assets = memoise(load_assets, cache = cm)

load_exchanges <- function(platform_refs) {
  if(is.null(platform_refs))
    stop("Loading platforms without platform list not possible.")
  
  resp = GET("https://api.coincap.io/v2/exchanges?limit=2000",
                  add_headers(
                    `Accept-Encoding` = 'gzip`x-rapidapi-host',
                    `Authorization`=paste('Bearer', coincap_io_API_KEY)))
  content = content(resp)[[1]]
  exchanges = rbindlist(content, use.names = TRUE, fill = TRUE)
  changeCols = c("rank", "percentTotalVolume", "volumeUsd", "tradingPairs", "updated")
  exchanges[, (changeCols) := lapply(.SD, as.numeric), .SDcols = changeCols]
  
  platform_refs = exchanges[platform_refs, on="exchangeId"]
  
  return(platform_refs)
}
m_load_exchanges = memoise(load_exchanges, cache = cm)