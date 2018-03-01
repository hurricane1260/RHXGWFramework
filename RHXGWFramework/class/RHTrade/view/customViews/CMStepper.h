//
//  CMStepper.h
//  stockscontest
//
//  Created by rxhui on 15/6/11.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMStepper;
@protocol CMStepperDelegate <NSObject>

-(void)valueChangestepper:(CMStepper *)stepper;

-(void)valueErrorStepper:(CMStepper *)stepper andLeftError:(BOOL)leftError andRightError:(BOOL)rightError;

@end

@interface CMStepper : UIView

@property (nonatomic,weak) id<CMStepperDelegate> delegate;

@property (nonatomic,assign) BOOL isStock;

@property (nonatomic,assign) BOOL isInteger;
///步长
@property (nonatomic,strong) NSDecimalNumber *step;
///当前值
@property (nonatomic,strong) NSDecimalNumber *currentValue;

@property (nonatomic,strong) NSDecimalNumber *minValue;

@property (nonatomic,strong) NSDecimalNumber *maxValue;

@property (nonatomic,strong) UIColor *skinColor;

-(void)hideKeyboard;

-(void)resetStepper;

@end
