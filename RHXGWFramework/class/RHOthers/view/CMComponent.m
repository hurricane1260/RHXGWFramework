//
//  CMComponent.m
//  JinHuiXuanGuWang
//
//  Created by Zzbei on 2016/11/23.
//
//

#import "CMComponent.h"
#import "Reachability.h"
@interface CMComponent ()

@property (nonatomic,copy) RepeatButtonBlock repeatButtonBlock;

@end

@implementation CMComponent

static CMComponent *instance = nil;
+ (CMComponent *)shareInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[CMComponent alloc] init];
    });
    
    return instance;
}

+ (void)showLoadingViewWithSuperView:(UIView *)superView andFrame:(CGRect)frame
{
    [self removeComponentViewWithSuperView];
    [CMComponent shareInstance].frame = frame;
    [CMComponent shareInstance].backgroundColor = [UIColor clearColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([CMComponent shareInstance].width - 220) / 2, ([CMComponent shareInstance].height - 174) / 2, 220, 174)];
    
    UIImage *image1 = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_findstock"];
    UIImage *image2 = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_findstock_02"];
    imageView.animationImages = [NSArray arrayWithObjects:image1,image2,nil];
    imageView.animationDuration = 0.4;
    imageView.animationRepeatCount = 0;
    [imageView startAnimating];
    
    [[CMComponent shareInstance] addSubview:imageView];
    
    [superView addSubview:[CMComponent shareInstance]];
}

+ (void)showNoDataWithSuperView:(UIView *)superView andFrame:(CGRect)frame
{
    [self removeComponentViewWithSuperView];
    [CMComponent shareInstance].frame = frame;
    [CMComponent shareInstance].backgroundColor = [UIColor whiteColor];
    [superView addSubview:[CMComponent shareInstance]];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([CMComponent shareInstance].width - 220) / 2, ([CMComponent shareInstance].height - 174) / 2 - 80, 220, 174)];
    imageView.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_nonedata"];
    [[CMComponent shareInstance] addSubview:imageView];
    
//    UILabel * label = [UILabel didBuildLabelWithText:@"暂无数据" fontSize:12 textColor:color2_text_xgw wordWrap:NO];
    UILabel * label = [UILabel didBuildLabelWithText:@"暂无数据" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [label sizeToFit];
    label.frame = CGRectMake(([CMComponent shareInstance].width - label.width) / 2, ([CMComponent shareInstance].height - 174) / 2 - 80 + 174, label.width, label.height);
    [[CMComponent shareInstance] addSubview:label];
}

+ (void)showRequestFailViewWithSuperView:(UIView *)superView andFrame:(CGRect)frame andTouchRepeatTouch:(RepeatButtonBlock)block
{
    [self removeComponentViewWithSuperView];
    [CMComponent shareInstance].frame = frame;
    [CMComponent shareInstance].backgroundColor = [UIColor whiteColor];
    [CMComponent shareInstance].repeatButtonBlock = block;
    [superView addSubview:[CMComponent shareInstance]];
    
    UIButton * repeatButton = [UIButton didBuildButtonWithTitle:@"    再试一次    " normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color2_text_xgw normalBGColor:color1_text_xgw highlightBGColor:color1_text_xgw disabledBGColor:color1_text_xgw];
    repeatButton.layer.borderColor = color2_text_xgw.CGColor;
    repeatButton.layer.borderWidth = 0.5f;
    repeatButton.layer.masksToBounds = YES;
    repeatButton.layer.cornerRadius = 15.0f;
    repeatButton.titleLabel.font = font3_common_xgw;
    [repeatButton addTarget:self action:@selector(repeatButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    repeatButton.frame = CGRectMake(([CMComponent shareInstance].width - 150) / 2, ([CMComponent shareInstance].height - 174 - 60) / 2  + 174 + 30, 150, 30);
    [[CMComponent shareInstance] addSubview:repeatButton];
    
    if ([[[CMComponent shareInstance] getNetWorkStates] isEqualToString:@"无网络"]) {
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([CMComponent shareInstance].width - 220) / 2, ([CMComponent shareInstance].height - 174 - 60) / 2, 220, 174)];
        imageView.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_failedtogetdata"];
        [[CMComponent shareInstance] addSubview:imageView];

//        UILabel * label = [UILabel didBuildLabelWithText:@"网络不给力，请检查手机是否联网" fontSize:12 textColor:color2_text_xgw wordWrap:NO];
        UILabel * label = [UILabel didBuildLabelWithText:@"网络不给力，请检查手机是否联网" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
        [label sizeToFit];
        label.frame = CGRectMake(([CMComponent shareInstance].width - label.width) / 2, ([CMComponent shareInstance].height - 174 - 60) / 2 + 174, label.width, label.height);
        [[CMComponent shareInstance] addSubview:label];
    } else {
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([CMComponent shareInstance].width - 220) / 2, ([CMComponent shareInstance].height - 174 - 60) / 2, 220, 174)];
        imageView.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_nodata"];
        [[CMComponent shareInstance] addSubview:imageView];

//        UILabel * label = [UILabel didBuildLabelWithText:@"获取数据失败，请点击重试" fontSize:12 textColor:color2_text_xgw wordWrap:NO];
        UILabel * label = [UILabel didBuildLabelWithText:@"获取数据失败，请点击重试" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
        [label sizeToFit];
        label.frame = CGRectMake(([CMComponent shareInstance].width - label.width) / 2, ([CMComponent shareInstance].height - 174 - 60) / 2 + 174, label.width, label.height);
        [[CMComponent shareInstance] addSubview:label];
    }
    
}

