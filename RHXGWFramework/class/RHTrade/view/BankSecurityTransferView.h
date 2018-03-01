//
//  BankSecurityTransferView.h
//  stockscontest
//
//  Created by rxhui on 15/7/14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BankSecurityTransferDelegate <NSObject>

-(void)comitTransferWithParam:(NSDictionary *)param;

//-(void)requestBankMoneyWithParam:(NSMutableDictionary *)param;

- (void)popRemindBankInfo;

@end

@interface BankSecurityTransferView : UIScrollView

@property (nonatomic, weak) id <BankSecurityTransferDelegate> transDelegate;

/*! @brief 银行名称 */
@property (nonatomic, copy) NSString *bankName;

/*! @brief 证券转银行，可用资金 */
@property (nonatomic, copy) NSNumber *canTransferMoney;

/*! @brief 银行转证券，银行资金 */
@property (nonatomic, copy) NSNumber *bankMoney;

@property (nonatomic, copy) NSString *fundPassword;

@property (nonatomic, copy) NSString *bankPassword;

-(void)hideKeyboard;

@end
