//
//  CusstomerServiceBottomView.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/5/4.
//
//

#import <UIKit/UIKit.h>
#import "CustomerServiceMidView.h"

@interface CusstomerServiceBottomView : UIView
@property (nonatomic,copy)tapBlock tapBlock;

@property (copy, nonatomic) void (^commonMistakeLbBlock)(void);
@end
