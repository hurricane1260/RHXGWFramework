//
//  CusstomerServiceBottomView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/5/4.
//
//

#import "CusstomerServiceBottomView.h"
#import "customWQView.h"
#import "CustomNumberView.h"
@interface CusstomerServiceBottomView ()
@property (nonatomic,strong)UIScrollView * bgScrollView;
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UILabel * titleLb;
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)customWQView * WXView;
@property (nonatomic,strong)CustomNumberView *WXNumberView;

@end

@implementation CusstomerServiceBottomView

-(instancetype)init{
    if ( self = [super init]) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    __weak typeof(self) welf = self;

    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = color18_other_xgw;
    [self addSubview:self.topView];
    
    self.titleLb = [[UILabel alloc]init];
    self.titleLb.text = @"欢迎关注微信公众号,随时查阅平台咨询";
    self.titleLb.textColor = color4_text_xgw;
    self.titleLb.font = font1_common_xgw;
    [self addSubview:self.titleLb];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = color1_text_xgw;
    [self addSubview:self.bottomView];
    
    self.WXView = [[customWQView alloc]initWithImage:@"icon_weixin" title:@"微信公众号"];
    [self.bottomView addSubview:self.WXView];
    
    self.WXNumberView = [[CustomNumberView alloc]init];
    [self.bottomView addSubview:self.WXNumberView];
    
    self.WXNumberView.openBlock = ^(NSString *number) {
        if (welf.tapBlock) {
            welf.tapBlock(number,WeChatPublic);
        }
    };
    
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.topView.frame = CGRectMake(0, 0, kDeviceWidth, 30);
    
    [self.titleLb sizeToFit];
    self.titleLb.center = CGPointMake(12+self.titleLb.size.width/2, self.topView.frame.size.height/2);
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), kDeviceWidth, 130);
    CGSize WXsize = [self.WXView getSelfSize];
    self.WXView.size = WXsize;
    self.WXView.origin = CGPointMake(12, 17);
    self.WXNumberView.size = CGSizeMake(kDeviceWidth-24,44);
    self.WXNumberView.center = CGPointMake(self.bottomView.size.width/2,CGRectGetMaxY(self.WXView.frame)+39 );
    self.WXNumberView.numberText = @"智能选股王";

    
}
-(void)tel{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-088-5558"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)commonMistakeLbClick{
    if (self.commonMistakeLbBlock) {
        self.commonMistakeLbBlock();
    }
}
@end
