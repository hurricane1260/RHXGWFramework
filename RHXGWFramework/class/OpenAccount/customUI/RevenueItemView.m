//
//  RevenueItemView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2018/3/29.
//

#import "RevenueItemView.h"

@interface RevenueItemView ()
@property (nonatomic,strong)UILabel * titleLb;
@property (nonatomic,strong)UIImageView * rightBtn;



@end

@implementation RevenueItemView

- (instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image {
    if (self = [super init]) {
        [self initSubviewsWithTitle:title andImage:image];
    }
    return self;
}

- (void)initSubviewsWithTitle:(NSString *)title andImage:(UIImage *)image {
    
    self.titleLb = [UILabel didBuildLabelWithText:title font:font2_common_xgw textColor:color4_text_xgw wordWrap:YES];
    [self addSubview:self.titleLb];
    
    self.rightBtn = [[UIImageView alloc] init];
//    [self.rightBtn setImage:image forState:UIControlStateNormal];
    self.rightBtn.image = image;
    [self addSubview:self.rightBtn];
    
    [self addAutoLineWithColor:color16_other_xgw];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLb sizeToFit];
    self.titleLb.frame = CGRectMake(24.0f, (self.height - self.titleLb.height)/2.0f, self.width-80, self.titleLb.height);
    [self.rightBtn sizeToFit];
    self.rightBtn.frame = CGRectMake(self.width - 24.0f - self.rightBtn.width, (self.height - self.rightBtn.height)/2.0f, self.rightBtn.width, self.rightBtn.height);
    
    self.autoLine.frame = CGRectMake(24.0f, self.height - 0.5f, self.width - 24.0f, 0.5f);
    
    
    
}


@end
