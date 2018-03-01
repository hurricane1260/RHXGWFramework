//
//  TradeIPOTodayVO.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/14.
//
//

#import "TradeIPOTodayVO.h"

@implementation TradeIPOTodayVO

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"issueDate"]) {
        self.businessDate = value;
    }
    else if([key isEqualToString:@"initDate"]){
        self.businessDate = value;
    }
}

@end
