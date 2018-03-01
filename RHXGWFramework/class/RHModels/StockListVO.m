//
//  StockListVO.m
//  stockscontest
//
//  Created by rxhui on 15/6/16.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "StockListVO.h"

@implementation StockListVO

+(StockListVO *)parseVOFromData:(id)data {
    StockListVO *itemVO = [NSObject parseJsonToModel:data targetClass:[StockListVO class]];
//    if (itemVO.costPrice.integerValue == 0 ) {
//        itemVO.incomeBalance = @0;
//    }
//    else {
//        itemVO.incomeBalance = [NSNumber numberWithDouble:(itemVO.lastPrice.doubleValue  - itemVO.costPrice.doubleValue )  * itemVO.currentAmount.doubleValue];
//    }
    
    /*
    //盈亏率=盈亏/(成本价*持股数量)*100%
    if (itemVO.costPrice.doubleValue * itemVO.currentAmount.doubleValue < 0.01 && itemVO.costPrice.doubleValue * itemVO.currentAmount.doubleValue > -0.01) {
        NSLog(@"错误！持仓或成本价为0");
    }
    
    double rate = itemVO.incomeBalance.doubleValue / (itemVO.costPrice.doubleValue * itemVO.currentAmount.doubleValue) * 100.0f;
    NSString *rateString = [NSString stringWithFormat:@"%.3f%@",rate,@"%"];
    NSString *incomeString = [NSString stringWithFormat:@"(盈亏%.2f/%@)",itemVO.incomeBalance.floatValue,rateString];
    NSMutableAttributedString *mutaIncomeString = [[NSMutableAttributedString alloc]initWithString:incomeString];
    UIColor *stringColor = nil;
    if (itemVO.incomeBalance.doubleValue > 0.01) {
        stringColor = color6_text_xgw;
    }
    else if (itemVO.incomeBalance.doubleValue < -0.01){
        stringColor = color7_text_xgw;
    }
    else {
        stringColor = color2_text_xgw;
    }
    [mutaIncomeString addAttribute:NSForegroundColorAttributeName value:stringColor range:NSMakeRange(0, incomeString.length)];
    
    itemVO.incomeBalanceString = mutaIncomeString.copy;
     */
    return itemVO;
}

+ (NSMutableArray *)parseSimulateHoldStockFromData:(id)data {
    NSMutableArray *returnList = [NSMutableArray array];
    for (NSDictionary *itemDic in data) {
        StockListVO *itemVO = [[StockListVO alloc]init];
        itemVO.stockName = [itemDic objectForKey:@"stockName"];
        itemVO.stockCode = [itemDic objectForKey:@"stockCode"];
        itemVO.incomeBalance = [itemDic objectForKey:@"stockFloatProfit"];
        itemVO.lastPrice = [itemDic objectForKey:@"latestPrice"];
        itemVO.costPrice = [itemDic objectForKey:@"costPrice"];
        itemVO.currentAmount = [itemDic objectForKey:@"vol"];
        itemVO.marketValue = [NSNumber numberWithDouble:itemVO.currentAmount.doubleValue * itemVO.lastPrice.doubleValue];
        [returnList addObject:itemVO];
    }
    return returnList;
}

@end
