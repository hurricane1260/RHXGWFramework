//
//  HistoryTreadVO.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/28.
//
//

#import "RHBaseVO.h"

@interface HistoryTreadVO : RHBaseVO
@property (nonatomic,strong)NSNumber * currentPage;
@property (nonatomic,strong)NSNumber * pageSize;
@property (nonatomic,assign)BOOL  hasNextPage;
@property (nonatomic,strong)NSArray * data;

@end

@interface HistoryTreadListVO : RHBaseVO
/**股票名称*/
@property (nonatomic,copy)NSString * stockName;
/**买卖方向*/
@property (nonatomic,copy)NSString * mark;
/**委托交易时间*/
@property (nonatomic,strong)NSNumber * tradeDate;
/**成交价*/
@property (nonatomic,strong)NSNumber * businessPrice;
/**成交量*/
@property (nonatomic,strong)NSNumber * businessAmount;
/**成交额*/
@property (nonatomic,strong)NSNumber * businessBalance;
/**手续费*/
@property (nonatomic,strong)NSNumber * fare0;
/**印花税*/
@property (nonatomic,strong)NSNumber * fare1;
/**结算费*/
@property (nonatomic,strong)NSNumber * fare2;
/**备注*/
@property (nonatomic,strong)NSNumber * name;



@end
