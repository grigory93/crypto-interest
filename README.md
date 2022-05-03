# crypto-interest

## Overview
R/Shiny web application to analyze crypto savings accounts and platforms. App allows to calculate and compare earnings on crypto holdings, compare platforms by what crypto they support and how much they earn.

## Crypto Platforms

The app tracks interest on a wide range of crypto assets (coins) on major crypto platforms:

 * [BlockFi](www.blockfi.com) [(referral: https://blockfi.com/?ref=ba91219a)](https://blockfi.com/?ref=ba91219a)
 * [Coinbase](www.coinbase.com) (referral: [https://www.coinbase.com/join/kanevs_67])
 * Crypto.com (https://platinum.crypto.com/r/ytzc5pkeun)
 * Gemini (https://www.gemini.com/share/77qe6nafp)
 * Celsius (https://celsiusnetwork.app.link/1140759ba6)
 * AQRU (https://aqru.io?code=NDRXUA)

Some of the platforms above are also crypto exchanges and we publish their metrics such as rankings, trade volumes, number of trade pairs supported, etc.

## Crypto Assets

The web site divides all crypto assets into 3 classes:
 
 * Currencies such as Bitcoin (e.g. BTC, LTC)
 * Stablecoins such as Tether (e.g. USDC, USDT)
 * Smart contracts blockchains (ETH, ADA)

The app collects APYs, fees, terms and compares total returns based on these characteristics across all crypto classes. We support several useful ways to calculate, analyze, and compare such returns between platforms and crypto.


## Functionality

### Visualizations
 * Returns over time: compute earnings on given platform, crypto, term (months), and max. investment calculate returns (compound). This also includes break even investment when return becomes positive (due to fees and limitations)
 * Compare platforms:
   * Compound returns and APY's across all platforms for given crypto
   * APY's across all platforms for given crypto
   * Compound returns across all platforms for given crypto
 * Compare crypto
   * Compare APY's for all supported assets on given platforma
   * Compare market cap for all supported assets on given platform
 * [TODO] Given $$ compare earnings on given platform/crypto

### Explainer
 * Crypto Interest Explainer provides information about
   * About interest earning crypto accounts
   * How interest earning crypto accounts work
   * What are the risks associated with them
   * Who are the ideal customers for them
   * References for more information

### Resources
  * For platforms include about, web site, mission, interest rates, fees, and how to open an account with promotion code; also includes info on rank, percent of volume, volume, and trading pairs if platform is also exchange
  * For crypto include their purpose, web site, white paper, blockchain explorer, up to date trading info like price, change, volume, market cap and supply


## Disclaimers:
  * All APY’s are subject to change. 
  * APY's reflect effective yield based on monthly compounding. 
  * Actual yield will vary based on account activity and compliance with respective platforms’s terms and conditions.
  * The latest APY's may change and may not be reflected in the code and on the web site. So are the rules, fees, and other limitations.
  * The above is for information purposes only. It is not intended to be investment advice.
