//
//  RiskTestHeaderView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/6.
//
//

#import "RiskTestHeaderView.h"

@interface RiskTestHeaderView ()
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * promptText;
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UILabel * titleLb;
@property (nonatomic,strong)UILabel * promptTextLb;

@end

@implementation RiskTestHeaderView

-(instancetype)initRiskTestHeaderViewWithTitle:(NSString *)title andPromptText:(NSString *)promptText{
    
    if (self = [super init]) {
        _title = title;
        _promptText = promptText;
        [self initSubViews];
    }
    
    return self;
}
-(void)initSubViews{
   
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(24, 20, 2, 18)];
    self.lineView.backgroundColor = [UIColor redColor];
    [self addSubview:self.lineView];
    
    self.titleLb = [UILabel didBuildLabelWithText:self.title font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.titleLb];
    self.promptTextLb = [UILabel didBuildLabelWithText:self.promptText font:font1_common_xgw textColor:color5_text_xgw wordWrap:NO];
    [self addSubview:self.promptTextLb];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLb sizeToFit];
    self.titleLb.center = CGPointMake(CGRectGetMaxX(self.lineView.frame)+8+self.titleLb.self.width/2, self.lineView.center.y);
    [self.promptTextLb sizeToFit];
    self.promptTextLb.center = CGPointMake(CGRectGetMaxX(self.titleLb.frame)+10+self.promptTextLb.size.width/2, self.titleLb.center.y);
}
@end
