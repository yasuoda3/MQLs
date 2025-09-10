
// �}�W�b�N�i���o�[�̒�`
#define MAGIC 3986

// �p�����[�^�[�̐ݒ�//
extern int BandsPeriod = 20; // �{�����W���[�o���h�̊��Ԑݒ�
extern int BandsShift = 0; // �{�����W���[�o���h���E�ɃV�t�g����ݒ�
extern double BandsDeviations = 2.0; // �W���΍��̐ݒ�

extern double Lots = 1.0; // ������b�g��
extern int Slip = 10; // ���e�X���b�y�[�W��
extern string Comments = " "; // �R�����g

// �ϐ��̐ݒ�//
int Ticket_L = 0; // ���������̌��ʂ��L���b�`����ϐ�
int Ticket_S = 0; // ���蒍���̌��ʂ��L���b�`����ϐ�
int Exit_L = 0; // �����|�W�V�����̌��ϒ����̌��ʂ��L���b�`����ϐ�
int Exit_S = 0; // ����|�W�V�����̌��ϒ����̌��ʂ��L���b�`����ϐ�


int start()
{

   // �����|�W�V�����̃G�O�W�b�g
   if(   iCustom(NULL,0,"Bands",BandsPeriod,BandsShift,BandsDeviations,1,2) >= Close[2]
      && iCustom(NULL,0,"Bands",BandsPeriod,BandsShift,BandsDeviations,1,1) < Close[1]
      && ( Ticket_L != 0 && Ticket_L != -1 ))
      {
         Exit_L = OrderClose(Ticket_L,Lots,Bid,Slip,Red);
         if( Exit_L == 1 ) {Ticket_L = 0;}
      }
      
   // ����|�W�V�����̃G�O�W�b�g
   if(   iCustom(NULL,0,"Bands",BandsPeriod,BandsShift,BandsDeviations,2,2) <= Close[2]
      && iCustom(NULL,0,"Bands",BandsPeriod,BandsShift,BandsDeviations,2,1) > Close[1]
      && ( Ticket_S != 0 && Ticket_S != -1 ))
      {
         Exit_S = OrderClose(Ticket_S,Lots,Ask,Slip,Blue);
         if( Exit_S == 1 ) {Ticket_S = 0;}
      }
      
   // �����G���g���[
   if(   iCustom(NULL,0,"Bands",BandsPeriod,BandsShift,BandsDeviations,2,2) <= Close[2]
      && iCustom(NULL,0,"Bands",BandsPeriod,BandsShift,BandsDeviations,2,1) > Close[1]
      && ( Ticket_L == 0 || Ticket_L == -1 )
      && ( Ticket_S == 0 || Ticket_S == -1 ))
      {
         Ticket_L = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip,0,0, Comments,MAGIC,0,Red);
      }
      
   // ����G���g���[
   if(   iCustom(NULL,0,"Bands",BandsPeriod,BandsShift,BandsDeviations,1,2) >= Close[2]
      && iCustom(NULL,0,"Bands",BandsPeriod,BandsShift,BandsDeviations,1,1) < Close[1]
      && ( Ticket_S == 0 || Ticket_S == -1 )
      && ( Ticket_L == 0 || Ticket_L == -1 ))
      {
         Ticket_S = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip,0,0,Comments,MAGIC,0,Blue);
      }
      
return(0);
}