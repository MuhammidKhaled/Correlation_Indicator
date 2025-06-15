//+------------------------------------------------------------------+
//|                                                  Correlation.mq4 |
//|                    (c) 2025 Mohamed Khaled - All Rights Reserved |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "© 2025 Mohamed Khaled"
#property link      "https://linkedin.com/in/mohamed-khaled-203577135"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Gold 
#property indicator_width1 1


extern int CorrelationPeriod = 20;       // Period
extern color IndicatorColor = Gold;     // Color
extern int ShiftValue = 0;              // Shift

 
const bool NormalizeValues = true;      
const int LabelCorner = 0;             
const int LabelDistanceX = 5;           
const int LabelDistanceY = 20;          
const string CustomSuffix = "";        


string pairAUDUSD = "AUDUSD";
string pairNZDUSD = "NZDUSD";
string pairEURUSD = "EURUSD";
string pairGBPUSD = "GBPUSD";
string pairUSDJPY = "USDJPY";
string pairUSDCHF = "USDCHF";
string pairUSDCAD = "USDCAD";
string pairUSDNOK = "USDNOK";  
string pairAUDJPY = "AUDJPY";  
string pairGBPJPY = "GBPJPY";  
string pairNZDJPY = "NZDJPY";  
string pairEURJPY = "EURJPY";  
string pairXAUUSD = "XAUUSD";  
string pairXAGUSD = "XAGUSD"; 
string pairBTCUSD = "BTCUSD";   
string pairNAS100 = "NAS100";   
string pairETHUSD = "ETHUSD";   
string pairLTCUSD = "LTCUSD";   


color colorAUDUSD = IndicatorColor;        
color colorNZDUSD = IndicatorColor;       
color colorGBPUSD = IndicatorColor;        
color colorEURUSD = IndicatorColor;        
color colorUSDCHF = IndicatorColor;        
color colorUSDJPY = IndicatorColor;        
color colorUSDNOK = IndicatorColor;        
color colorGBPJPY = IndicatorColor;        
color colorAUDJPY = IndicatorColor;        
color colorNZDJPY = IndicatorColor;        
color colorEURJPY = IndicatorColor;        
color colorXAUUSD = IndicatorColor;        
color colorXAGUSD = IndicatorColor;        
color colorNAS100 = IndicatorColor;        
color colorBTCUSD = IndicatorColor;        

double Buffer1[];

string g_mainSymbol;
string g_correlatedSymbol;
color g_correlationColor;
bool g_isValidPair = false;

int g_panelWidth = 200;
int g_panelHeight = 40;
color g_arrowUpColor = clrLime;
color g_arrowDownColor = clrRed;

string g_indicatorName = "CorrelationIndicator";

