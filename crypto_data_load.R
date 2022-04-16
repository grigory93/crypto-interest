library(data.table)


# Global About Crypto Savings references and info
crypto_savings_refs = transpose(data.table(
  make.names = c("source", "name", "website"),
  Yahoo = c(
    "Yahoo",
    "Here's Everything You Need to Know About Interest-Earning Crypto Accounts",
    "https://www.yahoo.com/video/heres-everything-know-interest-earning-120658712.html"
  ),
  Forbes = c(
    "Forbes",
    "Cryptocurrency Savings Accounts: Will This New Trend Help You Boost Earnings?",
    "https://www.forbes.com/sites/robertfarrington/2020/11/02/cryptocurrency-savings-accounts-will-this-new-trend-help-you-boost-earnings/"
  ),
  Nerdwallet = c(
    "Nerdwallet",
    "What Is a Crypto Interest Account?",
    "https://www.nerdwallet.com/article/banking/crypto-interest-account"
  ),
  Acorns = c(
    "Acorns",
    "Here’s what you need to know before opening crypto interest account",
    "https://grow.acorns.com/interest-earning-crypto-saving-account-risks/"
  )
),
make.names = "make.names")


g_crypto_savings_explainer = list(header=c("Cryptocurrency are not just offering outlandish returns (or losses) but also the yield akin to money savings accounts. 
There are more than a few platforms that offer high returns on accounts with deposited crypto assets.",
                                           "The premise of an interest-earning crypto account is the same as a regular savings account: you deposit your Bitcoin, altcoin, or stablecoin and earn compound interest on your assets.",
                                           "The difference is that the rate of return is significantly higher compared to traditional savings account rates."),
                                  how_it_works=c("",
                                                 "The rate of return is significantly higher compared to traditional savings account rates.",
                                                 "The interest is driven by market effects and is paid out in cryptocurrency.",
                                                 "Platforms can offer high interest because they lend your crypto assets to individuals, corporations or institutions that use it depending on their business functions.",
                                                 "You can also receive weekly payouts to your wallets and withdraw funds anytime (the withdrawal limits and fees differ by platform).",
                                                 "Your platform can offer you high interest because it lends your crypto assets to individuals, corporations or institutions that use it depending on their business functions."),
                                  interest_rates="How much are the interest rates?",
                                  risks=c("Risks. In general, there are 2 main risks you should be wary about: hacks and borrower defaults.",
                                          "Defaults. There's no deposit insurance (a.k.a. FDIC Insurance: up to $250,000 per depositer, per bank, per ownership category).",
                                          "Defaults. Cryptocurrency is decentralized: there’s no single authority that oversees it. When you put your money in a crypto account that’s serviced by a company, the only protection you have is the company’s terms of service.",
                                          "Defaults. Stablecoins are a class of cryptocurrencies, and in theory, a way to avoid extreme cryptocurrency price swings. But their stability is still dependent on the issuer of the coin. That means their value is only as stable as the company backing them.",
                                          "Limitations. Withdrawals aren't always easy or free. For some cryptocurrency savings accounts, your money is a bit more restricted by withdrawl fees and limits (restrictions vary greatly between platforms).",
                                          "Volatility. If you don't pick a stable coin — ones with value is attached to a stable asset like gold or fiat currency — and instead pick Bitcoin, Ethereum or another altcoin, then your balance and interest payments can heavily fluctuate based on the market.",
                                          "Hacks. Platforms that have a weak safety infrastructure are prone to hacking: weak encryption, hot wallets, breach riks.",
                                          "Hacks. Strong safety includes: 2-phase authentication, identity validation, whitelisting crypto accounts, multiparty computation wallets, "),
                                  whos_for=c("Who is it ideal for?",
                                             "As with crypto generally, only invest what you’re willing to lose.",
                                             "Assets in a cryptocurrency interest-earning account are an investment and need to be treated that way, rather than as savings.",
                                             "For crypto owners who want to hold their assets for the long term, interest-earning accounts offer a sweet reward for patience.",
                                             "Cryptocurrency investments are a great way to diversify your portfolio.",
                                             "Keep your crypto investments to a small slice of your portfolio... ”[It’s] a high-risk, high-reward investment ... and you should never invest any money in cryptocurrency that you are not willing to lose.”"),
                                  about_refs = crypto_savings_refs
                                )


