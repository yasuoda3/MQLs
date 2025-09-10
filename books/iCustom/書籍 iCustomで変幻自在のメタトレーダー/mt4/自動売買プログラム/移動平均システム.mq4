
// �}�W�b�N�i���o�[�̒�`
#define MAGIC 5582

// �p�����[�^�[�̐ݒ�//
extern int Fast_MA_Period = 6; // �Z���ړ����ϐ��̊��Ԑݒ�
extern int Slow_MA_Period = 13; // �����ړ����ϐ��̊��Ԑݒ�
extern int MA_Shift = 0; // �ړ����ς��E�ɃV�t�g����o�[���̐ݒ�
extern int MA_Method = 0; // �ړ����ϕ��@�̐ݒ�

extern double Lots = 1.0; // ������b�g��
extern int Slip = 10; // ���e�X���b�y�[�W��
extern string Comments = " "; // �R�����g

// �ϐ��̐ݒ�//
int Ticket_L = 0; // ���������̌��ʂ��L���b�`����ϐ�
int Ticket_S = 0; // ���蒍���̌��ʂ��L���b�`����ϐ�
int Exit_L = 0; // �����|�W�V�����̌��ϒ����̌��ʂ��L���b�`����ϐ�
int Exit_S = 0; // ����|�W�V�����̌��ϒ����̌��ʂ��L���b�`����ϐ�

double Fast_MA_2 = 0;
double Slow_MA_2 = 0;
double Fast_MA_1 = 0;
double Slow_MA_1 = 0;

int start()
{

   Fast_MA_2 = iCustom(NULL,0,"Moving Averages",Fast_MA_Period,MA_Shift,MA_Method,0,2);
   Slow_MA_2 = iCustom(NULL,0,"Moving Averages",Slow_MA_Period,MA_Shift,MA_Method,0,2);
   Fast_MA_1 = iCustom(NULL,0,"Moving Averages",Fast_MA_Period,MA_Shift,MA_Method,0,1);
   Slow_MA_1 = iCustom(NULL,0,"Moving Averages",Slow_MA_Period,MA_Shift,MA_Method,0,1);

   // �����|�W�V�����̃G�O�W�b�g
   if(   Fast_MA_2 >= Slow_MA_2
      && Fast_MA_1 < Slow_MA_1
      && ( Ticket_L != 0 && Ticket_L != -1 ))
      {
         Exit_L = OrderClose(Ticket_L,Lots,Bid,Slip,Red);
         if( Exit_L ==1 ) {Ticket_L = 0;}
      }
      
   // ����|�W�V�����̃G�O�W�b�g
   if(   Fast_MA_2 <= Slow_MA_2
      && Fast_MA_1 > Slow_MA_1
      && ( Ticket_S != 0 && Ticket_S != -1 ))
      {
         Exit_S = OrderClose(Ticket_S,Lots,Ask,Slip,Blue);
         if( Exit_S ==1 ) {Ticket_S = 0;}
      }
      
   // �����G���g���[
   if(   Fast_MA_2 <= Slow_MA_2
      && Fast_MA_1 > Slow_MA_1
      && ( Ticket_L == 0 || Ticket_L == -1 )
      && ( Ticket_S == 0 || Ticket_S == -1 ))
      {
         Ticket_L = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip,0,0,Comments,MAGIC,0,Red);
      }
      
   // ����G���g���[
   if(   Fast_MA_2 >= Slow_MA_2
      && Fast_MA_1 < Slow_MA_1
      && ( Ticket_S == 0 || Ticket_S == -1 )
      && ( Ticket_L == 0 || Ticket_L == -1 ))
      {
         Ticket_S = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip,0,0,Comments,MAGIC,0,Blue);
      }
      
return(0);
}