//+------------------------------------------------------------------+
//| The correct symbol name with possible suffix                     |
//+------------------------------------------------------------------+
string GetSymbolName(string baseSymbol) 
{
    if (baseSymbol == "XAUUSD") {
        string goldVariations[] = {
            "XAUUSD", "GOLD", "GLD", "XAUUSD.", "XAU/USD", 
            "GOLD.", "GC", "XAUUSD-", "GOL", "XAU", "GOLDPRO", 
            "GDX", "GOLDX", "XGLD", "GOLDm", "XAUUSDm"
        };
        
        for (int i=0; i < ArraySize(goldVariations); i++) {
            if (MarketInfo(goldVariations[i], MODE_POINT) != 0) {
                return goldVariations[i];
            }
        }
    }
    
    if (baseSymbol == "XAGUSD") {
        string silverVariations[] = {
            "XAGUSD", "SILVER", "SLV", "XAGUSD.", "XAG/USD", 
            "SILVER.", "SI", "XAGUSD-", "SIL", "XAG", "SILVERPRO", 
            "XSILVER", "SILVERX", "XSLV", "SILVERm", "XAGUSDm"
        };
        
        for (int i=0; i < ArraySize(silverVariations); i++) {
            if (MarketInfo(silverVariations[i], MODE_POINT) != 0) {
                return silverVariations[i];
            }
        }
    }
    
    if (baseSymbol == "BTCUSD") {
        string btcVariations[] = {
            "BTCUSD", "BTC/USD", "BITCOIN", "BTC", "BTCUSDT", "BTCUSD.", 
            "BTCUSD-", "BTC-USD", "XBTUSD", "XBT/USD", "BTCUSDC", 
            "BTCUSDm", "BTC.USD", "BTC_USD", "BTCF", "CRYPTOBTC", 
            "BTCUSDPRO", "1BTCUSD", "BTCUSDS", "BTCUSDX"
        };
        
        for (int i=0; i < ArraySize(btcVariations); i++) {
            if (MarketInfo(btcVariations[i], MODE_POINT) != 0) {
                return btcVariations[i];
            }
        }
    }
    
    if (baseSymbol == "NAS100") {
        string nasdaqVariations[] = {
            "NAS100", "NASDAQ", "NDX", "NASDAQ100", "NAS100.", "NASDAQ.", 
            "NAS100-", "NASDAQ-", "NQ", "NQH", "NQM", "USTEC", "US100", 
            "US-TECH", "TECH100", "NDX100", "NAS", "NASDAQINDEX", 
            "NAS100m", "NASDAQm", "US100m", "USTECm", "NAS100PRO", 
            "NASDAQ100PRO", "1NAS100", "NAS100S", "NAS100X", "SPX500",
            "NQ100", "NDAQ", "NASD", "USTECHINDEX", "USNASDAQ"
        };
        
        for (int i=0; i < ArraySize(nasdaqVariations); i++) {
            if (MarketInfo(nasdaqVariations[i], MODE_POINT) != 0) {
                return nasdaqVariations[i];
            }
        }
    }
    
    if (CustomSuffix != "")
        return baseSymbol + CustomSuffix;
        
    string suffixes[] = {"m", ".m", "-m", "micro", "c", ".c", "-c", "cent", ".micro", "-micro", ".cent", "-cent"};
    
    for (int i=0; i < ArraySize(suffixes); i++) {
        string testSymbol = baseSymbol + suffixes[i];
        if (MarketInfo(testSymbol, MODE_POINT) != 0) {
            return testSymbol;
        }
    }
    
    if (MarketInfo(baseSymbol, MODE_POINT) != 0) {
        return baseSymbol;
    }
    
    return baseSymbol;
}

