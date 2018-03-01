//
//  RankViewVO.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-23.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "RankViewVO.h"
#import "PositionVO.h"

@implementation RankViewVO

+(NSArray *)parsePojoEntityListToViewEntityList:(NSArray *)pojoEntityList withOrderFieldName:(NSString *)orderFieldName{
    NSMutableArray *viewEntityList = [NSMutableArray arrayWithCapacity:pojoEntityList.count];
    
    for(RankVO *rank in pojoEntityList){
        RankViewVO *viewVO = [RankViewVO parsePojoEntityToViewEntity:rank withOrderFieldName:orderFieldName];
        
        [viewEntityList addObject:viewVO];
    }
    
    return viewEntityList;
}

+(RankViewVO *)parsePojoEntityToViewEntity:(RankVO *)rankvo withOrderFieldName:(NSString *)orderFieldName{
    RankViewVO *viewVO = [[RankViewVO alloc] init];
    
    NSNumber *profit = [rankvo valueForKey:orderFieldName];
    NSString *prefix = @"";
    UIColor *profitColor = color3_text_xgw;
    if(profit.doubleValue > 0){
        prefix = @"+";
        profitColor = color6_text_xgw;
    }else if(profit.doubleValue < 0){
        prefix = @"";
        profitColor = color7_text_xgw;
    }else{
        prefix = @"";
        profitColor = color3_text_xgw;
    }
    NSString *formatString = [NSString formatDecimalStyleWith:profit withSuffix:@"%" maximumFractionDigits:2];
    NSString *profitString = [NSString stringWithFormat:@"%@%@", prefix, formatString];
    
    viewVO.visibleRate = profitString;
    viewVO.profitColor = profitColor;
    viewVO.nickName = rankvo.nickName;
    viewVO.userID = [NSString stringWithFormat:@"%@", rankvo.userID];
    viewVO.rankNumber = rankvo.ranking;
    viewVO.fansNumber = rankvo.fansNumber;
    
    return viewVO;
}

+ (RankViewVO *)parseSimulateCombinationVOWith:(NSDictionary *)itemVO index:(NSInteger)index{
    RankViewVO *rankVO = [[RankViewVO alloc]init];
    rankVO.nickName = [itemVO objectForKey:@"nickName"];
    //持仓描述
    NSArray *stockData = [itemVO objectForKey:@"stocks"];
    NSArray *stockList = [NSObject parseJsonToModelList:stockData listItemClass:[PositionVO class]];
    NSString *posiDesc = @"";
    for(NSUInteger i=0; i<stockList.count; i++){
        if(i == 2){
            break;
        }
        
        PositionVO *posiVO = [stockList objectAtIndex:i];
        posiDesc = [posiDesc stringByAppendingFormat:@" %@", posiVO.stockName];
    }
    if(posiDesc.length == 0){
        posiDesc = @"无持仓空";
        rankVO.positionColor = color6_text_xgw;
    }else{
        rankVO.positionColor = color4_text_xgw;
    }
    rankVO.positionDesc = posiDesc;
    //收益率
    NSString *profit = [itemVO objectForKey:@"totalProfit"];
//    NSString *prefix = @"";
//    if(profit.doubleValue > 0){
//        prefix = @"+";
//    }else if(profit.doubleValue < 0){
//        prefix = @"-";
//    }else{
//        prefix = @"";
//    }
    NSNumber *profitNum = [NSNumber numberWithDouble:profit.doubleValue * 100];
    NSString *formatString = [NSString formatDecimalStyleWith:profitNum withSuffix:@"%" maximumFractionDigits:2];
//    NSString *profitString = [NSString stringWithFormat:@"%@%@", prefix, formatString];
    rankVO.visibleRate = formatString;
    //        rankVO.rankNumber = [itemVO objectForKey:@"rank"];//rank是空的，用i
    rankVO.rankNumber = [NSString stringWithFormat:@"%ld",(long)index + 1];
    rankVO.accountPro = @"0";
    rankVO.userID = [itemVO objectForKey:@"weiboId"];
    rankVO.accountId = [itemVO objectForKey:@"accountId"];
    rankVO.fansNumber = [itemVO objectForKey:@"fans"];
    rankVO.currentAutoFollowsNumber = [itemVO objectForKey:@"followedNum"];
    return rankVO;
}

@end
