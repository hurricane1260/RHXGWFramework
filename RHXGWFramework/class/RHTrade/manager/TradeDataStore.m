//
//  TradeDataStore.m
//  stockscontest
//
//  Created by rxhui on 15/6/11.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeDataStore.h"

@interface TradeDataStore ()

@property (nonatomic, readonly) NSString *hcAccountStorePath;

@end

@implementation TradeDataStore

@synthesize hcAccountStorePath = _hcAccountStorePath;
-(NSString *)hcAccountStorePath {
    NSArray *docuemntPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [docuemntPaths objectAtIndex:0];
    _hcAccountStorePath = [documentPath stringByAppendingPathComponent:@"hcAccount.data"];
    
    return _hcAccountStorePath;
}

-(void)saveHcAccountWithAccountNumber:(NSString *)accountNumber {
    if (!accountNumber) {
        return;
    }
    [NSKeyedArchiver archiveRootObject:accountNumber toFile:self.hcAccountStorePath];
}

-(NSString *)loadHcAccountNumber{
    NSString *accountNumber = [NSKeyedUnarchiver unarchiveObjectWithFile:self.hcAccountStorePath];
    return accountNumber;
}

@end
