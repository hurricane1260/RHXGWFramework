//
//  TradeDataStore.h
//  stockscontest
//
//  Created by rxhui on 15/6/11.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  存储账号

#import <Foundation/Foundation.h>

@interface TradeDataStore : NSObject

-(void)saveHcAccountWithAccountNumber:(NSString *)accountNumber;

-(NSString *)loadHcAccountNumber;

@end
