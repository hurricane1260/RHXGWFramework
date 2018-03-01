//
//  PlaceholderView.h
//  stockscontest
//
//  Created by liyan on 15/12/30.
//  Copyright © 2015年 方海龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderView : UIView

kRhPCopy ButtonCommonCallBack btnCallBlock;

- (instancetype)initPlaceHolderViewWithCGRect:(CGRect)rect WithImage:(UIImage*)image WithTitle:(NSString *)title;

- (instancetype)initPlaceHolderViewWithCGRect:(CGRect)rect WithImage:(UIImage*)image WithTitle:(NSString *)title withSubTitle:(NSString *)subTitle;
@end
