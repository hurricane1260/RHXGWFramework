//
//  RevenueItemView.h
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2018/3/29.
//

#import <UIKit/UIKit.h>



typedef void(^ItemViewHBlock)(NSInteger height);

@interface RevenueItemView : UIView

@property (nonatomic,copy)ItemViewHBlock itemViewH;

- (instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image;


@end