# Global lookup table of currencies (coins)
g_stable_coint_top_value = 50000.
g_currencies = rbindlist(list(
  list(currency='USDT',
       network='Tether',
       desc='Tether (USDT) is an Ethereum token that is pegged to the value of a U.S. dollar (also known as a stablecoin). Tether’s issuer claims that USDT is backed by bank reserves and loans which match or exceed the value of USDT in circulation',
       max_value=g_stable_coint_top_value,
       whitepaper="https://tether.to/wp-content/uploads/2016/06/TetherWhitePaper.pdf",
       website="https://tether.to/",
       type="stablecoin"),
  list(currency='USDC',
       network='USD Coin',
       desc='A new class of cryptocurrencies called “stablecoins” have their price fixed to a reserve asset (often the US dollar) at a one-to-one ratio. USDC, as its name would suggest, is one such dollar-pegged cryptocurrency. Each USDC is backed by dollar denominated assets held in segregated accounts with US regulated financial institutions. Its goal is to make crypto payments via the blockchain more reliable by reducing price fluctuations.',
       max_value=g_stable_coint_top_value,
       whitepaper="https://f.hubspotusercontent30.net/hubfs/9304636/PDF/centre-whitepaper.pdf",
       website="https://www.centre.io/usdc", # https://www.circle.com/en/usdc https://www.coinbase.com/usdc/
       type="stablecoin"), 
  list(currency='PAX',
       network='Paxos Standard',
       desc='The Paxos Standard Token is a stablecoin running on Ethereum. For stablecoins like PAX, the company behind the protocol is responsible for holding reserves that fully back each token. The company behind PAX, Paxos Trust Company, claims to hold reserves that fully back each PAX.',
       max_value=g_stable_coint_top_value,
       whitepaper="https://standard.paxos.com/whitepaper.pdf",
       website="https://paxos.com/standard",
       type="stablecoin"),
  list(currency='BUSD',
       network='Binance USD',
       desc='BUSD is a stablecoin founded by Paxos and Binance. Paxos uses blockchain technology to offer their Stablecoin as a Service product to external companies. In the past, they also created a gold-backed stablecoin called PAX Gold (PAXG). The New York State Department of Financial Services regulates both BUSD and PAXG tokens.',
       max_value=g_stable_coint_top_value,
       whitepaper="https://www.binance.com/en/blog/futures/busd-all-you-need-to-know-about-the-stablecoin-421499824684903051",
       website="https://www.binance.com/en/busd",
       type="stablecoin"),
  list(currency='DAI',
       network='Dai',
       desc='Dai (DAI) is a decentralized stablecoin running on Ethereum (ETH) that attempts to maintain a value of $1.00 USD. Unlike centralized stablecoins, Dai isn\'t backed by US dollars in a bank account. Instead, it\'s backed by collateral on the Maker platform. Note: if the Dai credit system is upgraded or shutdown, Dai holders may need to convert their Dai to Ethereum through the Maker platform.',
       max_value=g_stable_coint_top_value,
       whitepaper="https://makerdao.com/whitepaper/",
       website="https://makerdao.com/",
       type="stablecoin"),
  list(currency='GUSD',
       network='Gemini Dollar',
       desc='The Gemini Dollar is a stablecoin running on Ethereum that attempts to maintain a value of US$1.00. The supply of GUSD is collateralized by US dollars held at State Street Bank. Users can buy and redeem GUSD through the Gemini cryptocurrency exchange.',
       max_value=g_stable_coint_top_value,
       whitepaper="https://www.gemini.com/static/dollar/gemini-dollar-whitepaper.pdf",
       website="https://www.gemini.com/dollar",
       type="stablecoin"),
  list(currency='UST',
       network='TerraUSD',
       desc='TerraUSD is a decentralized stablecoin running on Ethereum that attempts to maintain a value of US$1.00. Unlike centralized stablecoins, UST isn’t backed by US dollars in a bank account. Instead, in order to mint 1 TerraUSD, US$1.00 worth of TerraUSD’s reserve asset (LUNA) must be burned.',
       max_value=g_stable_coint_top_value,
       whitepaper="https://www.terra.money/Terra_White_paper.pdf",
       website="https://www.terra.money/",
       type="stablecoin"),
  list(currency='TUSD',
       network='TrueUSD',
       desc='TrueUSD is a stablecoin running on Ethereum that attempts to maintain a value of US$1.00. The supply of TUSD is collateralized by US dollars held in escrow by banks. Tokens can be purchased and redeemed for US dollars on the TrustToken website.',
       max_value=g_stable_coint_top_value,
       whitepaper="https://www.globenewswire.com/news-release/2021/06/18/2249389/0/en/TrueUSD-Integrates-with-Signature-Bank-s-Blockchain-based-Payments-Platform-Signet.html",
       website="https://trueusd.com/",
       type="stablecoin"),
  list(currency='PAXG',
       network='PAX Gold',
       desc='PAX Gold (PAXG) is a commodity-backed, gold stablecoin issued by Paxos.',
       max_value=10.,
       whitepaper="https://www.paxos.com/wp-content/uploads/2019/09/PAX-Gold-Whitepaper.pdf",
       website="https://www.paxos.com/paxgold/",
       type="stablecoin"),
  list(currency='BTC',
       network='Bitcoin',
       desc='Bitcoin is the world’s first widely-adopted cryptocurrency. With Bitcoin, people can securely and directly send each other digital money on the internet.',
       max_value=0.5,
       whitepaper="https://bitcoin.org/bitcoin.pdf",
       website="https://bitcoin.org/",
       type="currency"),
  list(currency='ETH',
       network='Ethereum',
       desc='Ethereum is the second-biggest cryptocurrency by market cap after Bitcoin. It is also a decentralized computing platform that can run a wide variety of applications — including the entire universe of DeFi.',
       max_value=10.,
       whitepaper="https://github.com/ethereum/wiki/wiki/White-Paper",
       website="https://ethereum.org/",
       type="smart contract"),
  list(currency='LTC',
       network='Litecoin',
       desc='Litecoin is one of the first cryptocurrencies. It was created as a fork of Bitcoin and offers faster transaction times and lower costs.',
       max_value=150.,
       whitepaper="https://bitcoin.org/bitcoin.pdf",
       website="https://litecoin.org/",
       type="currency"),
  list(currency='LINK',
       network='Chainlink',
       desc='Chainlink is a decentralized oracle network that is powered by the LINK Ethereum token.',
       max_value=750.,
       whitepaper="https://link.smartcontract.com/whitepaper",
       website="https://chain.link/",
       type="smart contract"),
  list(currency='UNI',
       network='Uniswap',
       desc='Uniswap was one of the first decentralized finance (or DeFi) applications to gain significant traction on Ethereum. Uniswap allows users anywhere in the world to trade crypto without an intermediary (but doesn’t allow for crypto-fiat trades, or vice versa). Users can also become liquidity pool providers, supplying a pair of two cryptocurrencies in order to receive rewards whenever anyone utilizes that pool.',
       max_value=1500.,
       whitepaper="https://uniswap.org/whitepaper.pdf",
       website="https://uniswap.org/",
       type="smart contract"),
  list(currency='BAT',
       network='Basic Attention Token',
       desc='BAT is an Ethereum token that powers Brave Software\'s blockchain-based digital advertising platform. Internet users who browse the web using Brave\'s free web browser (available at Brave.com) can choose to replace the ads they see with ads on Brave\'s ad network. Users then receive BAT from advertisers as compensation for their attention.',
       max_value=20000.,
       whitepaper="https://basicattentiontoken.org/static-assets/documents/BasicAttentionTokenWhitePaper-4.pdf",
       website="https://basicattentiontoken.org/",
       type="smart contract"),
  list(currency='DOT',
       network='Polkadot',
       desc='The Polkadot protocol is designed to allow unrelated blockchains to securely talk to each other, so that value or data can flow between, say, the Ethereum and Bitcoin blockchains without any intermediary. It’s also designed to be speedy and scalable, via the use of many parallel blockchains (or “parachains”) that take much of the processing demand off of the main blockchain. The DOT token is used for staking and governance.',
       max_value=800.,
       whitepaper="https://polkadot.network/PolkaDotPaper.pdf",
       website="https://polkadot.network/",
       type="smart contract"),
  list(currency='ADA',
       network='Cardano',
       desc='Cardano is designed to be a next-gen evolution of the Ethereum idea. It’s intended to be a flexible, sustainable, and scalable platform for running smart contracts, which will allow the development of a wide range of decentralized finance apps, new crypto tokens, games, and more. Cardano is a decentralized public blockchain and cryptocurrency developed in Haskell, a dynamic and mathematically provable programming language. The project is developing a smart contract platform that will provide more advanced capabilities than any previous protocol. Cardano’s cryptocurrency, ADA, is used to transfer and receive digital currency. Cryptographic encryption makes this digital cash the money of the future, enabling fast and secure transactions.',
       max_value=20000.,
       whitepaper="https://www.cardano.org/",
       website="https://docs.cardano.org/en/latest/",
       type="smart contract"),
  list(currency='LUNA',
       network='Terra',
       desc='Terra is a blockchain protocol built on the Tendermint — Cosmos SDK that supports stable programmable payments and open financial infrastructure development. It is supported by a basket of fiat-pegged coins that are stabilized by its native crypto-asset, LUNA.',
       max_value=400.,
       whitepaper="https://www.terra.money/Terra_White_paper.pdf",
       website="https://www.terra.money/",
       type="smart contract"),
  list(currency='ETH2',
       network='Ethereum 2',
       desc='Ethereum 2.0 is an upcoming set of upgrades to Ethereum that\'s intended to make it significantly faster, less expensive, and more scalable. As part of the upgrade, participants may stake ETH tokens to help secure the network. In exchange for staking, participants then receive rewards on their staked ETH. Staked ETH (and rewards) can\'t be unstaked until Ethereum 2.0 fully launches, which most experts estimate will happen between 2022 and 2024. Please note: the price chart and market stats for ETH2 are simply a copy of the ETH price chart and market stats.',
       max_value=10.,
       whitepaper="https://medium.com/@VitalikButerin/a-proof-of-stake-design-philosophy-506585978d51",
       website="https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/",
       type="smart contract"),
  list(currency='XTZ',
       network='Tezos',
       desc='Tezos is a blockchain network and smart contract platform similar to Ethereum. Using Tezos, developers can create decentralized applications (lending apps, decentralized exchange apps, and much more).',
       max_value=10000.,
       whitepaper="https://wiki.tezosagora.org/whitepaper",
       website="https://tezos.com/",
       type="smart contract"),
  list(currency='ATOM',
       network='Cosmos',
       desc='Cosmos aims to be the “internet of blockchains” by allowing developers to build their own blockchains, each of which are interconnected via the Cosmos network. ATOM is the native cryptocurrency, used for staking and securing the “Global Hub,” which connects all of these blockchains.',
       max_value=800.,
       whitepaper="https://v1.cosmos.network/resources/whitepaper",
       website="https://cosmos.network/",
       type="smart contract"),
  list(currency='ALGO',
       network='Algorand',
       desc='Algorand seeks to build on similar projects like Ethereum by improving scalability, security, and reducing the amount of time it takes for transactions on the network to be considered “final.”',
       max_value=50000.,
       whitepaper="https://www.algorand.com/technology/white-papers/",
       website="https://www.algorand.com/",
       type="smart contract"),
  list(currency='DOGE',
       network='Dogecoin',
       desc='For most of its existence, Dogecoin (pronounced “dohj coin”) was considered to be an amusing “memecoin” beloved by its community — but with relatively little value. That changed in 2021, when DOGE became one of the larger cryptocurrencies by market cap — with a total value that has topped $50 billion, even though each individual coin is worth pennies.',
       max_value=200000.,
       whitepaper="https://www.reddit.com/r/dogecoin/comments/7pffe4/the_doge_whitepaper/",
       website="http://dogecoin.com/",
       type="currency"),
  list(currency='BCH',
       network='Bitcoin Cash',
       desc='Bitcoin, in its original conception, was designed to be a form of digital cash people could use to make transactions online. Over time it has evolved into a “store of wealth” more like digital gold. Bitcoin Cash was created to continue the original peer-to-peer cash idea — via a high-volume, low-fee network that would be accessible to anyone with an internet connection.',
       max_value=200000.,
       whitepaper="http://bch.info/bitcoin.pdf",
       website="http://bch.info/",
       type="currency"),
  list(currency='AVAX',
       network='Avalanche',
       desc='Avalanche describes itself as an “open, programmable smart contracts platform for decentralized applications.” What does that mean? Like many other decentralized protocols, Avalanche has its own token called AVAX, which is used to pay transaction fees and can be staked to secure the network.',
       max_value=300.,
       whitepaper="https://www.avalabs.org/whitepapers",
       website="https://www.avax.network/",
       type="smart contract"),
  list(currency='SOL',
       network='Solana',
       desc='Solana is one of a number of newer cryptocurrencies designed to compete with Ethereum. Like Ethereum, Solana is both a cryptocurrency and a flexible platform for running crypto apps — everything from NFT projects like Degenerate Apes to the Serum decentralized exchange (or DEX). However, it can process transactions much faster than Ethereum — around 50,000 transactions per second. SOL is used to pay transaction fees and for staking. It also serves as a “governance token,” meaning that holders also are able to vote on future upgrades and governance proposals that are submitted by the Solana community.',
       max_value=300.,
       whitepaper="https://solana.com/solana-whitepaper.pdf",
       website="https://solana.com/",
       type="smart contract"),
  list(currency='$',
       network='US Dollar',
       desc='United States Federal Reserve fiat currency.',
       max_value=20000.,
       whitepaper="https://www.federalreserve.gov/publications/money-and-payments-discussion-paper.htm",
       website="https://www.usmint.gov/",
       type="currency")
))


