//
//  RiskTableViewDataSource.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/5.
//
//

#import "RHBaseTabDataSource.h"
#import "RiskTestCell.h"
typedef enum : NSInteger{
    BlankType,//空白的试卷
    ageAndEducationType,//默认选中年龄和学历
    AllType,//用户选过的所有答案
    
    
}PaperType;

typedef void (^warnBlockBlock)(ChooseType type);
typedef void (^AutomaticSubjectJump)(NSString * subjectIndex,NSString * type);

@interface RiskTableViewDataSource : RHDataSource
@property (nonatomic,strong)NSMutableArray * rishQuestionsArray;

//储存 当前页 用户自己选择的 题号和答案的字典
kRhPStrong  NSMutableDictionary * riskTestDic;
//控制下一步按钮的状态
kRhPCopy ButtonCallBackWithParams riskTestNextBlock;
//提示Block
kRhPCopy warnBlockBlock warnBlock;
//储存 用户已经答过题的答案
kRhPStrong  NSMutableDictionary * defaultResultDic;
//储存 用户的年龄和学历的答案
kRhPStrong  NSMutableDictionary * ageEducationDic;
//储存 每个cell的高度
kRhPStrong NSMutableDictionary * cellHeightDic;

kRhPAssign PaperType paperType;
kRhPCopy AutomaticSubjectJump automaticSubjectJump;

@end
