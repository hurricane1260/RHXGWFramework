//
//  HistoryRecordVO.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/27.
//
//

#import "RHBaseVO.h"

@interface HistoryRecordVO : RHBaseVO

@property (nonatomic,strong)NSNumber * currentPage;
@property (nonatomic,strong)NSNumber * pageSize;
@property (nonatomic,assign)BOOL  hasNextPage;
@property (nonatomic,strong)NSArray * data;
@end


@interface HistoryRecordListVO : RHBaseVO
/**转账金额*/
@property (nonatomic,strong)NSNumber * clearBalance;
/**转账类型*/
@property (nonatomic,copy)NSString * flagName;
/**转账时间*/
@property (nonatomic,strong)NSNumber * tradeDate;

@end
