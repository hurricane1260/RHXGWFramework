//
//  RHCommonView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/10/24.
//
//

#import "RHCommonView.h"

@interface RhPushNotiView : UIView

kRhPStrong UIView * vline;

kRhPStrong UIView * bottomView;

kRhPStrong UIImageView * titleImgView;

kRhPStrong UILabel * titleLabel;

kRhPStrong UILabel * timeLabel;

kRhPStrong UILabel * contentLabel;

kRhPStrong UIView * hLine;

kRhPStrong UIButton * openBtn;

kRhPStrong UIButton * closeBtn;

kRhPStrong id resultData;

kRhPCopy ButtonCommonCallBack openCallBack;

kRhPCopy ButtonCommonCallBack closeCallBack;

@end

static RhPushNotiView *instance = nil;

@implementation RhPushNotiView

+(RhPushNotiView *)shareInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[RhPushNotiView alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        [self initPushNotiView];
    }
    return self;
}

- (void)initPushNotiView{
    self.vline = [[UIView alloc] init];
    self.vline.backgroundColor = color7_text_xgw;
    [self addSubview:self.vline];
    
    self.bottomView = [[UIView alloc] init];
    [self addSubview:self.bottomView];
    
    self.titleImgView = [[UIImageView alloc] init];
    [self.bottomView addSubview:self.titleImgView];
    
    self.titleLabel = [UILabel didBuildLabelWithText:@"" fontSize:38.0f textColor:color3_text_xgw wordWrap:NO];
    [self.titleImgView addSubview:self.titleLabel];
    
//    self.timeLabel = [UILabel didBuildLabelWithText:@"" fontSize:12.0f textColor:color3_text_xgw wordWrap:NO];
    self.timeLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.titleImgView addSubview:self.timeLabel];
    
//    self.contentLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color3_text_xgw wordWrap:NO];
    self.contentLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.bottomView addSubview:self.contentLabel];
    
    self.hLine = [[UIView alloc] init];
    [self.bottomView addSubview:self.hLine];
    
    self.openBtn = [UIButton didBuildButtonWithTitle:@"" normalTitleColor:color3_text_xgw highlightTitleColor:color3_text_xgw disabledTitleColor:color3_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:[UIColor clearColor]];
    [self.openBtn addTarget:self action:@selector(openTheNoti) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.openBtn];
    
    self.closeBtn = [UIButton didBuildButtonWithTitle:@"" normalTitleColor:color3_text_xgw highlightTitleColor:color3_text_xgw disabledTitleColor:color3_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:[UIColor clearColor]];
    [self.closeBtn addTarget:self action:@selector(closePushNotiView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.closeBtn];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = keyAppWindow.width;
    CGFloat height = keyAppWindow.height;
    
    [self.titleLabel sizeToFit];
    [self.timeLabel sizeToFit];
    self.vline.frame = CGRectMake(width / 2.0f - 0.25f, 0, 0.5f, 100.0f);
    self.bottomView.frame = CGRectMake(width * 0.15f, CGRectGetMaxY(self.vline.frame), width * 0.7f, height * 0.6f);
    self.titleImgView.frame = CGRectMake(0, 0, self.bottomView.width, self.bottomView.height * 0.25f);
    self.titleLabel.frame = CGRectMake((self.titleImgView.width - self.titleLabel.width)/2.0f, self.titleImgView.height * 0.25, self.titleLabel.width, self.titleLabel.height);
    self.timeLabel.frame = CGRectMake(self.titleImgView.width - self.timeLabel.width - 15.0f, CGRectGetMaxY(self.titleLabel.frame) + 10.0f, self.timeLabel.width, self.timeLabel.height);
    self.contentLabel.frame = CGRectMake(self.bottomView.width * 0.1f, CGRectGetMaxY(self.titleImgView.frame) + 20.0f, width * 0.8f, self.bottomView.height * 0.6f -40.0f);
    self.hLine.frame = CGRectMake(0, self.bottomView.height * 0.8f, self.bottomView.width, 0.5f);
    [self.openBtn.titleLabel sizeToFit];
    self.openBtn.frame = CGRectMake((self.bottomView.width - self.openBtn.titleLabel.width)/ 2.0f, CGRectGetMaxY(self.hLine.frame), self.openBtn.titleLabel.width, self.bottomView.height * 0.2f);
    
    self.closeBtn.frame = CGRectMake(self.bottomView.width - self.closeBtn.width, 0, 20.0f, 20.0f);
}

- (void)openTheNoti{
    if (self.openCallBack) {
        self.openCallBack();
    }
    
}

- (void)closePushNotiView{
    if (self.closeCallBack) {
        self.closeCallBack();
    }
}

+ (void)showPushNotiView{
    RhPushNotiView * notiView = [RhPushNotiView shareInstance];
    [[UIApplication sharedApplication].keyWindow addSubview:notiView];
    notiView.frame = CGRectMake(0, 0,keyAppWindow.width, keyAppWindow.height);
//    [notiView addAnmiationWithScale];
}

+ (void)dismissPushNotiViewFromSuperView{
    
    [[RhPushNotiView shareInstance] removeFromSuperview];
    
}

@end

@interface RHCommonView ()

kRhPStrong UIView * loadingView;//正在加载

kRhPStrong UIView * abnormalView;//网络异常

kRhPStrong UIView * netSlowView;//网络不给力

kRhPStrong UIView * dataFailView;//数据获取失败

kRhPStrong UIView * retryView;//获取数据失败 重试

kRhPStrong UIView * partLoading;//局部加载

kRhPStrong RhPushNotiView * pushPopView;//消息推送弹出

kRhPStrong UIView * pushNotiOpenView;//通知打开提醒

kRhPStrong UIView * messageView;//消息弹出页面

kRhPStrong UIView * serverDownView;//服务器罢工

@end

@implementation RHCommonView


+ (void)showLoadingView{

}



+ (void)showNotiPopView{
    [RhPushNotiView showPushNotiView];
}

+ (void)dismissNotiPopView{
    [RhPushNotiView dismissPushNotiViewFromSuperView];

}


@end






