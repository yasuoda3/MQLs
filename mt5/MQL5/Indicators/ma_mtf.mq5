//+------------------------------------------------------------------+
//|                                                       MTF_MA.mq5 |
//|                                  Copyright 2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1

// ENUM_TIMEFRAMEは定義済み列挙型配列(PERIOD_M%など) 
input ENUM_TIMEFRAMES TIMEFRAME = PERIOD_H1; // 時間足
input int PERIOD = 10;
input int SHIFT = 0; // シフト
input ENUM_MA_METHOD METHOD = MODE_SMA; // MA種別
input ENUM_APPLIED_PRICE PRICE = PRICE_CLOSE; // 適用価格
input color CLR = clrRed; // 色
input ENUM_LINE_STYLE STYLE = STYLE_SOLID; // 線種
input int WIDTH = 1; // 太さ

//--- indicator buffers
double         MABuffer[];
int handle; 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,MABuffer,INDICATOR_DATA);
   PlotIndexSetInteger(0, PLOT_LINE_COLOR, CLR);
   PlotIndexSetInteger(0, PLOT_LINE_STYLE, STYLE);
   PlotIndexSetInteger(0, PLOT_LINE_WIDTH, WIDTH);
   PlotIndexSetInteger(0, PLOT_DRAW_TYPE, DRAW_LINE);
   PlotIndexSetString(0, PLOT_LABEL, StringSubstr(EnumToString(METHOD), 5) + "(" + (string)PERIOD + ")");
   ArraySetAsSeries(MABuffer, true);
   handle = iMA(NULL, TIMEFRAME, PERIOD, SHIFT, METHOD, PRICE);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   IndicatorRelease(handle);
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
  if (TIMEFRAME < _Period && TIMEFRAME != PERIOD_CURRENT) return 0;
  
  double mtfMa[];
  ArraySetAsSeries(mtfMa, true);
  ArraySetAsSeries(time, true);
//---
   int limit = rates_total - prev_calculated;
   int min = PeriodSeconds(TIMEFRAME) / PeriodSeconds() + 1;
   if (limit < min) limit = min;
   CopyBuffer(handle, 0, 0, limit, mtfMa);
   
   for (int i = limit - 1; i >= 0; i--) {
      int bar = iBarShift(NULL, TIMEFRAME, time[i]);
      MABuffer[i] = mtfMa[bar];
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