//+------------------------------------------------------------------+
//| Indicator initialization                                         |
//+------------------------------------------------------------------+
int OnInit()
{
    if (CheckInstanceExists()) {
        return(INIT_FAILED);
    }
    
    string fullAUDUSD = GetSymbolName(pairAUDUSD);
    string fullNZDUSD = GetSymbolName(pairNZDUSD);
    string fullEURUSD = GetSymbolName(pairEURUSD);
    string fullGBPUSD = GetSymbolName(pairGBPUSD);
    string fullUSDJPY = GetSymbolName(pairUSDJPY);
    string fullUSDCHF = GetSymbolName(pairUSDCHF);
    string fullUSDCAD = GetSymbolName(pairUSDCAD);
    string fullUSDNOK = GetSymbolName(pairUSDNOK);  
    string fullAUDJPY = GetSymbolName(pairAUDJPY);  
    string fullGBPJPY = GetSymbolName(pairGBPJPY);  
    string fullNZDJPY = GetSymbolName(pairNZDJPY);  
    string fullEURJPY = GetSymbolName(pairEURJPY);  
    string fullXAUUSD = GetSymbolName(pairXAUUSD);  
    string fullXAGUSD = GetSymbolName(pairXAGUSD);  
    string fullBTCUSD = GetSymbolName(pairBTCUSD);  
    string fullNASDAQ = GetSymbolName(pairNAS100);  
    string fullETHUSD = GetSymbolName(pairETHUSD);   
    string fullLTCUSD = GetSymbolName(pairLTCUSD);   
    
    string currentChart = Symbol();
    string baseCurrentChart = StringSubstr(currentChart, 0, 6);
    
    g_isValidPair = false;
    
    if (StringFind(baseCurrentChart, StringSubstr(pairAUDUSD, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullNZDUSD;
        g_correlationColor = colorNZDUSD;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairNZDUSD, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullAUDUSD;
        g_correlationColor = colorAUDUSD;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairEURUSD, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullGBPUSD;
        g_correlationColor = colorGBPUSD;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairGBPUSD, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullEURUSD;
        g_correlationColor = colorEURUSD;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairUSDJPY, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullUSDCHF;
        g_correlationColor = colorUSDCHF;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairUSDCHF, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullUSDJPY;
        g_correlationColor = colorUSDJPY;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairUSDCAD, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullUSDNOK;
        g_correlationColor = colorUSDNOK;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairAUDJPY, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullNZDJPY;
        g_correlationColor = colorNZDJPY;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairGBPJPY, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullEURJPY;
        g_correlationColor = colorEURJPY;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairEURJPY, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullGBPJPY;
        g_correlationColor = colorGBPJPY;
        g_isValidPair = true;
    }
    else if (StringFind(baseCurrentChart, StringSubstr(pairNZDJPY, 0, 6)) >= 0) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullAUDJPY;
        g_correlationColor = colorAUDJPY;
        g_isValidPair = true;
    }
    else if (IsGoldSymbol(currentChart)) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullXAGUSD;
        g_correlationColor = colorXAGUSD;
        g_isValidPair = true;
    }
    else if (IsSilverSymbol(currentChart)) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullXAUUSD;
        g_correlationColor = colorXAUUSD;
        g_isValidPair = true;
    }
    else if (IsBitcoinSymbol(currentChart)) {
        g_mainSymbol = currentChart;
        g_correlatedSymbol = fullNASDAQ;
        g_correlationColor = colorNAS100;
        g_isValidPair = true;
    }
   else if (IsEthereumSymbol(currentChart)) {
         g_mainSymbol = currentChart;
         g_correlatedSymbol = fullBTCUSD;
         g_correlationColor = colorBTCUSD;
         g_isValidPair = true;
   }
   else if (IsLitecoinSymbol(currentChart)) {
         g_mainSymbol = currentChart;
         g_correlatedSymbol = fullBTCUSD;
         g_correlationColor = colorBTCUSD;
         g_isValidPair = true;
   }
    
    if (!g_isValidPair) {
        Alert("Correlation Indicator: This indicator only works on supported currency pairs.\n"
              "Supported pairs: AUDUSD, NZDUSD, EURUSD, GBPUSD, USDJPY, USDCHF, USDCAD, AUDJPY, GBPJPY, NZDJPY, XAUUSD/GOLD, XAGUSD/SILVER, BTCUSD/BITCOIN, ETHUSD/ETHEREUM, LTCUSD/LITECOIN");
        return(INIT_FAILED);
    }
    
    SetIndexBuffer(0, Buffer1);
    
    SetIndexLabel(0, g_correlatedSymbol);
    
    SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2, g_correlationColor);
    
    SetIndexShift(0, ShiftValue);
    
    CreatePanel();
    
    ChartSetInteger(0, CHART_FOREGROUND, false);
    ChartRedraw(); 
    
    IndicatorSetInteger(INDICATOR_DIGITS, Digits);
    
    CreateInstanceMarker();
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Helper checking Functions                                                 |
//+------------------------------------------------------------------+

bool IsSilverSymbol(string symbol)
{
    string silverSymbols[] = {
        "XAGUSD", "SILVER", "SLV", "XAG/USD", "SIL", "XAG", 
        "SILVERPRO", "XSILVER", "SILVERX", "SI"
    };
    
    for(int i=0; i < ArraySize(silverSymbols); i++) {
        if(StringFind(symbol, silverSymbols[i]) >= 0) {
            return true;
        }
    }
    
    return false;
}

bool IsGoldSymbol(string symbol)
{
    string goldSymbols[] = {
        "XAUUSD", "GOLD", "GLD", "XAU/USD", "GOL", "XAU", 
        "GOLDPRO", "XGLD", "GOLDX", "GC"
    };
    
    for(int i=0; i < ArraySize(goldSymbols); i++) {
        if(StringFind(symbol, goldSymbols[i]) >= 0) {
            return true;
        }
    }
    
    return false;
}