# empty data
getEmptyData <- function() {
  
  return(list(rates = data.table(platform = character(0),
                                 currency = character(0),
                                 amount_lower = numeric(0),
                                 amount_upper = numeric(0),
                                 apy = numeric(0),
                                 network = character(0),
                                 type = character(0)),
              penalties = data.table(platform = character(0),
                                     currency = character(0),
                                     limit = numeric(0),
                                     fee = numeric(0),
                                     one_free = logical(0),
                                     term = character(0),
                                     note = character(0),
                                     period = character(0)),
              refs = data.table(platform = character(0),
                                rate_ref = character(0),
                                fee_ref = character(0), 
                                referral_ref = character(0),
                                referral_text = character(0),
                                about_ref = character(0),
                                about_text = character(0),
                                logo = character(0),
                                more_info = list())))
}


g_refs = rbindlist(list(
  list(platform="BlockFi",
       rate_ref="https://blockfi.com/rates/",
       fee_ref="https://blockfi.com/fees/",
       referral_ref="https://blockfi.com/?ref=ba91219a",
       referral_text="Earn free $40 in Bitcoin when you open BlockFi Account",
       about_ref="",
       about_text="",
       logo="https://s2-recruiting.cdn.greenhouse.io/external_greenhouse_job_boards/logos/400/699/300/resized/BlockFi_Logo_2020_BlockFi-2020-Full-Color-1200x628.png",
       more_info=list()),
  list(platform="Crypto.com",
       rate_ref="https://crypto.com/us/earn",
       fee_ref="https://crypto.com/exchange/document/fees-limits",
       referral_ref="https://platinum.crypto.com/r/ytzc5pkeun",
       referral_text="Get $25 USD when you sign-up for Crypto.com account",
       about_ref="",
       about_text="",
       logo="https://logos-download.com/wp-content/uploads/2021/02/Crypto.com_Logo.png",
       more_info=list("The fees apply to withdrawals using native network or ERC20 network (when applicable).")),
  list(platform="Celsius",
       rate_ref="https://celsius.network/rates",
       fee_ref=NA,
       referral_ref="https://celsiusnetwork.app.link/1140759ba6",
       referral_text="Earn free $50 in Bitcoin with Celsius",
       about_ref="",
       about_text="",
       logo="https://mma.prnewswire.com/media/1504869/Celsius_Logo.jpg?w=200",
       more_info=list()),
  list(platform="Gemini",
       rate_ref="https://www.gemini.com/earn",
       fee_ref=NA,
       referral_ref="https://www.gemini.com/share/77qe6nafp",
       referral_text="Get $10 in free Bitcoin when you open account on Gemini and trade $100",
       about_ref="",
       about_text="",
       logo="https://mma.prnewswire.com/media/930231/Gemini___Logo.jpg?w=200",
       more_info=list()),
  list(platform="Coinbase",
       rate_ref="https://www.coinbase.com/staking",
       fee_ref="https://help.coinbase.com/en/coinbase/trading-and-funding/pricing-and-fees/fees",
       referral_ref="https://www.coinbase.com/join/kanevs_67",
       referral_text="Get $10 in free Bitcoin when you buy or sell $100 or more in crypto on Coinbase",
       about_ref="https://help.coinbase.com/en/coinbase/getting-started/crypto-education/what-is-coinbase",
       about_text="Coinbase is a secure online platform for buying, selling, transferring, and storing digital currency. Our mission is to create an open financial system for the world and to be the leading global brand for helping people convert digital currency into and out of their local currency.",
       logo="https://mma.prnewswire.com/media/1660649/Coinbase_Logo.jpg?w=200",
       more_info=list()),
  list(platform="Nexo",
       rate_ref="https://nexo.io/blog/a-new-yield-program-is-coming-to-our-earn-interest-suite-in-december",
       fee_ref=NA,
       referral_ref="",
       referral_text="",
       about_ref="",
       about_text="",
       logo=NA,
       more_info=list("up to 5 free crypto withdrawals per month")),
  list(platform="Vauld",
       rate_ref="https://www.vauld.com/rates",
       fee_ref="https://www.vauld.com/rates",
       referral_ref="",
       referral_text="",
       about_ref="",
       about_text="",
       logo=NA,
       more_info=list())
))


