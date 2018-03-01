//
//  CleanStocksTreadVO.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/26.
//
//

#import "RHBaseVO.h"

@interface CleanStocksTreadVO : RHBaseVO
/**当前页*/
@property (nonatomic,strong)NSNumber * currentPage;
/**每页的大小*/
@property (nonatomic,strong)NSNumber * pageSize;
/**是否有下一页*/
@property (nonatomic,assign)BOOL hasNextPage;
/**对账单数据*/
@property (nonatomic,strong)NSArray * data;

@end

@interface CleanStocksTreadListVO : RHBaseVO

/**交易时间*/
@property (nonatomic,strong)NSNumber * tradeDate;
/**交易类型*/
@property (nonatomic,copy) NSString * operationType;
/**成交价*/
@property (nonatomic,strong)NSNumber * businessPrice;
/**成交量*/
@property (nonatomic,strong)NSNumber * businessAmount;
/**成交额*/
@property (nonatomic,strong)NSNumber * businessBalance;


@end