bool IsBitcoinSymbol(string symbol)
{
    string bitcoinSymbols[] = {
        "BTCUSD", "BITCOIN", "BTC", "BTC/USD", "XBTUSD", "BTCUSDT",
        "BTCUSDC", "BTCUSDPERP", "BTC.USD", "BTCEUR", "BTCCASH"
    };
    
    // Check if symbol name contains any of these substrings
    for(int i=0; i < ArraySize(bitcoinSymbols); i++) {
        if(StringFind(symbol, bitcoinSymbols[i]) >= 0) {
            return true;
        }
    }
    
    return false;
}

bool IsNasdaqSymbol(string symbol)
{
    string nasdaqSymbols[] = {
        "NAS100", "NASDAQ", "NDX", "NASDAQ100", "NQ", "USTEC", 
        "US100", "US-TECH", "TECH100", "NDX100", "NAS", 
        "NASDAQINDEX", "NQ100", "NDAQ", "NASD", "USTECHINDEX", 
        "USNASDAQ", "SPX500"
    };
    
    for(int i=0; i < ArraySize(nasdaqSymbols); i++) {
        if(StringFind(symbol, nasdaqSymbols[i]) >= 0) {
            return true;
        }
    }
    
    return false;
}

bool IsEthereumSymbol(string symbol)
{
    string ethereumSymbols[] = {
        "ETHUSD", "ETHEREUM", "ETH", "ETH/USD", "ETHUSDT", "ETHUSDC",
        "ETHUSDPERP", "ETH.USD", "ETHEUR", "ETHBTC", "ETHCASH",
        "ETHERBTC", "ETHERUSD", "ETH/BTC", "ETHXBT"
    };
    
    for(int i=0; i < ArraySize(ethereumSymbols); i++) {
        if(StringFind(symbol, ethereumSymbols[i]) >= 0) {
            return true;
        }
    }
    
    return false;
}