makePlatformData <- function(platform, rates, penalties) {
  pltf = platform
  
  if(!"platform" %in% names(rates))
    rates = cbind(data.table(platform=pltf), rates)
  
  if(!"network" %in% names(rates)) {
    before_rowcount = nrow(rates)
    before_currencies = unique(rates$currency)
    rates = rates[g_currencies[, c('currency', 'network', 'type')], on=.(currency), nomatch=NULL]
    if (before_rowcount != nrow(rates)) 
      stop(sprintf("Currency join failed for %s due to missing currency: %s", 
                   pltf, setdiff(before_currencies, unique(rates$currency))))
  }
  
  if(!"platform" %in% names(penalties))
    penalties = cbind(data.table(platform=pltf), penalties)
  
  return(list(rates = rates, penalties=penalties, 
              refs=g_refs[platform==pltf,]))
}


# BlockFi data
# [BlockFi web site](https://blockfi.com/rates/) and 
# [BlockFi Fees](https://blockfi.com/fees/):
getBlockFiData <- function(platform = "BlockFi") {
  
  pltf = platform
  
  blockfi_data = transpose(data.table(
    make.names = c("currency", "amount_upper", "apy", "fee", "limit", "one_free", "note"),
    BTC1 =        c('BTC', 0.1,  4.0,  0.00075, 100, TRUE, NA),
    BTC2 =        c('BTC', 0.35, 1.,   0.00075, 100, TRUE, NA),
    BTC3 =        c('BTC', Inf,  .1,   0.00075, 100, TRUE, NA),
    
    ETH1 =        c('ETH', 1.5,  4.,   0.015,   5000, FALSE, NA),
    ETH2 =        c('ETH', 5.,   1.5,  0.015,   5000, FALSE, NA),
    ETH3 =        c('ETH', Inf,  .25,  0.015,   5000, FALSE, NA),
    
    LTC1 =        c('LTC', 20,   3.5,  0.001,   10000, TRUE, NA),
    LTC2 =        c('LTC', 100,  1.,   0.001,   10000, TRUE, NA),
    LTC3 =        c('LTC', Inf,  .1,   0.001,   10000, TRUE, NA),
    
    UNI1 =        c('UNI', 100,  3.25, 2.5,     5500, FALSE, NA),
    UNI2 =        c('UNI', 500,  .2,   2.5,     5500, FALSE, NA),
    UNI3 =        c('UNI', Inf,  .1,   2.5,     5500, FALSE, NA),
    
    LINK1 =       c('LINK', 100, 2.5,  2,       65000, FALSE, NA),
    LINK2 =       c('LINK', 500, .2,   2,       65000, FALSE, NA),
    LINK3 =       c('LINK', Inf, .1,   2,       65000, FALSE, NA),
    
    DOGE =        c('DOGE', Inf, 2.,   0,       0., FALSE, "No external transfers. You can buy, sell and trade it, but transfers into and out of BlockFi aren’t supported. Convert to another crypto to withdraw."),
    ALGO =        c('ALGO', Inf, 2.5,  0.,      0., FALSE, "No external transfers. You can buy, sell and trade it, but transfers into and out of BlockFi aren’t supported. Convert to another crypto to withdraw."),
    BCH =         c('BCH', Inf,  4.5,  0.,      0., FALSE, "No external transfers. You can buy, sell and trade it, but transfers into and out of BlockFi aren’t supported. Convert to another crypto to withdraw."),
    
    BAT1 =        c('BAT', 4000, 1.,   60.,     2000000., FALSE, NA),
    BAT2 =        c('BAT', 20000,.2,   60.,     2000000., FALSE, NA),
    BAT3 =        c('BAT', Inf,  .1,   60.,     2000000., FALSE, NA),
    
    PAXG1 =       c('PAXG', 1.5, 3.25, 0.035,   500, FALSE, NA),
    PAXG2 =       c('PAXG', 5,   .2,   0.035,   500, FALSE, NA),
    PAXG3 =       c('PAXG', Inf, .1,   0.035,   500, FALSE, NA)),
    make.names = "make.names")
  changeCols = c("amount_upper", "apy", "fee", "limit")
  blockfi_data[, (changeCols) := lapply(.SD, as.numeric), .SDcols = changeCols]
  blockfi_data[, one_free := as.logical(one_free)]
  blockfi_stable_rates = data.table(amount_upper = c(20000, 5000000, Inf),
                                    apy = c(7.25, 6., 4.5),
                                    fee = 50.,
                                    limit = 1000000.,
                                    one_free = TRUE,
                                    note = NA)
  blockfi_stable_data = rbindlist(lapply(c('USDC', 'GUSD', 'PAX', 'BUSD', 'DAI', 'USDT'),
                                         cbind, blockfi_stable_rates)) 
  blockfi_data = rbindlist(list(blockfi_data, blockfi_stable_data), use.names = FALSE)
  blockfi_data[, amount_lower := shift(amount_upper, 1, fill=0), by=currency]
  
  blockfi_rates = cbind(data.table(platform=pltf),
                        blockfi_data[, c('currency', 'amount_lower', 'amount_upper', 'apy')])
  
  blockfie_penalities_data = blockfi_data[, .SD[1, c('limit', 'fee', 'one_free', 'note')], by=currency]
  blockfie_penalities_data[, `:=` (term = NA, period = "7-day")]
  blockfie_penalities_data[currency=='USDT', note:="USDT is only available to non-US retail clients."]
  blockfi_penalties = cbind(data.table(platform=pltf),
                            blockfie_penalities_data[, c('currency', 'limit', 'fee', 'one_free', 
                                                         'term', 'note', 'period')])
  
  return(makePlatformData(platform, blockfi_rates, blockfi_penalties))
}

