//
//  CRHOpenAccResultVo.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/12.
//
//

#import "RHBaseVO.h"
#import "CRHAccVo.h"

@interface CRHOpenAccResultVo : RHBaseVO

/**
 资金账号
 */
kRhPStrong CRHAccVo * fund_account;

/**
 银行账号
 */
kRhPStrong NSArray<CRHAccVo*> * bank_account;

/**
 基金账号
 */
kRhPStrong NSArray<CRHAccVo*> * ofstock_account;

/**
 股东账号
 */
kRhPStrong NSArray<CRHAccVo*> * stock_account;

kRhPCopy NSString * client_id;
@end