bool IsLitecoinSymbol(string symbol)
{
    string litecoinSymbols[] = {
        "LTCUSD", "LITECOIN", "LTC", "LTC/USD", "LTCUSDT", "LTCUSDC",
        "LTCUSDPERP", "LTC.USD", "LTCEUR", "LTCBTC", "LTCCASH",
        "LITECOINUSD", "LTC/BTC", "LTCXBT", "LTCUSD.cash", "LTCm"
    };
    
    for(int i=0; i < ArraySize(litecoinSymbols); i++) {
        if(StringFind(symbol, litecoinSymbols[i]) >= 0) {
            return true;
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Checking if the instance of this indicator already exists         |
//+------------------------------------------------------------------+

bool CheckInstanceExists()
{
    return ObjectFind(g_indicatorName) >= 0;
}

void CreateInstanceMarker()
{
    // Create a hidden label object as our marker
    if (ObjectFind(g_indicatorName) < 0) {
        ObjectCreate(g_indicatorName, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, g_indicatorName, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS); // Hide from all timeframes
        ObjectSetInteger(0, g_indicatorName, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, g_indicatorName, OBJPROP_SELECTABLE, false);
        ObjectSetString(0, g_indicatorName, OBJPROP_TEXT, "CorrelationInstanceMarker");
    }
}

//+------------------------------------------------------------------+
//| Indicator deinitialization                                       |
//+------------------------------------------------------------------+

void OnDeinit(const int reason)
{
    ObjectDelete("_CorrelationPanel");
    ObjectDelete("_SymbolLabel");
    ObjectDelete("_CorrelValue");
    ObjectDelete("_TrendArrow");
    
    ObjectDelete(g_indicatorName);
}

//+------------------------------------------------------------------+
//| Information panel                                                |
//+------------------------------------------------------------------+
void CreatePanel()
{
    // Panel background
    string panelName = "_CorrelationPanel";
    ObjectCreate(panelName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
    ObjectSetInteger(0, panelName, OBJPROP_CORNER, LabelCorner);
    ObjectSetInteger(0, panelName, OBJPROP_XDISTANCE, LabelDistanceX);
    ObjectSetInteger(0, panelName, OBJPROP_YDISTANCE, LabelDistanceY);
    ObjectSetInteger(0, panelName, OBJPROP_XSIZE, g_panelWidth);
    ObjectSetInteger(0, panelName, OBJPROP_YSIZE, g_panelHeight);
    ObjectSetInteger(0, panelName, OBJPROP_BGCOLOR, C'25,25,25');
    ObjectSetInteger(0, panelName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
    ObjectSetInteger(0, panelName, OBJPROP_COLOR, clrGray);
    ObjectSetInteger(0, panelName, OBJPROP_BACK, false);
    ObjectSetInteger(0, panelName, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(0, panelName, OBJPROP_HIDDEN, true);  
    
    // Calculating positions for center alignment
    int centerX = LabelDistanceX + g_panelWidth/2;
    int symbolX = centerX - 80; 
    int valueX = centerX - 10;
    int arrowX = centerX + 50;
    
    // Label for correlated symbol
    string labelName = "_SymbolLabel";
    ObjectCreate(labelName, OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, labelName, OBJPROP_CORNER, LabelCorner);
    ObjectSetInteger(0, labelName, OBJPROP_XDISTANCE, symbolX);
    ObjectSetInteger(0, labelName, OBJPROP_YDISTANCE, LabelDistanceY + 15);
    ObjectSetString(0, labelName, OBJPROP_TEXT, g_correlatedSymbol);
    ObjectSetString(0, labelName, OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, labelName, OBJPROP_FONTSIZE, 9);
    ObjectSetInteger(0, labelName, OBJPROP_COLOR, IndicatorColor);
    ObjectSetInteger(0, labelName, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(0, labelName, OBJPROP_HIDDEN, true);  
    
    // Value display for correlation value
    string valueName = "_CorrelValue";
    ObjectCreate(valueName, OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, valueName, OBJPROP_CORNER, LabelCorner);
    ObjectSetInteger(0, valueName, OBJPROP_XDISTANCE, valueX);
    ObjectSetInteger(0, valueName, OBJPROP_YDISTANCE, LabelDistanceY + 15);
    ObjectSetString(0, valueName, OBJPROP_TEXT, "0.00%");
    ObjectSetString(0, valueName, OBJPROP_FONT, "Arial");
    ObjectSetInteger(0, valueName, OBJPROP_FONTSIZE, 9);
    ObjectSetInteger(0, valueName, OBJPROP_COLOR, clrWhite);
    ObjectSetInteger(0, valueName, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(0, valueName, OBJPROP_HIDDEN, true);  
    
    // Arrows for trend direction
    string arrowName = "_TrendArrow";
    ObjectCreate(arrowName, OBJ_LABEL, 0, 0, 0);
    ObjectSetInteger(0, arrowName, OBJPROP_CORNER, LabelCorner);
    ObjectSetInteger(0, arrowName, OBJPROP_XDISTANCE, arrowX);
    ObjectSetInteger(0, arrowName, OBJPROP_YDISTANCE, LabelDistanceY + 15);
    ObjectSetString(0, arrowName, OBJPROP_TEXT, "→");
    ObjectSetString(0, arrowName, OBJPROP_FONT, "Wingdings");
    ObjectSetInteger(0, arrowName, OBJPROP_FONTSIZE, 12);
    ObjectSetInteger(0, arrowName, OBJPROP_COLOR, clrGray);
    ObjectSetInteger(0, arrowName, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(0, arrowName, OBJPROP_HIDDEN, true);  
}

// Updating the panel with correlation and direction information
void UpdatePanel(double correlationValue, bool isUptrend)
{
    ObjectSetString(0, "_CorrelValue", OBJPROP_TEXT, DoubleToString(correlationValue * 100, 2) + "%");
    
    string upArrow = "ñ";  
    string downArrow = "ò"; 
    
    if(isUptrend) {
        ObjectSetString(0, "_TrendArrow", OBJPROP_TEXT, upArrow);
        ObjectSetInteger(0, "_TrendArrow", OBJPROP_COLOR, g_arrowUpColor);
    }
    else {
        ObjectSetString(0, "_TrendArrow", OBJPROP_TEXT, downArrow);
        ObjectSetInteger(0, "_TrendArrow", OBJPROP_COLOR, g_arrowDownColor);
    }
}

//+------------------------------------------------------------------+
//| Calculation of correlation                                       |
//+------------------------------------------------------------------+
double Correlation(double &array1[], double &array2[], int size)
{
    if(size <= 1) return 0;
    
    double sum_x = 0, sum_y = 0, sum_xy = 0;
    double sum_x2 = 0, sum_y2 = 0;
    
    for(int i = 0; i < size; i++)
    {
        sum_x += array1[i];
        sum_y += array2[i];
        sum_xy += array1[i] * array2[i];
        sum_x2 += array1[i] * array1[i];
        sum_y2 += array2[i] * array2[i];
    }
    
    double denominator = MathSqrt((size * sum_x2 - sum_x * sum_x) * (size * sum_y2 - sum_y * sum_y));
    
    if(denominator == 0) return 0;
    
    return (size * sum_xy - sum_x * sum_y) / denominator;
}

//+------------------------------------------------------------------+
//| Calculating price percentage change for normalization            |
//+------------------------------------------------------------------+
void CalculatePercentageChanges(string symbol, double &prices[], double &changes[], int count, int shift)
{
    double basePrice = iClose(symbol, PERIOD_CURRENT, shift + count);
    
    if(basePrice == 0 || basePrice == EMPTY_VALUE) {
        for(int i = 0; i < count; i++) {
            prices[i] = 0;
            changes[i] = 0;
        }
        return;
    }
    
    for(int i = 0; i < count; i++)
    {
        prices[i] = iClose(symbol, PERIOD_CURRENT, shift + count - 1 - i);
        
        if(prices[i] == 0 || prices[i] == EMPTY_VALUE) {
            changes[i] = 0;
        } else {
            changes[i] = (prices[i] - basePrice) / basePrice * 100;
        }
    }
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    if (!g_isValidPair) return(0);
    
    static int lastTimeframe = Period();
    if(lastTimeframe != Period()) {
        lastTimeframe = Period();
        ArrayInitialize(Buffer1, EMPTY_VALUE);
        ChartRedraw();
        return(0); 
    }
    
    int limit = rates_total - prev_calculated;
    
    static bool debug_done = false;
    if(!debug_done) {
        debug_done = true;
        double test = MarketInfo(g_correlatedSymbol, MODE_POINT);
        if(test == 0)
            Alert("Symbol not found: ", g_correlatedSymbol, ". Please check if this symbol exists in your broker.");
    }
    
    if(prev_calculated == 0)
    {
        ArrayInitialize(Buffer1, EMPTY_VALUE);
        limit = rates_total - CorrelationPeriod - 1;
    }
    
    for(int i = limit; i >= 0; i--)
    {
        double pricesMain[]; 
        double pricesCorrelated[];
        double changesMain[];
        double changesCorrelated[];
        
        ArrayResize(pricesMain, CorrelationPeriod);
        ArrayResize(pricesCorrelated, CorrelationPeriod);
        ArrayResize(changesMain, CorrelationPeriod);
        ArrayResize(changesCorrelated, CorrelationPeriod);
        
        CalculatePercentageChanges(g_mainSymbol, pricesMain, changesMain, CorrelationPeriod, i);
        CalculatePercentageChanges(g_correlatedSymbol, pricesCorrelated, changesCorrelated, CorrelationPeriod, i);
        
        double correlationValue = Correlation(changesMain, changesCorrelated, CorrelationPeriod);
        
        bool isUptrend = pricesCorrelated[CorrelationPeriod-1] > pricesCorrelated[CorrelationPeriod-2];
        
        if(NormalizeValues)
        {
            double mainClose = close[i];
            double scale = correlationValue > 0 ? 1 : -1; 
            
            Buffer1[i] = mainClose * (1 + changesCorrelated[CorrelationPeriod-1] / 100 * scale);
        }
        else
        {
            Buffer1[i] = pricesCorrelated[CorrelationPeriod-1];
        }
        
        if(i == 0)
        {
            UpdatePanel(correlationValue, isUptrend);
        }
    }
    
    return(rates_total);
}