# Crypto.com data
# Interest: https://crypto.com/us/earn (term 3 months, CRO stake $400 or less)
# Fees: https://crypto.com/exchange/document/fees-limits
# Rates on Crypto.com assuming $0 CRO Stake and 3-month Term
getCryptoComData <- function(platform = "Crypto.com") {
  
  pltf = platform
  
  cryptocom_data = transpose(data.table(
      make.names = c("currency", "amount_upper", "apy", "fee"),
      BTC =        c('BTC', Inf, 4.5, 0.0005),
      ETH =        c('ETH', Inf, 5.5, 0.005),
      LTC =        c('LTC', Inf, 2., 0.001),
      BCH = c('BCH', Inf, 2., 0.001 ),
      LINK = c('LINK', Inf, 2., 1.5),
      PAXG = c('PAXG', Inf, 2., 0.007 ),
      UNI = c('UNI', Inf, 2., 1.),
      BAT = c('BAT', Inf, 2., 14.),
      DOT = c('DOT', Inf, 10., 0.1),
      ADA = c('ADA', Inf, 2., 0.5),
      LUNA = c('LUNA', Inf, 2., 0.0015),
      SOL = c('SOL', Inf, 3., 0.0005),
      USDT = c('USDT', Inf, 10., 25.),
      USDC = c('USDC', Inf, 10., 25.),
      PAX = c('PAX', Inf, 10., 25.),
      BUSD = c('BUSD', Inf, 2., 100.),
      DAI = c('DAI', Inf, 10., 27.),
      TUSD = c('TUSD', Inf, 10., 0.),
      AVAX = c('AVAX', Inf, 4., 0.005),
      DOGE = c('DOGE', Inf, 2., 6.),
      ALGO = c('ALGO', Inf, 2., 0.5)),
    make.names = "make.names")
  changeCols = c("amount_upper", "apy", "fee")
  cryptocom_data[, (changeCols):= lapply(.SD, as.numeric), .SDcols = changeCols]
  cryptocom_data[, amount_lower := shift(amount_upper, 1, fill=0), by=currency]
  
  cryptocom_rates = cbind(data.table(platform=pltf), 
                          cryptocom_data[, c('currency', 'amount_lower', 'amount_upper', 'apy')])
  
  cryptocom_penalties = data.table(platform=pltf,
                                   currency=cryptocom_data$currency,
                                   limit=NA,
                                   fee=cryptocom_data$fee,
                                   one_free=NA,
                                   term="3 Months",
                                   note=NA,
                                   period=NA)
  
  return(makePlatformData(platform, cryptocom_rates, cryptocom_penalties))
}


