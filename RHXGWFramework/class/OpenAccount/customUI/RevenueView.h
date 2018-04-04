//
//  RevenueView.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2018/3/29.
// 个人信息确认页下面的  仅为中国税收居民的View

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Resident=1,
    notResident,
    otherResident,
} ResidentType;


typedef void(^revenueViewBlock)(NSInteger height);
typedef void(^clickBtnBlock)(void);
typedef void(^revenueItemBlock)(ResidentType type);


@interface RevenueView : UIView

@property (nonatomic,copy)revenueViewBlock heightBlock;
@property (nonatomic,copy)clickBtnBlock btnBlock;
@property (nonatomic,assign)BOOL isSelectBtn;
@property (nonatomic,assign)ResidentType residentType;
@property (nonatomic,copy)revenueItemBlock itemBlock;

@end
