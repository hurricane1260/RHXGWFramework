//
//  TradeIPOWeekVO.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/13.
//
//

#import <Foundation/Foundation.h>
#import "RHBaseVO.h"

@interface TradeIPOWeekVO : RHBaseVO

//未来一周
kRhPCopy NSString * stockCode;

kRhPCopy NSString * stockName;

kRhPCopy NSString * applyDate;

kRhPCopy NSNumber * personAmount;

kRhPCopy NSNumber * price;

kRhPCopy NSNumber * peRatio;

kRhPCopy NSNumber * type;

@end
