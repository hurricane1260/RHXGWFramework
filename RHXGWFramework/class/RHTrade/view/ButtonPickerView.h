//
//  CMSinglePickerView.h
//  stockscontest
//
//  Created by rxhui on 15/6/12.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//  买卖方式选择

#import <UIKit/UIKit.h>


typedef enum :NSInteger{
    
    HoldingType = 1,//仓位
    marketPriceType,//委托 市价
    
    
}ButtonPickerType;

typedef void (^ButtonPickerBlock)( ButtonPickerType type);

@protocol ButtonPickerDelegate <NSObject>

- (void)didSelectedItemWithTitle:(NSString *)titleString;

@end

@interface ButtonPickerView : UIView

@property (nonatomic, weak) id <ButtonPickerDelegate> delegate;

@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSArray *holdingList;
@property (nonatomic,copy)    ButtonPickerBlock pickerBlock;
@property (nonatomic, assign) ButtonPickerType  buttonPickerType;

//返回第一个item的title，以确定是委托还是市价
@property (nonatomic, copy) NSString *firstTitle;
@property (nonatomic, copy) NSString * leftTitle;
/**逆回购时需要把箭头图片隐藏掉  和左边的全仓半仓 视图**/
@property (nonatomic, assign)BOOL isHideImage;
@property (nonatomic, strong) UIView *leftWrapperView;


- (instancetype)initWithTitleList:(NSArray *)aList;

-(void)hideButtonList;

@end
