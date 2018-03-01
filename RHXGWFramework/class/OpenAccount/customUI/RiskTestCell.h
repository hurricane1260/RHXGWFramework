//
//  RiskTestCell.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/3.
//
//

#import <UIKit/UIKit.h>

#import "ITableCellItemView.h"

typedef enum :NSInteger{
    AgeType = 1,//点击年龄选项
    EducationType,//点击学历选项
    
}ChooseType;

typedef void (^ChooseTypeBlock)(ChooseType type);
typedef void (^AutomaticJump)(NSString * subjectIndex,NSString * type);

@interface RiskTestCell : UITableViewCell<ITableCellItemView>

kRhPCopy ButtonCallBackWithParams cellHeightBlock;
kRhPCopy ButtonCallBackWithParams riskTestBlock;
kRhPCopy ChooseTypeBlock promptBlock;
/**自动跳转到下一题*/
kRhPCopy AutomaticJump automaticJump;
kRhPAssign ChooseType chooseType;

kRhPStrong NSDictionary * defaultResultDic;
-(void)setDefaultSelectWithModel:(id)model defaultResultDic:(NSDictionary *)defaultResultDic;
- (void)setAgeEducationWithModel:(id)model  AgeEducationDic:(NSDictionary *)ageEducationDic;
-(void)loadDataWithModel:(id)model withIndexPath:(NSInteger)row defaultResultDic:(NSDictionary *)defaultResultDic;
@end
