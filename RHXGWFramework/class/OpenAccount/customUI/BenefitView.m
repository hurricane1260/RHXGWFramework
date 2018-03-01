//
//  BenefitView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/8/17.
//
//

#import "BenefitView.h"
#import "SingleSwichView.h"

@interface BenefitView ()

kRhPStrong SingleSwichView * benefitView;

kRhPStrong SingleSwichView * controlView;

kRhPStrong SingleSwichView * integrityView;

@end

@implementation BenefitView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.benefitView = [[SingleSwichView alloc] initWithTitle:@"受益人为本人"];
    self.benefitView.swichClickCallBack = ^{
        [CMProgress showWarningProgressWithTitle:nil message:@"受益人不是本人，请联系您的开户营业部！" warningImage:nil duration:2];
    
    };
    [self addSubview:self.benefitView];
    
    self.controlView = [[SingleSwichView alloc] initWithTitle:@"控制人为本人"];
    self.controlView.swichClickCallBack = ^{
        
        [CMProgress showWarningProgressWithTitle:nil message:@"控制人必须是本人！" warningImage:nil duration:2];

    };
    [self addSubview:self.controlView];
 
    self.integrityView = [[SingleSwichView alloc] initWithTitle:@"诚信记录良好"];
    self.integrityView.swichClickCallBack = ^{
        
        [CMProgress showWarningProgressWithTitle:nil message:@"如有不良诚信记录请联系您的开户营业部！" warningImage:nil duration:2];

    };
    [self addSubview:self.integrityView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat height = 50.0f;
    
    self.benefitView.frame = CGRectMake(0, 0, self.width, height);
    
    self.controlView.frame = CGRectMake(0, CGRectGetMaxY(self.benefitView.frame), self.width, height);

    self.integrityView.frame = CGRectMake(0, CGRectGetMaxY(self.controlView.frame), self.width, height);

}

@end
