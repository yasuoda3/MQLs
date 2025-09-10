
// マジックナンバーの定義
#define MAGIC 007

// パラメーターの設定//
extern int Fast_MA_Period = 15;// 短期移動平均線の期間設定
extern int Slow_MA_Period = 75;// 長期移動平均線の期間設定
extern int MA_Shift = 0; // 移動平均を右にシフトする設定
extern int MA_Method = 0; // 移動平均方法の設定
extern int RSIPeriod = 6; //RSI の期間設定

extern double Lots = 1.0; // 取引ロット数
extern int Slip = 10; // 許容スリッページ数
extern string Comments = " "; // コメント

// 変数の設定//
int Ticket_L = 0; // 買い注文の結果をキャッチする変数
int Ticket_S= 0; // 売り注文の結果をキャッチする変数
int Exit_L = 0; // 買いポジションの決済注文の結果をキャッチする変数
int Exit_S = 0; // 売りポジションの決済注文の結果をキャッチする変数

double Fast_MA_2= 0; /*2 本前のバーの短期移動平均線に変身したiCustom 関数
                     を代入する変数*/
double Slow_MA_2= 0; /*2 本前のバーの長期移動平均線に変身したiCustom 関数
                     を代入する変数*/
double Fast_MA_1= 0; /*1 本前のバーの短期移動平均線に変身したiCustom 関数
                     を代入する変数*/
double Slow_MA_1= 0; /*1 本前のバーの長期移動平均線に変身したiCustom 関数
                     を代入する変数*/
                     
double RSI_2= 0; //2 本前のバーのRSI に変身したiCustom 関数を代入する変数
double RSI_1= 0; //1 本前のバーのRSI に変身したiCustom 関数を代入する変数


int start()
{

   Fast_MA_2= iCustom(NULL,0,"Moving Averages",Fast_MA_Period,MA_Shift,MA_Method,0,2);
   Slow_MA_2 = iCustom(NULL,0,"Moving Averages",Slow_MA_Period,MA_Shift,MA_Method,0,2);
   Fast_MA_1= iCustom(NULL,0,"Moving Averages",Fast_MA_Period,MA_Shift,MA_Method,0,1);
   Slow_MA_1 = iCustom(NULL,0,"Moving Averages",Slow_MA_Period,MA_Shift,MA_Method,0,1);
   
   RSI_2 = iCustom(NULL,0,"RSI",RSIPeriod,0,2);
   RSI_1 = iCustom(NULL,0,"RSI",RSIPeriod,0,1);
   
   
   // 買いポジションのエグジット
   if(   Fast_MA_2 >= Slow_MA_2
      && Fast_MA_1 < Slow_MA_1
      && ( Ticket_L != 0 && Ticket_L != -1 ))
      {
         Exit_L = OrderClose(Ticket_L,Lots,Bid,Slip,Red);
         if( Exit_L ==1 ) {Ticket_L = 0;}
      }
      
   // 売りポジションのエグジット
   if(   Fast_MA_2 <= Slow_MA_2
      && Fast_MA_1 > Slow_MA_1
      && ( Ticket_S != 0 && Ticket_S != -1 ))
      {
         Exit_S = OrderClose(Ticket_S,Lots,Ask,Slip,Blue);
         if( Exit_S ==1 ) {Ticket_S = 0;}
      }

   // 買いエントリー
   if(   Fast_MA_1 > Slow_MA_1
      && RSI_2 > 30 && RSI_1 <= 30
      && ( Ticket_L == 0 || Ticket_L == -1 )
      && ( Ticket_S == 0 || Ticket_S == -1 ))
      {
         Ticket_L = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip,0,0,Comments,MAGIC,0,Red);
      }
      
   // 売りエントリー
   if(   Fast_MA_1 < Slow_MA_1
      && RSI_2 < 70 && RSI_1 >= 70
      && ( Ticket_S == 0 || Ticket_S == -1 )
      && ( Ticket_L == 0 || Ticket_L == -1 ))
      {
         Ticket_S = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip,0,0,Comments,MAGIC,0,Blue);
      }
   
   
return(0);
}