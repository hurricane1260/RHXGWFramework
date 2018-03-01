//
//  BankInfo.h
//  EXOCR
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//是否展示logo
#define DISPLAY_LOGO_BANK 1
//是否过滤银行
#define FILTER_BANK 0

#define PROMPT_DEFAULT      @"请将扫描线对准银行卡号"
#define PROMPT_NOT_SUPPORT  @"暂不支持此类银行卡！"
#define SUPPORT_INFO        @"本技术由易道博识提供"

@interface BankInfo : NSObject

@property (nonatomic, retain) NSString *bankName;   //银行名称
@property (nonatomic, retain) NSString *cardName;   //卡名称
@property (nonatomic, retain) NSString *cardType;   //卡类型
@property (nonatomic, retain) NSString *cardNum;    //卡号
@property (nonatomic, retain) NSString *validDate;  //有限期

@property UIImage* fullImg;
@property UIImage* cardNumImg;

-(NSString *)toString;
-(BOOL)isOK;

//卡号是否需要空格
+(BOOL) getSpaceWithBANKCardNum;
+(void) setSpaceWithBANKCardNum:(BOOL)bSpace;
//是否显示结果页
+(BOOL) getNoShowBANKResultView;
+(void) setNoShowBANKResultView:(BOOL)bShow;
//是否显示银行名称
+(BOOL) getNoShowBANKBankName;
+(void) setNoShowBANKBankName:(BOOL)bShow;
//是否显示卡名称
+(BOOL) getNoShowBANKCardName;
+(void) setNoShowBANKCardName:(BOOL)bShow;
//是否显示卡类型
+(BOOL) getNoShowBANKCardType;
+(void) setNoShowBANKCardType:(BOOL)bShow;
//是否显示卡号
+(BOOL) getNoShowBANKCardNum;
+(void) setNoShowBANKCardNum:(BOOL)bShow;
//是否显示有效期
+(BOOL) getNoShowBANKValidDate;
+(void) setNoShowBANKValidDate:(BOOL)bShow;
//是否显示卡号截图
+(BOOL) getNoShowBANKCardNumImg;
+(void) setNoShowBANKCardNumImg:(BOOL)bShow;

@end