# Celsius data
# https://celsius.network/rates
getCelsiusData <- function(platform = "Celsius") {
  
  pltf = platform
  
  celsius_data = transpose(data.table(
    make.names = c("currency", "amount_upper", "apy"),
    BTC1 =        c('BTC', 1., 5.),
    BTC2 =        c('BTC', Inf, 1.5),
    
    ETH1 =        c('ETH', 30, 5.35),
    ETH2 =        c('ETH', Inf, 3.52),
    
    BCH =         c('BCH', Inf, 4.51 ),
    LINK =        c('LINK', Inf, 3.),
    PAXG =        c('PAXG', Inf, 5.5),
    UNI =         c('UNI', Inf, 2.5),
    BAT =         c('BAT', Inf, 1.),
    DOT =         c('DOT', Inf, 9.02),
    ADA =         c('ADA', Inf, 4.06),
    LUNA =        c('LUNA', Inf, 6.05),
    SOL =         c('SOL', Inf, 5.5),
    AVAX =        c('AVAX', Inf, 8.3),
    DOGE =        c('DOGE', Inf, .5),
    LTC =         c('LTC', Inf, 1.75),
    XTZ =         c('XTZ', Inf, 4.25)),
    make.names = "make.names")
  changeCols = c("amount_upper", "apy")
  celsius_data[, (changeCols):= lapply(.SD, as.numeric), .SDcols = changeCols]
  
  stablecoin_rates = rbindlist(lapply(c('USDT', 'USDC', 'PAX', 'BUSD', 'GUSD', 'TUSD'), 
                                      cbind, 
                                      data.table(amount_upper = c(Inf),
                                                        apy = c(7.1)))) 
  
  celsius_rates = rbindlist(list(celsius_data,
                                 stablecoin_rates), use.names = FALSE)
  celsius_rates[, amount_lower := shift(amount_upper, 1, fill=0), by=currency]
  setcolorder(celsius_rates, c('currency', 'amount_lower', 'amount_upper', 'apy'))

  celsius_penalties = data.table(currency = unique(celsius_rates$currency),
                                limit = NA,
                                fee = 0.,
                                one_free = NA,
                                term = NA,
                                note = "In-kind Reward Rate (APY)",
                                period=NA)
  
  return(makePlatformData(platform, celsius_rates, celsius_penalties))
}


