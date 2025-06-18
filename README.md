# Correlation Trading Indicator

A correlation-based trading indicator for MetaTrader 4 and MetaTrader 5 that visualizes inter-market relationships. It utilizes the price action of the strongest positively correlated instrument as an indication of potential future trend movements, thereby helping traders make informed decisions.



## 🎯 Features
- **Real-time Correlation Analysis**: Calculates dynamic correlations between currency pairs and financial instruments
- **Multi-Asset Support**: Works with forex, precious metals, cryptocurrencies, and indices
- **Interactive Dashboard**: Live display of correlation strength and trend direction
- **Broker Compatibility**: Handles various symbol naming conventions across different brokers


## 📊 How It Works
The indicator replaces traditional moving averages with the price action of the most correlated instrument:
- **AUD/USD ↔ NZD/USD** (Strong Positive correlation)
- **NZD/USD ↔ AUD/USD** (Strong Positive correlation)
- **EUR/USD ↔ GBP/USD** (Major pair correlation)
- **GBP/USD ↔ EUR/USD** (Major pair correlation)
- **USD/JPY ↔ USD/CHF** (Safe-Haven Pair correlation)
- **USD/CHF ↔ USD/JPY** (Safe-Haven Pair correlation)
- **USDCAD ↔ USDNOK** (Oil-Influenced Currencies)
- **AUD/JPY ↔ NZD/JPY** (Asia-Pacific Yen Crosses)
- **NZD/JPY ↔ AUD/JPY** (Asia-Pacific Yen Crosses)
- **GBPJPY ↔ EUR/JPY** (Major European Yen Crosses)
- **EUR/JPY ↔ GBPJPY** (Major European Yen Crosses)
- **Gold (XAU/USD) ↔ Silver (XAG/USD)** (Precious Metals Pair)
- **Silver (XAG/USD) ↔ Gold (XAU/USD)** (Precious Metals Pair)
- **Bitcoin (BTC/USD) ↔ NASDAQ 100 (NAS100)** (Crypto vs. Tech Index / Risk-On Assets)
- **Ethereum (ETH/USD) ↔ Bitcoin (BTC/USD)** (Altcoin vs. Dominant Crypto)
- **Litecoin (LTC/USD) ↔ Bitcoin (BTC/USD)** (Altcoin vs. Dominant Crypto)


## 📸 Screenshots
![Correlation Indicator1](https://raw.githubusercontent.com/MuhammidKhaled/CorrelationIndicator/refs/heads/main/Images/correlation1.png "Correlation Indicator")
<div align="center">
  The correlation indicator with the default settings on the chart of AUDJPY pair.<br>
</div>
<br>

![Correlation Indicator2](https://raw.githubusercontent.com/MuhammidKhaled/CorrelationIndicator/refs/heads/main/Images/correlation2.png "Correlation Indicator")
<div align="center">
  The correlation indicator with a correlation period of 10 on the chart of ETH/USD pair.
</div>
<br>



## 🔧 Parameters
| **Parameter** | **Default** | **Description** |
|---|---|---|
| Correlation Period | 20 | Number of periods for correlation calculation |
| Indicator Color | Gold | Color of the correlation line |
| ShiftValue | 0 | Horizontal shift of the indicator |


## 📈 Supported Instruments
### Forex Pairs
- Major pairs: EUR/USD, GBP/USD, USD/JPY, USD/CHF
- Commodity pairs: AUD/USD, NZD/USD, USD/CAD
- Cross pairs: AUD/JPY, GBP/JPY, EUR/JPY, NZD/JPY
### Other Assets
- Precious Metals: Gold (XAU/USD), Silver (XAG/USD)
- Cryptocurrencies: Bitcoin, Ethereum, Litecoin


## 📊 Using in Trading Strategy
- **Buy indication**: When correlated pair line crosses above  main pair.
- **Sell indication**: When correlated pair line crosses below main pair.
- **Trend Confirmation**: Use dashboard arrows for trend direction and correlation percentage should be with a positive value.(At the top left of the chart).


## ⚠️ Disclaimer
This indicator is provided for analytical purposes only. It is designed to assist traders in visualizing inter-market relationships and enhancing their market analysis to make more informed trading decisions.It is not intended to provide direct buy or sell signals, nor does it guarantee any specific trading results or profits.


## 🚀 Quick Start
### For MetaTrader 4
1. Download MQL4/Indicators/Correlation.mq4
2. Copy to MetaTrader 4/MQL4/Indicators/
3. Restart MT4 and apply to chart
### For MetaTrader 5
1. Download MQL5/Indicators/Correlation.mq5
2. Copy to MetaTrader 5/MQL5/Indicators/
3. Restart MT5 and apply to chart


## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.


## 📄 License
This project is licensed under the MIT License - see the ([LICENSE](LICENSE)) file for details.

## 🏷️ Version History
- **v1.0.0** - Initial MQL4 release
- **v1.1.0** - MQL5 version (coming soon)

___

⭐ Star this repository if you find it helpful!
