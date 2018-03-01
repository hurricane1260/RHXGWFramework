//
//  CustomNumberView.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/5/4.
//
//

#import <UIKit/UIKit.h>
typedef void (^openBtnBlock)(NSString *number);

@interface CustomNumberView : UIView
@property (nonatomic,copy)NSString * numberText;
@property (nonatomic,copy)openBtnBlock openBlock;

@end
