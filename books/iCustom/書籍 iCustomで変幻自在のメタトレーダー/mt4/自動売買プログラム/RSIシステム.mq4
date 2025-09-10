
#define MAGIC 777

// �p�����[�^�[�̐ݒ�//
extern int RSIPeriod = 12; //RSI �̊��Ԑݒ�
extern int Long_Point = 30; // �����G���g���[����|�C���g
extern int Short_Point = 70; // ����G���g���[����|�C���g
extern int Long_ExitPoint = 70; // �����|�W�V���������ς���|�C���g
extern int Short_ExitPoint = 30; // ����|�W�V���������ς���|�C���g

extern double Lots = 1.0; // ������b�g��
extern int Slip = 10; // ���e�X���b�y�[�W��
extern string Comments = ""; // �R�����g

// �ϐ��̐ݒ�//
int Ticket_L = 0; // ���������̌��ʂ��L���b�`����ϐ�
int Ticket_S = 0; // ���蒍���̌��ʂ��L���b�`����ϐ�
int Exit_L = 0; // �����|�W�V�����̌��ϒ����̌��ʂ��L���b�`����ϐ�
int Exit_S = 0; // ����|�W�V�����̌��ϒ����̌��ʂ��L���b�`����ϐ�

int start()
{

   // �����|�W�V�����̃G�O�W�b�g
   if(   iCustom(NULL,0,"RSI",RSIPeriod,0,2) < Long_ExitPoint
      && iCustom(NULL,0,"RSI",RSIPeriod,0,1) >= Long_ExitPoint
      && ( Ticket_L != 0 && Ticket_L != -1 ))
      {
         Exit_L = OrderClose(Ticket_L,Lots,Bid,Slip,Red);
         if( Exit_L == 1 ) {Ticket_L = 0;}
      }
   
   // ����|�W�V�����̃G�O�W�b�g
   if(   iCustom(NULL,0,"RSI",RSIPeriod,0,2) > Short_ExitPoint
      && iCustom(NULL,0,"RSI",RSIPeriod,0,1) <= Short_ExitPoint
      && ( Ticket_S != 0 && Ticket_S != -1 ))
      {
         Exit_S = OrderClose(Ticket_S,Lots,Ask,Slip,Blue);
         if( Exit_S == 1 ) {Ticket_S = 0;}
      }
      
   // �����G���g���[
   if(   iCustom(NULL,0,"RSI",RSIPeriod,0,2) > Long_Point
      && iCustom(NULL,0,"RSI",RSIPeriod,0,1) <= Long_Point
      && ( Ticket_L == 0 || Ticket_L == -1 )
      && ( Ticket_S == 0 || Ticket_S == -1 ))
      {
         Ticket_L = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip,0,0,Comments,MAGIC,0,Red);
      }
      
   // ����G���g���[
   if(   iCustom(NULL,0,"RSI",RSIPeriod,0,2) < Short_Point
      && iCustom(NULL,0,"RSI",RSIPeriod,0,1) >= Short_Point
      && ( Ticket_S == 0 || Ticket_S == -1 )
      && ( Ticket_L == 0 || Ticket_L == -1 ))
      {
         Ticket_S = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip,0,0,Comments,MAGIC,0,Blue);
      }
      
return(0);
}