# Gemini data
# https://exchange.gemini.com/earn
getGeminiData <- function(platform = "Gemini") {
  
  pltf = platform
  
  gemini_data = transpose(data.table(
    make.names = c("currency", "amount_upper", "apy"),
    BTC =        c('BTC', Inf, 1.01),
    ETH =        c('ETH', Inf, 1.26),
    # BCH =        c('BCH', Inf, 5.33 ),
    LINK =       c('LINK', Inf, .5),
    PAXG =       c('PAXG', Inf, .5),
    UNI =        c('UNI', Inf, 1.01),
    BAT =        c('BAT', Inf, 1.01),
    LUNA =       c('LUNA', Inf, 6.11),
    SOL =        c('SOL', Inf, 4.29),
    DOGE =       c('DOGE', Inf, 1.01),
    LTC =        c('LTC', Inf, 1.51),
    XTZ =        c('XTZ', Inf, 2.05),
    GUSD =       c('GUSD', Inf, 6.9),
    DAI =        c('DAI', Inf, 6.43),
    UST =        c('UST', Inf, 6.8),
    USDC =       c('USDC', Inf, 6.36)
  ), make.names = "make.names")
  changeCols = c("amount_upper", "apy")
  gemini_data[, (changeCols):= lapply(.SD, as.numeric), .SDcols = changeCols]
  gemini_data[, amount_lower := shift(amount_upper, 1, fill=0), by=currency]
  setcolorder(gemini_data, c('currency', 'amount_lower', 'amount_upper', 'apy'))
  
  gemini_penalties = data.table(currency = unique(gemini_data$currency),
                                 limit=NA,
                                 fee=0.,
                                 one_free=NA,
                                 term=NA,
                                 note=NA,
                                 period=NA)
  
  return(makePlatformData(platform, gemini_data, gemini_penalties))
}


