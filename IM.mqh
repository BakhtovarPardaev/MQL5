//+------------------------------------------------------------------+
//|                                                         func.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


double trans_volume = (AccountInfoDouble(ACCOUNT_BALANCE)*0.005)*0.01;
      
      double punct_price = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);         //цена за пункт
      double frofit = (AccountInfoDouble(ACCOUNT_BALANCE)*0.005)*0.2;                  //желаемая прибыль
      int quant_point = frofit/(punct_price * trans_volume);                           //считает количество пунктов до необходимой прибыли  
      
      
      
long Open_Buy_pos (string instrum, double lot, uint magic)
{
   MqlTradeRequest request;
   MqlTradeResult result;
     
   ZeroMemory(request);
   ZeroMemory(result);
   
   request.symbol = instrum;
   double current_ask = SymbolInfoDouble(request.symbol, SYMBOL_ASK);   //buy-price
  
   request.action = TRADE_ACTION_DEAL;                                 
   request.volume = NormalizeDouble(lot,2);
   request.tp = NormalizeDouble(current_ask+quant_point * _Point, _Digits);
   request.type = ORDER_TYPE_BUY;
   request.type_filling = ORDER_FILLING_FOK;
   if(magic > 0) request.magic = magic;
   if(!OrderSend(request,result)) Print("Позиция или ордер BUY не открыт. Ошибка №",result.retcode);
 
   return -1;
}


long Open_Sell_pos (string instrum, double lot, uint magic)
{
   MqlTradeRequest request;
   MqlTradeResult result;
     
   ZeroMemory(request);
   ZeroMemory(result);
   
   request.symbol = instrum;
   double current_bid = SymbolInfoDouble(request.symbol, SYMBOL_BID);   //buy-price
  
   request.action = TRADE_ACTION_DEAL;                                 
   request.volume = NormalizeDouble(lot,2);
   request.tp = NormalizeDouble(current_bid - quant_point * _Point, _Digits);
   request.type = ORDER_TYPE_SELL;
   request.type_filling = ORDER_FILLING_FOK;
   if(magic > 0) request.magic = magic;
   if(!OrderSend(request,result)) Print("Позиция или ордер SELL не открыт. Ошибка №",result.retcode);
   
 
   return -1;
}


enum Direction {
                  direction_buy, 
                  direction_sell 
               };


int CountPositions(int magic , string symbol)
{
   //Переменная-счетчик позиций. Изначально считаем, что позиций нашего робота нет
   int count = 0;                                                          
   
   //Перебираем все имеющиеся на торговом счете позиции
   for(int i = 0;i < PositionsTotal();i++)
   {
      //Вытаскиваем тикет позиции с индексом i и сохраняем его
      //в переменной pos
      ulong pos = PositionGetTicket(i);
      
      //Если позиция с таким тикетом есть и её данные загружены в память
      if(PositionSelectByTicket(pos))
      {
         //Соответствующими функциями считываем нужные свойства позиции
         //и сохраняем их значения соответствующие переменные
         ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         //Если свойства позиции совпадают с контрольными значениями
         //увеличиваем значение переменной-счетчика на один
         if(pos_mag == magic && pos_symb == symbol) count++;
      }
   }
   
   //Функция позвращает итоговый результат в виде
   //итогового значения переменной-счетчика
   return count;
}


/*bool CountPositions(int magic, string symbol)
{
  
   
   //Отдельная переменная для контроля направления позиции
   //При присвоении значения переменной type явное приведение типов оязательно во избежание ошибок
   ENUM_POSITION_TYPE type;
   if(direction == direction_buy) type = (ENUM_POSITION_TYPE)POSITION_TYPE_BUY;
   else type = (ENUM_POSITION_TYPE)POSITION_TYPE_SELL;
   
   for(int i = 0;i < PositionsTotal();i++)
   {
      ulong pos = PositionGetTicket(i);
      if(PositionSelectByTicket(pos))
      {
         ulong pos_mag = PositionGetInteger(POSITION_MAGIC);
         string pos_symb = PositionGetString(POSITION_SYMBOL);
         
         //Считываем направление выбранной позиции. Тоже с явным приведением типов
         ENUM_POSITION_TYPE pos_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         
         if(pos_mag == magic && pos_symb == symbol && pos_type == type) count++;
      }
   }
   
   return count;
}*/




bool ifPos(int magic, string symbol)                                          //проверка на наличие позиции
{ 
  bool count=false;
   for(int i=0; i < PositionsTotal(); i++)
   {
     if(PositionSelectByTicket(PositionGetTicket(i)));
     {
       if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_MAGIC)==magic)
       {
          count = true;
          break;
       }
     }
   }
  return count;
}