//
//  CustomerServiceMidView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/5/3.
//
//

#import "CustomerServiceMidView.h"
#import "customWQView.h"
#import "CustomNumberView.h"

@interface CustomerServiceMidView ()
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UILabel * titleLb;
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)customWQView * WXView;
@property (nonatomic,strong)CustomNumberView *WXNumberView;
@property (nonatomic,strong)customWQView * QQView;
@property (nonatomic,strong)CustomNumberView *QQNumberView;


@end

@implementation CustomerServiceMidView
-(instancetype)init{
    
    if (self = [super init]) {
        [self initViews];
    }
    return self;
}
-(void)initViews{
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = color18_other_xgw;
    [self addSubview:self.topView];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"欢迎加入微信群、QQ群随时咨询";
    self.titleLb.textColor = color4_text_xgw;
    self.titleLb.font = font1_common_xgw;
    [self addSubview:self.titleLb];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = color1_text_xgw;
    [self addSubview:self.bottomView];
    
    self.WXView = [[customWQView alloc]initWithImage:@"icon_weixin" title:@"微信客服"];
    [self.bottomView addSubview:self.WXView];
    
    self.WXNumberView = [[CustomNumberView alloc]init];
    [self.bottomView addSubview:self.WXNumberView];
    
    self.QQView = [[customWQView alloc]initWithImage:@"icon_QQ" title:@"QQ客服"];
    [self.bottomView addSubview:self.QQView];
    
    self.QQNumberView = [[CustomNumberView alloc]init];
    [self.bottomView addSubview:self.QQNumberView];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof(self) welf = self;

    self.topView.frame = CGRectMake(0, 0, kDeviceWidth, 30);
    
    [self.titleLb sizeToFit];
    self.titleLb.center = CGPointMake(12+self.titleLb.size.width/2, self.topView.frame.size.height/2);
    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), kDeviceWidth, 218);
    
    
    CGSize WXsize = [self.WXView getSelfSize];
    self.WXView.size = WXsize;
    self.WXView.origin = CGPointMake(12, 17);
    
 
    self.WXNumberView.size = CGSizeMake(kDeviceWidth-24,44);
    self.WXNumberView.center = CGPointMake(self.bottomView.size.width/2,CGRectGetMaxY(self.WXView.frame)+39 );
    self.WXNumberView.numberText = @"niudafa2017";
    
    self.WXNumberView.openBlock = ^(NSString *number) {
        if (welf.tapBlock) {
            welf.tapBlock(number,WXType);
        }
    };
    
    CGSize QQsize = [self.QQView getSelfSize];
    self.QQView.size = QQsize;
    self.QQView.origin = CGPointMake(12, CGRectGetMaxY(self.WXNumberView.frame)+17);
    
    self.QQNumberView.size = CGSizeMake(kDeviceWidth-24,44);
    self.QQNumberView.center = CGPointMake(self.bottomView.size.width/2,CGRectGetMaxY(self.QQView.frame)+39 );
    self.QQNumberView.numberText = @"287247530";
    self.QQNumberView.openBlock = ^(NSString *number) {
        if (welf.tapBlock) {
            welf.tapBlock(number,QQType);
        }
    };

    
}
@end
