
//+------------------------------------------------------------------+
//|                                              Entry&Exit_Mail.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

#property indicator_chart_window

extern bool Japanese = true;

double TradeCloseTime=0;
double TradeOpenTime=0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()
  {

   if(OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY) == true) 
    {        
      TradeCloseTime=OrderCloseTime();
    }   
   else 
      {
         TradeCloseTime=TimeCurrent();        
      }  
   

   if(OrderSelect(OrdersTotal()-1, SELECT_BY_POS) == true)
    {
      TradeOpenTime = OrderOpenTime();
    }     
   else 
    {
      TradeOpenTime=TimeCurrent();
    }
   

//----
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
  {
   
   
   for( int i=OrdersHistoryTotal()-1; i>=0; i-- )
    {     
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) == false) break;
       {  
         if( TradeCloseTime != 0 )  
          {   
            if( TradeCloseTime < OrderCloseTime() )
             {                   
               if(OrderType() == OP_BUY)
                { 
                   if(Japanese == true)     
                    {                             
                      SendMail("Long Exit","���:�����O����"+"\r\n�ʉ݃y�A:"+OrderSymbol()+"\r\n���v:"+ DoubleToStr(OrderProfit(),2)+ " ("+AccountCurrency()+")"+"\r\n�R�����g:"+ OrderComment());                   
                    }
                   else
                    { 
                      SendMail("Long Exit","Type:Long Exit"+"\r\nCurrency:"+OrderSymbol()+"\r\nProfit:"+ DoubleToStr(OrderProfit(),2)+" ("+AccountCurrency()+")"+"\r\nComment:"+ OrderComment());                   
                    }
                }     
               if(OrderType() == OP_SELL)
                {
                  if(Japanese == true)     
                   {       
                     SendMail("Short Exit","���:�V���[�g����"+"\r\n�ʉ݃y�A:"+OrderSymbol()+"\r\n���v:"+ DoubleToStr(OrderProfit(),2)+" ("+AccountCurrency()+")"+"\r\n�R�����g:"+ OrderComment());                                  
                   }
                  else
                   {
                     SendMail("Short Exit","Type:Short Exit"+"\r\nCurrency:"+OrderSymbol()+"\r\nProfit:"+ DoubleToStr(OrderProfit(),2)+" ("+AccountCurrency()+")"+"\r\nComment:"+ OrderComment());                  
                   }                            
                }               
             }  
            else
             {
               break;
             }
          }                                        
       }   
    }        


   if(OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY) == true) 
    {        
      TradeCloseTime=OrderCloseTime();
    }    
   else 
    {
      TradeCloseTime=TimeCurrent();        
    }     


   for( i=OrdersTotal()-1; i>=0; i-- )
    {
      if(OrderSelect(i, SELECT_BY_POS) == true)
       {
         if( TradeOpenTime != 0 )
          {   
            if( TradeOpenTime < OrderOpenTime() )
             {   
               if(OrderType() == OP_BUY)
                {
                  if(Japanese == true)     
                   {                                       
                     SendMail("Long Entry","���:�����O�G���g���["+"\r\n�ʉ݃y�A:"+OrderSymbol()+"\r\n��艿�i:"+ DoubleToStr(OrderOpenPrice(),MarketInfo(OrderSymbol(),MODE_DIGITS))+"\r\n�R�����g:"+ OrderComment()); 
                   }
                  else
                   {
                      SendMail("Long Entry","Type:Long Entry"+"\r\nCurrency:"+OrderSymbol()+"\r\nPrice:"+ DoubleToStr(OrderOpenPrice(),MarketInfo(OrderSymbol(),MODE_DIGITS))+"\r\nComment:"+ OrderComment());                   
                   }                                 
                } 
             if(OrderType() == OP_SELL)
                {     
                  if(Japanese == true)     
                   {
                     SendMail("Short Entry","���:�V���[�g�G���g���["+"\r\n�ʉ݃y�A:"+OrderSymbol()+"\r\n��艿�i:"+ DoubleToStr(OrderOpenPrice(),MarketInfo(OrderSymbol(),MODE_DIGITS))+"\r\n�R�����g:"+ OrderComment());       
                   }
                  else
                   {
                      SendMail("Short Entry","Type:Short Entry"+"\r\nCurrency:"+OrderSymbol()+"\r\nPrice:"+ DoubleToStr(OrderOpenPrice(),MarketInfo(OrderSymbol(),MODE_DIGITS))+"\r\nComment:"+ OrderComment());                   
                   }          
                }               
             }   
             else
             {
               break;
             } 
          }
       }  
    }             
    

   if(OrderSelect(OrdersTotal()-1, SELECT_BY_POS) == true)
    {
      TradeOpenTime = OrderOpenTime();
    }



   return(0);
  }
//+------------------------------------------------------------------+