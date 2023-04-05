#include <func.mqh>

int magic_num = 7335; 
bool flagforbuy=1;
bool flagforsell=1;

 int OnInit()
  {

    
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
// DebugBreak(); 
 
   if(ifPos(magic_num, _Symbol)){                                           //есть ли хоть одна позиция по этому инструменту 
     
     if(CountPositions(magic_num, _Symbol)<2)                                //если всего позиций по инструменту < 2
     {
        if(PositionSelect(_Symbol))
        {
          if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)     
             Open_Sell_pos(_Symbol, trans_volume, magic_num);
          if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
             Open_Buy_pos(_Symbol, trans_volume, magic_num);
        } 
     }
     
     for(int i=0; i<CountPositions(magic_num, _Symbol); i++)               //проверяет позиции по данному инструменту. i < кол-ва позиций по данному инструменту
     { 
        if(PositionSelectByTicket(PositionGetTicket(i)))
        {
        
           if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
              double sum_pos = PositionGetDouble(POSITION_VOLUME)/0.01;
               
               if(PositionGetDouble(POSITION_PROFIT) <= (sum_pos*(-1))*2 && flagforbuy)
               { 
                 double new_trans_vol = sum_pos*0.01;
                 Open_Buy_pos(_Symbol, new_trans_vol, magic_num);
                 flagforbuy = 0;
               }
           }
           
           if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
           {
              double sum_pos = PositionGetDouble(POSITION_VOLUME)/0.01;
               
               if(PositionGetDouble(POSITION_PROFIT) <= (sum_pos*(-1))*2 && flagforsell)
               { 
                 double new_trans_vol = sum_pos*0.01;
                 Open_Sell_pos(_Symbol, new_trans_vol, magic_num);
                 flagforsell = 0;
               }
           }
        }
     }
     
   }
   else{
     Open_Buy_pos(_Symbol, trans_volume, magic_num);
     Open_Sell_pos(_Symbol, trans_volume, magic_num); 
   }
   

   
  }




