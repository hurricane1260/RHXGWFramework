/************************************************************************\
�����׵���ʶ�Ƽ����޹�˾
CopyRight (C) 2015

File name: exbankcard.h
  Function : ���п�ʶ��ӿ��ļ�
  Author   : zjm@exocr.com
  Version  : 2015.11.04	V2.0
***************************************************************************/

#ifndef __EX_BANK_CARD_H__
#define __EX_BANK_CARD_H__

#ifdef __cplusplus
extern "C" {
#endif

//��Ƶ��ʶ��ʱ�ĸ�����
#define EX_ORIENTATION_LANDSCAPE_LEFT			1
#define EX_ORIENTATION_LANDSCAPE_RIGHT			2
#define EX_ORIENTATION_PORTRAIT					3
#define EX_ORIENTATION_PORTRAIT_UPSIDE_DOWN		4


//////////////////////////////////////////////////////////////////////////
//����ID
#define CREDIT_BANK_ID_UNKNOW				0x0000	//���ÿ�δ֪
#define CREDIT_BANK_ID_CHINA_UNION_PAY		0x0001	//����
#define CREDIT_BANK_ID_VISA					0x0002	//visa
#define CREDIT_BANK_ID_MASTER				0x0003  //master
#define CREDIT_BANK_ID_JCB					0x0004  //JCB
#define CREDIT_BANK_ID_AMERICAN_EXPRESS		0x0005  //American Experss
#define CREDIT_BANK_ID_DINERS_CLUB			0x0006  //Diners Club

//////////////////////////////////////////////////////////////////////////
/* ���ַ���Ϣ */
typedef struct tagEXChar
{
	short nCharIdx; //��������
	short nLft;
	short nTop; 
	short nW;
	short nH;
	unsigned short wCand;
	unsigned short wDist;
	float fDist;	
}TEXChar;

//////////////////////////////////////////////////////////////////////////
/* ���п���Ϣ */
typedef struct tagEXBCard
{
	int nType; // 0 �������1ƽ�֣�2͹��
	//ƽ�����Ŷ�
	int nRate; //�ַ���ƽ�����Ŷ�*1024
	//��������
	char szBankName[64];
	//������
	char szCardName[32];
	//�����ͣ���ǿ� ׼���ǿ��ʹ��ǿ� Ԥ����
	char szCardType[32];
	//�������ֵ���1-12
	int expiryMonth;
	//4�����ֵ���
	int expiryYear;
	//�Ƿ��ǵ���ʶ��Ľ��
	int bFlip;
	//////////////////////////////////////////////////////////////////////////
	//���п���Ϣ�������ո�
	int nNumCount;
	TEXChar ZInfo[32];	
	//////////////////////////////////////////////////////////////////////////
	//��Ч������Ϣ
	int nDateNum;
	TEXChar DInof[10];
	//////////////////////////////////////////////////////////////////////////
	//��ͼ��(�������ʹ��)����ʽ��BGR�洢�����������ǻҶ�ͼ��Ҳ�Ǵ洢�������
	//ͼ�����ݿ��Ը�����Ҫ����������������ݸ�ʽ, 
	unsigned char *pbCard;
	int nW, nH, nPitch;
}TEXBCard;

//////////////////////////////////////////////////////////////////////////
//�ӿں���
//////////////////////////////////////////////////////////////////////////
//ȡ�ð汾��
const char *BankCardGetVersion();
// ��ͼ��ʶ��ӿڣ�����ʶ�������ӿ�ʹ��
int BankCardRecoFile(const char *szImgFile, unsigned char *pbResult, int nMaxSize);
// 24λɫ RGB����BGRʶ��, ������ʶ��
int BankCard24(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg24, int iW, int iH, int iPitch, int iLft, int iTop, int iRgt, int iBtm);
// ����32(0xargb)λ��ͼ��ת��24λ��ͼ��Androidϵͳ��
int BankCard32(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg32, int iW, int iH, int iPitch, int iLft, int iTop, int iRgt, int iBtm);

// ����ImageFormat.NV21ֱ������ʶ��
int BankCardNV21(unsigned char *pbResult, int nMaxSize, unsigned char *pbY, unsigned char *pbVU, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);
// ����ImageFormat.NV12ֱ������ʶ��
int BankCardNV12(unsigned char *pbResult, int nMaxSize, unsigned char *pbY, unsigned char *pbUV, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);

//���ؽṹ�壬֧�ֶ������NV21�ӿ�V2 [10/31/2015 bomber]
// direction֧�ֵķ���
// bwantimg�Ƿ񷵻�ͼ��
// btryflip�Ƿ�֧�ֵߵ�
// �������ͼ����excard����ͼ����Ҫ����BankCardFreeST�����ͷ�
int BankCardNV21ST(TEXBCard *excard, unsigned char *pbY, unsigned char *pbVU, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm, 
				   int direction, int bwantimg, int btryflip);
//���ؽṹ�壬֧�ֶ������NV12�ӿ�V2 [10/31/2015 bomber]
// direction֧�ֵķ���
// bwantimg�Ƿ񷵻�ͼ��
// btryflip�Ƿ�֧�ֵߵ�
// �������ͼ����excard����ͼ����Ҫ����BankCardFreeST�����ͷ�
int BankCardNV12ST(TEXBCard *excard, unsigned char *pbY, unsigned char *pbUV, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm,
				   int direction, int bwantimg, int btryflip);

// ��ȡ�Խ�����
float GetFocusScore(unsigned char *imgdata, int width, int height, int pitch, int lft, int top, int rgt, int btm);
// �����ת��Ϊ�ֽ���
int ZInfo2ZStream(unsigned char *pbResult, int nMaxSize, TEXBCard *excard);
// �ڶ����汾������������Ϣ
int ZInfo2ZStreamV2(unsigned char *pbResult, int nMaxSize, TEXBCard *excard);


// �ڴ��ͷź��������ȷ������ͼ��
int BankCardFreeST(TEXBCard *pstCard);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ͼƬʶ��ӿڣ�����ͼ��pbImage, ��׼��ͼ�����ݸ���
// ֧��ͼ�����ͻҶ�  GRAY  nBitCount = 8
// ֧��ͼ�����Ͳ�ɫ  BGR24 nBitCount = 24
int BankCardRecognizeImage(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int nBitCount, int bTryHarder, int bWantImg, TEXBCard *pstCard);
//////////////////////////////////////////////////////////////////////////
// �Ǳ�׼ͼ��ӿڣ����ñ�׼ͼ��ӿ�
// RGBA32λͼ��ʶ�� Android, IOS
int BankCardRecognizeImageRGBA32(unsigned char *pbImage, int nWidth, int nHeight, int nPitch, int bTryHarder, int bWantImg, TEXBCard *pstCard);

//////////////////////////////////////////////////////////////////////////
// ���ļ�ʶ��ӿ�, ���ؽṹ�壬����Ҫ�󷵻�ͼ��
int BankCardRecoFileImageSTAPI(const char *szImgFile, int bTryHarder, int bWantImg, TEXBCard *pstCard);
//////////////////////////////////////////////////////////////////////////
// ���ļ�ʶ��ӿڣ������ֽ�����ZInfo2ZStreamV2
int BankCardRecoFileImageAPI(const char *szImgFile, unsigned char *pbResult, int nMaxSize);
//////////////////////////////////////////////////////////////////////////
//���ڴ�����Ŀ��������Ϊָ����ʽ��pbImage�ڴ��ⲿ����
int BankCardConvert2BGRA(TEXBCard *pstCard, unsigned char *pbImage, int width, int height, int stride);
//���ڴ�����Ŀ��������Ϊָ����ʽ��pbImage�ڴ��ⲿ����
int BankCardConvert2RGBA(TEXBCard *pstCard, unsigned char *pbImage, int width, int height, int stride);
//���ڴ�����Ŀ��������Ϊָ����ʽ��pbImage�ڴ��ⲿ����
int BankCardConvert2ABGR(TEXBCard *pstCard, unsigned char *pbImage, int width, int height, int stride);

//////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
}
#endif

#endif //__EX_BANK_CARD_H__