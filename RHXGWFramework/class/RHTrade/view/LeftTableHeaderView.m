//
//  LeftTableHeaderView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/19.
//
//

#import "LeftTableHeaderView.h"
@interface LeftTableHeaderView ()
@property (nonatomic,strong)UILabel * titleLb;

@end
@implementation LeftTableHeaderView
-(instancetype)init{
    
    if (self = [super init]) {
        
        [self initSubViews];
        
    }
    return self;
    
}
-(void)initSubViews{
    self.titleLb = [UILabel didBuildLabelWithText:@"委托时间" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.titleLb];
    
    [self addAutoLineWithColor:color16_other_xgw];

    
    
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb sizeToFit];
    self.titleLb.center = CGPointMake(24+self.titleLb.size.width/2, self.size.height/2);
    
    self.autoLine.frame = CGRectMake(0, self.size.height-1, self.size.width, 1);
    
    
}
@end
