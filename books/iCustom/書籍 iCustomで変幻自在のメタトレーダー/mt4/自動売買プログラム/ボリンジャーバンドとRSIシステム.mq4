
// �}�W�b�N�i���o�[�̒�`
#define MAGIC 1835

// �p�����[�^�[�̐ݒ�//
extern int BandsPeriod = 20; // �{�����W���[�o���h�̊��Ԑݒ�
extern int BandsShift = 0; // �{�����W���[�o���h���E�ɃV�t�g����ݒ�
extern double BandsDeviations = 2.0;// �W���΍��̐ݒ�
extern int RSIPeriod = 12; //RSI �̊��Ԑݒ�

extern double Lots = 1.0; // ������b�g��
extern int Slip = 10; // ���e�X���b�y�[�W��
extern string Comments = " "; // �R�����g

// �ϐ��̐ݒ�//
int Ticket_L = 0; // ���������̌��ʂ��L���b�`����ϐ�
int Ticket_S = 0; // ���蒍���̌��ʂ��L���b�`����ϐ�
int Exit_L = 0; // �����|�W�V�����̌��ϒ����̌��ʂ��L���b�`����ϐ�
int Exit_S = 0; // ����|�W�V�����̌��ϒ����̌��ʂ��L���b�`����ϐ�

double BB_Upper_2 = 0; /*2 �{�O�̃o�[�̏�o���h�ɕϐg����iCustom �֐�
                       ��������ϐ�*/
double BB_Lower_2 = 0; /*2 �{�O�̃o�[�̉��o���h�ɕϐg����iCustom �֐�
                       ��������ϐ�*/
double BB_Upper_1 = 0; /*1 �{�O�̃o�[�̏�o���h�ɕϐg����iCustom �֐�
                       ��������ϐ�*/
double BB_Lower_1 = 0; /*1 �{�O�̃o�[�̉��o���h�ɕϐg����iCustom �֐�
                       ��������ϐ�*/
double RSI_2 = 0; /*2 �{�O�̃o�[��RSI �ɕϐg����iCustom �֐���������
                  �ϐ�*/
double RSI_1 = 0; /*1 �{�O�̃o�[��RSI �ɕϐg����iCustom �֐���������
                  �ϐ�*/

int start()
{

   BB_Upper_2 = iCustom(NULL,0,"Bands",BandsPeriod,
                            BandsShift,BandsDeviations,1,2);
   BB_Lower_2 = iCustom(NULL,0,"Bands",BandsPeriod,
                            BandsShift,BandsDeviations,2,2);
   BB_Upper_1 = iCustom(NULL,0,"Bands",BandsPeriod,
                            BandsShift,BandsDeviations,1,1);
   BB_Lower_1 = iCustom(NULL,0,"Bands",BandsPeriod,
                            BandsShift,BandsDeviations,2,1);
                            
   RSI_2 = iCustom(NULL,0,"RSI",RSIPeriod,0,2);
   RSI_1 = iCustom(NULL,0,"RSI",RSIPeriod,0,1);
   
   
   // �����|�W�V�����̃G�O�W�b�g
   if(   ( BB_Upper_1 < Close[1] && RSI_2 < 70 && RSI_1 >= 70 )
      || ( BB_Upper_2 >= Close[2] && BB_Upper_1 < Close[1] && RSI_1 >= 70)
      && ( Ticket_L != 0 && Ticket_L != -1 ))
      {
         Exit_L = OrderClose(Ticket_L,Lots,Bid,Slip,Red);
         if( Exit_L == 1 ) {Ticket_L = 0;}
      }
      
   // ����|�W�V�����̃G�O�W�b�g
   if(   ( BB_Lower_1 > Close[1] && RSI_2 > 30 && RSI_1 <= 30 )
      || ( BB_Lower_2 <= Close[2] && BB_Lower_1 > Close[1] && RSI_1 <= 30)
      && ( Ticket_S != 0 && Ticket_S != -1 ))
      {
         Exit_S = OrderClose(Ticket_S,Lots,Ask,Slip,Blue);
         if( Exit_S == 1 ) {Ticket_S = 0;}
      }
      
   // �����G���g���[
   if(   ( BB_Lower_1 > Close[1] && RSI_2 > 30 && RSI_1 <= 30 )
      || ( BB_Lower_2 <= Close[2] && BB_Lower_1 > Close[1] && RSI_1 <= 30)
      && ( Ticket_L == 0 || Ticket_L == -1 )
      && ( Ticket_S == 0 || Ticket_S == -1 ))
      {
         Ticket_L = OrderSend(Symbol(),OP_BUY,
         Lots,Ask,Slip,0,0,Comments,MAGIC,0,Red);
      }
      
   // ����G���g���[
   if(   ( BB_Upper_1 < Close[1] && RSI_2 < 70 && RSI_1 >= 70 )
      || ( BB_Upper_2 >= Close[2] && BB_Upper_1 < Close[1] && RSI_1 >= 70)
      && ( Ticket_S == 0 || Ticket_S == -1 )
      && ( Ticket_L == 0 || Ticket_L == -1 ))
      {
         Ticket_S = OrderSend(Symbol(),OP_SELL,
         Lots,Bid,Slip,0,0,Comments,MAGIC,0,Blue);
      }
   
return(0);
}