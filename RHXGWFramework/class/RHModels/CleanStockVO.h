//
//  CleanStockVO.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/25.
//
//

#import "RHBaseVO.h"

@interface CleanStockVO : RHBaseVO
/**股票代码*/
@property (nonatomic,copy)NSString * stockCode;
/**股票名称*/
@property (nonatomic,copy)NSString * stockName;
/**持股时间*/
@property (nonatomic,strong)NSNumber * holdMinDate;
/**持股天数*/
@property (nonatomic,copy)NSNumber * holdTime;
/**盈亏额*/
@property (nonatomic,strong)NSNumber * profit;
/**盈亏比*/
@property (nonatomic,strong)NSNumber * profitYld;
/**累计收入*/
@property (nonatomic,strong)NSNumber * totalBalan1;
/**累计投入*/
@property (nonatomic,strong)NSNumber * totalBalan2;
/**交易费用*/
@property (nonatomic,strong)NSNumber * fare;
/**股票操作区间开始*/
@property (nonatomic, strong)NSNumber * interBegin;
/**股票操作区间结束*/
@property (nonatomic, strong)NSNumber * interEnd;

@end

@interface CleanStocksListVO : RHBaseVO
/**当前页*/
@property (nonatomic,strong)NSNumber * currentPage;
/**每页的大小*/
@property (nonatomic,strong)NSNumber * pageSize;
/**是否有下一页*/
@property (nonatomic,assign)BOOL hasNextPage;
/**对账单数据*/
@property (nonatomic,strong)NSArray * data;

@end