+ (void)showServiceDownViewWithSuperView:(UIView *)superView andFrame:(CGRect)frame andTouchRepeatTouch:(RepeatButtonBlock)block
{
    [self removeComponentViewWithSuperView];
    [CMComponent shareInstance].frame = frame;
    [CMComponent shareInstance].backgroundColor = [UIColor whiteColor];
    [CMComponent shareInstance].repeatButtonBlock = block;
    [superView addSubview:[CMComponent shareInstance]];
    
    UIButton * repeatButton = [UIButton didBuildButtonWithTitle:@"    再试一次    " normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color2_text_xgw normalBGColor:color1_text_xgw highlightBGColor:color1_text_xgw disabledBGColor:color1_text_xgw];
    repeatButton.layer.borderColor = color2_text_xgw.CGColor;
    repeatButton.layer.borderWidth = 0.5f;
    repeatButton.layer.masksToBounds = YES;
    repeatButton.layer.cornerRadius = 15.0f;
    repeatButton.titleLabel.font = font3_common_xgw;
    [repeatButton addTarget:self action:@selector(repeatButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    repeatButton.frame = CGRectMake(([CMComponent shareInstance].width - 150) / 2, ([CMComponent shareInstance].height - 174) / 2 - 80 + 174 + 30, 150, 30);
    [[CMComponent shareInstance] addSubview:repeatButton];

    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([CMComponent shareInstance].width - 220) / 2, ([CMComponent shareInstance].height - 174) / 2 - 80, 220, 174)];
    imageView.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_nosever"];
    [[CMComponent shareInstance] addSubview:imageView];
    
//    UILabel * label = [UILabel didBuildLabelWithText:@"服务器异常，请稍后重试" fontSize:12 textColor:color2_text_xgw wordWrap:NO];
    UILabel * label = [UILabel didBuildLabelWithText:@"服务器异常，请稍后重试" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [label sizeToFit];
    label.frame = CGRectMake(([CMComponent shareInstance].width - label.width) / 2, ([CMComponent shareInstance].height - 174) / 2 - 80 + 174, label.width, label.height);
    [[CMComponent shareInstance] addSubview:label];
}

+ (void)showNoDataViewWithSuperView:(UIView *)superView andFrame:(CGRect)frame andTouchRepeatTouch:(RepeatButtonBlock)block andLabelText:(NSString *)labelText andButtonText:(NSString *)buttonText
{
    [self removeComponentViewWithSuperView];
    [CMComponent shareInstance].frame = frame;
    [CMComponent shareInstance].backgroundColor = [UIColor whiteColor];
    [CMComponent shareInstance].repeatButtonBlock = block;
    [superView addSubview:[CMComponent shareInstance]];
    
    UIButton * repeatButton = [UIButton didBuildButtonWithTitle:[NSString stringWithFormat:@"    %@    ",buttonText] normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw disabledTitleColor:color2_text_xgw normalBGColor:color1_text_xgw highlightBGColor:color1_text_xgw disabledBGColor:color1_text_xgw];
    repeatButton.layer.borderColor = color2_text_xgw.CGColor;
    repeatButton.layer.borderWidth = 0.5f;
    repeatButton.layer.masksToBounds = YES;
    repeatButton.layer.cornerRadius = 15.0f;
    repeatButton.titleLabel.font = font3_common_xgw;
    [repeatButton addTarget:self action:@selector(repeatButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    repeatButton.frame = CGRectMake(([CMComponent shareInstance].width - 150) / 2, ([CMComponent shareInstance].height - 174) / 2 - 50 + 174 + 30, 150, 30);
    [[CMComponent shareInstance] addSubview:repeatButton];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([CMComponent shareInstance].width - 220) / 2, ([CMComponent shareInstance].height - 174) / 2 - 80, 220, 174)];
    imageView.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_addstock"];
    [[CMComponent shareInstance] addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] init];
    label.numberOfLines = 2;
    label.font = font1_common_xgw;
    label.textColor = color4_text_xgw;
    label.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    
    [label sizeToFit];
    label.frame = CGRectMake(([CMComponent shareInstance].width - label.width) / 2, ([CMComponent shareInstance].height - 174) / 2 - 80 + 174, label.width, label.height);
    [[CMComponent shareInstance] addSubview:label];
}

+ (void)removeComponentViewWithSuperView
{
    NSArray *viewsToRemove = [[CMComponent shareInstance] subviews];
    for (UIView *view in viewsToRemove) {
        [view removeFromSuperview];
    }
    [[CMComponent shareInstance] removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

+ (void)repeatButtonTouch
{
    if ([CMComponent shareInstance].repeatButtonBlock != nil) {
        [CMComponent shareInstance].repeatButtonBlock();
    }
}

- (NSString *)getNetWorkStates{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    NSString * state;
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            state = @"无网络";
            break;
        case ReachableViaWWAN:
            // 使用4G网络
            state = @"4G";
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            state = @"WiFi";
            break;
    }
    return state;
}
/***主题下一级 特殊处理组件***/
+ (void)subThemeNoDataWithSuperView:(UIView *)superView andFrame:(CGRect)frame{
    [self removeComponentViewWithSuperView];
    [CMComponent shareInstance].frame = frame;
    [CMComponent shareInstance].backgroundColor = [UIColor whiteColor];
    [superView addSubview:[CMComponent shareInstance]];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([CMComponent shareInstance].width - 220) / 2, ([CMComponent shareInstance].height - 174) / 2 , 220, 174)];
    imageView.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_nonedata"];
    [[CMComponent shareInstance] addSubview:imageView];
    
    
    UILabel * label = [UILabel didBuildLabelWithText:@"暂无数据" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [label sizeToFit];
    label.frame = CGRectMake(([CMComponent shareInstance].width - label.width) / 2, ([CMComponent shareInstance].height - 174) / 2  + 174, label.width, label.height);
    [[CMComponent shareInstance] addSubview:label];

}

@end