# Coinbase data
# https://www.coinbase.com/trade/asset-categories/interest_earning
getCoinbaseData <- function(platform = "Coinbase") {
  
  pltf = platform
  
  coinbase_data = transpose(data.table(
    make.names = c("currency", "amount_upper", "apy"),
    ETH2 =       c('ETH2', Inf, 4.5),
    USDC =       c('USDC', Inf, .15),
    DAI =        c('DAI', Inf, .15),
    ATOM =       c('ATOM', Inf, 5.),
    ALGO =       c('ALGO', Inf, .45),
    XTZ =        c('XTZ', Inf, 4.63)
  ), make.names = "make.names")
  changeCols = c("amount_upper", "apy")
  coinbase_data[, (changeCols):= lapply(.SD, as.numeric), .SDcols = changeCols]
  coinbase_data[, amount_lower := shift(amount_upper, 1, fill=0), by=currency]
  setcolorder(coinbase_data, c('currency', 'amount_lower', 'amount_upper', 'apy'))
  
  coinbase_penalties = data.table(currency = unique(coinbase_data$currency),
                                limit = NA,
                                fee = 0.,
                                one_free = NA,
                                term = NA,
                                note = NA,
                                period = NA)
  
  return(makePlatformData(platform, coinbase_data, coinbase_penalties))
}


# Crypto Platforms
g_crypto_platforms <- list(BlockFi=getBlockFiData, 
                           Crypto.com = getCryptoComData, 
                           Celsius = getCelsiusData,
                           Coinbase = getCoinbaseData,
                           Gemini = getGeminiData
                           #, "Voyager", "Nexo", "Vauld", "Kraken"
)


getPlatformData <- function() {
  empties = getEmptyData()
  platform_rates = empties[["rates"]]
  platform_penalties = empties[["penalties"]]
  platform_refs = empties[["refs"]]
  for(p in names(g_crypto_platforms)) {
    data = g_crypto_platforms[[p]]()
    platform_rates = rbind(platform_rates, data[["rates"]])
    platform_penalties = rbind(platform_penalties, data[["penalties"]])
    platform_refs = rbind(platform_refs, data[["refs"]])
  }
  
  return(list(rates=platform_rates, 
              penalties=platform_penalties, 
              refs=platform_refs,
              currencies=g_currencies,
              about=g_crypto_savings_explainer))
}


lookupMaxValueCrypto <- function(coin) {
  if(is.null(coin) || coin=="") currency = 'BTC'
  # result = max_value_lookup_table[[currency]]
  result = g_currencies[currency==coin, ]$max_value
  return(result)
}


