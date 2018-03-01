//
//  RevisitTableDataSource.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/11.
//
//

#import "RHDataSource.h"

@interface RevisitTableDataSource : RHDataSource
@property (nonatomic,strong)NSMutableArray * rishQuestionsArray;
kRhPCopy ButtonCallBackWithParams warnTipBlock;

//储存 题号和答案的字典
@property (nonatomic,strong)NSMutableDictionary * riskTestDic;
//控制下一步按钮的状态
kRhPCopy ButtonCallBackWithParams riskTestNextBlock;
@end
