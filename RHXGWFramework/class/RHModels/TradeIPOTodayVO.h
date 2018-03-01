//
//  TradeIPOTodayVO.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/14.
//
//

#import "RHBaseVO.h"

@interface TradeIPOTodayVO : RHBaseVO

//今日新股信息
/**
 *    交易类别
 */
kRhPCopy NSString * exchangeType;

/**
 *    证券类别
 */
kRhPCopy NSString * stockType;

/**
 *    最新价
 */
kRhPCopy NSNumber * lastPrice;

/**
 *    股票名称
 */
kRhPCopy NSString * stockName;

/**
 *    申购名称
 */
kRhPCopy NSString * stockCode;

/**
 *    新股申购额度
 */
kRhPStrong NSNumber * enableAmount;

/**
 *    是否已申购
 */
kRhPStrong NSNumber * entrusted;

/**
 *    交易最高数量
 */
kRhPStrong NSNumber * highAmount;

/**
 *    交易最低数量
 */
kRhPStrong NSNumber * lowAmount;


/**
 *    申购数量
 */
kRhPStrong NSNumber * applyAmount;

//以下为中签查询信息
/**
 *    成交价格
 */
kRhPStrong NSNumber * businessPrice;

/**
 *    成交数量
 */
kRhPStrong NSNumber * businessAmount;

/**
 *    申购日期
 */
kRhPStrong NSNumber * businessDate;


/**
 *    配号
 */
kRhPStrong NSNumber * beginIssueNo;

/**
 *    配号中签数量
 */
kRhPStrong NSNumber * occurAmount;

/**
 *    区别数据  @“match” 配号  @“lucky” 中签
 */
kRhPCopy NSString * type;

/**
    市盈率
 */
kRhPCopy NSNumber * peRatio;

kRhPAssign NSInteger index;

kRhPStrong NSNumber * serverTime;

/**
 *    中签公告发布状态, 0未发布，1已发布
 */
kRhPStrong NSNumber * issueStatus;
@end
