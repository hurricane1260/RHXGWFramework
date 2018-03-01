//
//  TradeLoginView.m
//  stockscontest
//
//  Created by rxhui on 16/3/9.
//  Copyright © 2016年 方海龙. All rights reserved.
//

#import "TradeLoginView.h"
#import "TradeDataStore.h"
#import "PrefecturePictureVO.h"
#import "CMHttpURLManager.h"
#import "NEUSecurityUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "SDCycleScrollView.h"
#import "KYWaterWaveView.h"

#define UISCREEN_SIZE [UIScreen mainScreen].bounds.size
#define TIME 0.7
#define SPEED_X TIME/UISCREEN_SIZE.width
#define SPEED_Y TIME/UISCREEN_SIZE.height

@interface TradeLoginView () <SDCycleScrollViewDelegate>

/*! @brief 开户按钮 */
@property (nonatomic,strong) UIButton * openAccountButton;

@property (nonatomic,strong) UIScrollView * wrapView;

@property (nonatomic,strong) UIImageView * hcIconView;

@property (nonatomic,strong) UIImageView * hcNameView;

@property (nonatomic,strong) UILabel * hcTitleLabel;

@property (nonatomic,strong) UIView * sepLine;

@property (nonatomic,strong) UIView * seperatorLine3;

/*! @brief 账号输入框 */
@property (nonatomic, strong) UITextField * userAccountTextField;

@property (nonatomic, strong) UIView * accountWrapView;

@property (nonatomic, strong) UIView * seperatorLine;

/*! @brief 密码输入框 */
@property (nonatomic, strong) UITextField * passwdTextField;

@property (nonatomic, strong) UIView * passwordWrapView;

@property (nonatomic, strong) UIView * seperatorLine1;

/*! @brief 验证码输入框 */
@property (nonatomic, strong) UITextField * verifyTextField;

@property (nonatomic, strong) UIView * verifyWrapView;

@property (nonatomic, strong) UIView * seperatorLine2;

/*! @brief 登录按钮 */
@property (nonatomic, strong) UIButton * loginButton;


/*! @brief 账号 */
@property (nonatomic, strong) NSString * userAccount;

/*! @brief 密码 */
@property (nonatomic, readonly) NSString * password;

/*! @brief 保存账号 */
@property (nonatomic, strong) TradeDataStore * dataStore;

/*! @brief 开户按钮下的说明文字 */
@property (nonatomic, strong) UILabel * openAccountIntroLabel;

/*! @brief 轮播图 */
@property (nonatomic, strong) SDCycleScrollView * sdScrollView;

/*! @brief 为您服务 */
@property (nonatomic, strong) UIButton * serviceBtn;

/*! @brief 忘记密码 */
@property (nonatomic, strong) UIButton * forgetPWBtn;

kRhPStrong UIScrollView * bottomViewDef;

kRhPStrong UIImageView * defaultImgViewDef;

kRhPStrong UIImageView * rocketViewDef;

kRhPStrong UIImage * imgDef;

kRhPStrong UILabel * titleLabelDef;

kRhPStrong UIButton * openBtnDef;

kRhPStrong UIButton * loginBtnDef;

kRhPStrong UIImageView * animateImgViewDef;

kRhPStrong NSMutableArray * imgArr;

kRhPStrong NSTimer * timer;

kRhPAssign CGRect originRect;

kRhPStrong  PrefecturePictureVO * defaultParam;

kRhPStrong UIColor * customByServerTitleColor;

kRhPStrong UIColor * customByServerBgColor;

kRhPAssign BOOL isServerConfig;
@end

@implementation TradeLoginView

static CGFloat formHeight = 50.0f;
static CGFloat headImageHeight = 35.0f;
static CGFloat buttonHeight = 44.0f;


#pragma mark ---------初始化及布局
- (instancetype)initWithVerifyBlock:(ButtonCommonCallBack)verifyCallback loginBlock:(ButtonCallBackWithParams)loginCallback openAccountBlock:(ButtonCommonCallBack)openAccountCallback withDefaultViewShow:(id)defaultImgParam changeNavBarColorCallback:(ButtonCallBackWithParams)colorCallBack serviceBlock:(ButtonCommonCallBack)serviceCallback forgetPassWordBlock:(ButtonCommonCallBack)forgetPassWordCallBack andBannerBlock:(ButtonCommonCallBack)bannerCallBack
{
    self = [super init];
    if (self) {
        
        self.verifyCallback = verifyCallback;
        self.loginCallback = loginCallback;
        self.openAccountCallback = openAccountCallback;
        self.changeNavBarColorCallback = colorCallBack;
        self.serviceForYouCallBack = serviceCallback;
        self.forgetPassWordCallBack = forgetPassWordCallBack;
        self.bannerCallBack = bannerCallBack;
        
        self.dataStore = [[TradeDataStore alloc]init];
        if (defaultImgParam && [defaultImgParam isKindOfClass:[PrefecturePictureVO class]]) {
            self.defaultParam = (PrefecturePictureVO *)defaultImgParam;
            NSString * jsonStr = self.defaultParam.linkUrl;
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
            NSString * bgColor = [dic objectForKey:@"bgColor"];
            NSString * serverColor = [dic objectForKey:@"titleColor"];
            
            self.customByServerBgColor = [UIColor colorWithRXHexString:[NSString stringWithFormat:@"0x%@",bgColor]];
            self.customByServerTitleColor = [UIColor colorWithRXHexString:[NSString stringWithFormat:@"0x%@",serverColor]];
            self.defaultImgViewDef = [[UIImageView alloc] init];
            NSString *prefix = [CMHttpURLManager getHostIPWithServID:@"profileImageUrl"];
            NSString * url = [NSString stringWithFormat:@"%@/%@",prefix,self.defaultParam.imgPath];
            [self.defaultImgViewDef sd_setImageWithURL:[NSURL URLWithString:url]];
            self.isServerConfig = YES;
            self.showDefault = YES;
        }
        else if(defaultImgParam && [defaultImgParam isKindOfClass:[UIImage class]]){
            self.customByServerBgColor = color1_text_xgw;
            self.customByServerTitleColor = color2_text_xgw;
//            self.imgDef = img_trade_default;
//             self.defaultImgViewDef = [[UIImageView alloc] initWithImage:self.imgDef];
//            NSString * name;
//            self.imgArr = [NSMutableArray array];
//            for (int i = 1; i < 8; i++) {
//                name = [NSString stringWithFormat:@"0%d_rocket",i];//07_rocket
//                UIImage * rocketImg = [UIImage imageNamed:name];
//                [self.imgArr addObject:rocketImg];
//            }
            self.isServerConfig = NO;
            self.showDefault = YES;
//            self.timer =  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
        }
        else{
            self.showDefault = NO;
            self.backgroundColor = color1_text_xgw;
        }
        [self initDefaultView];
        [self initSubViews];

    }
    return self;
}

- (void)dealloc{
//    [self.timer invalidate];
//    self.timer = nil;
}

- (void)initDefaultView{
    self.bottomViewDef = [[UIScrollView alloc] init];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboards)];
    [self.bottomViewDef addGestureRecognizer:tap];
    self.bottomViewDef.backgroundColor = self.customByServerBgColor;
    [self addSubview:self.bottomViewDef];
    
//    self.defaultImgViewDef = [[UIImageView alloc] initWithImage:self.imgDef];
    [self.bottomViewDef addSubview:self.defaultImgViewDef];
    
    self.openBtnDef = [UIButton didBuildButtonWithTitle:@"开通A股账户" normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color9_text_xgw normalBGColor:color6_text_xgw highlightBGColor:color6_text_xgw disabledBGColor:color6_text_xgw];
    self.openBtnDef.titleLabel.textColor = color1_text_xgw;
    self.openBtnDef.titleLabel.font = font2_common_xgw;
    [self.openBtnDef addTarget:self action:@selector(openAccountButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomViewDef addSubview:self.openBtnDef];
    
    if (self.isServerConfig) {
        self.loginBtnDef = [UIButton didBuildButtonWithTitle:@"登录华创证券交易" normalTitleColor:_customByServerTitleColor highlightTitleColor:_customByServerTitleColor disabledTitleColor:color9_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:[UIColor clearColor]];
        self.loginBtnDef.layer.borderColor = color2_text_xgw.CGColor;
        self.loginBtnDef.layer.borderWidth = 0.5f;
        
        self.rocketViewDef = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/01_rocket"]];
        [self.bottomViewDef addSubview:self.rocketViewDef];
        self.rocketViewDef.animationImages = self.imgArr;
        self.rocketViewDef.animationDuration = TIME;
        self.rocketViewDef.animationRepeatCount = 0;
        [self.rocketViewDef startAnimating];
        self.rocketViewDef.hidden = self.isServerConfig;
    }
    else{
        self.loginBtnDef = [UIButton didBuildButtonWithTitle:@"登录华创证券交易" normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color9_text_xgw normalBGColor:[UIColor colorWithRXHexString:@"0x15315c"] highlightBGColor:[UIColor colorWithRXHexString:@"0x15315c"] disabledBGColor:[UIColor colorWithRXHexString:@"0x15315c"]];
        
        NSArray * imageArray;
        if (UISCREEN_SIZE.width < 400) {
            imageArray = @[[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/tradelogin1_720"],[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/tradelogin2_720"],[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/tradelogin3_720"]];
        } else {
            imageArray = @[[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/tradelogin1_1242"],[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/tradelogin2_1242"],[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/tradelogin3_1242"]];
        }
        self.sdScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UISCREEN_SIZE.width, UISCREEN_SIZE.width / 1.58) imagesGroup:imageArray];
        self.sdScrollView.backgroundColor = color2_text_xgw;
        self.sdScrollView.delegate = self;
        if (imageArray.count > 1) {
            self.sdScrollView.autoScroll = YES;
        } else {
            self.sdScrollView.autoScroll = NO;
        }
        self.sdScrollView.autoScrollTimeInterval = 5.0f;
        self.sdScrollView.showPageControl = YES;
        self.sdScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        [self addSubview:self.sdScrollView];
        
        KYWaterWaveView *backWave = [[KYWaterWaveView alloc]initWithFrame:CGRectMake(0, self.sdScrollView.y + self.sdScrollView.height, MAIN_SCREEN_WIDTH, 50.0f)];
        [self.bottomViewDef addSubview:backWave];
        backWave.transform = CGAffineTransformMakeRotation(M_PI * 3.5 * 2);
        backWave.waveSpeed = 1.0f;
        backWave.waveAmplitude = 8.0f;
        [backWave wave];
        
        KYWaterWaveView *frontWave = [[KYWaterWaveView alloc]initWithFrame:CGRectMake(0, self.sdScrollView.y + self.sdScrollView.height, MAIN_SCREEN_WIDTH, 50.0f)];
        [self.bottomViewDef addSubview:frontWave];
        frontWave.transform = CGAffineTransformMakeRotation(M_PI * 3.5 * 2);
        frontWave.waveSpeed = 2.0f;
        frontWave.waveAmplitude = 6.0f;
        [frontWave wave];
        
        self.serviceBtn = [[UIButton alloc] init];
        [self.serviceBtn setTitle:@"为您服务" forState:UIControlStateNormal];
        self.serviceBtn.titleLabel.font = font1_common_xgw;
        [self.serviceBtn setTitleColor:color8_text_xgw forState:UIControlStateNormal];
        [self.serviceBtn.titleLabel sizeToFit];
        self.serviceBtn.size = self.serviceBtn.titleLabel.size;
        [self.serviceBtn addTarget:self action:@selector(serviceForYou) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomViewDef addSubview:self.serviceBtn];
    }
    self.loginBtnDef.titleLabel.font = font2_common_xgw;
    self.loginBtnDef.titleLabel.textColor = color1_text_xgw;
//    if (!self.isServerConfig) {
//    }
    [self.loginBtnDef addTarget:self action:@selector(hiddenDefaultViewToShowLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomViewDef addSubview:self.loginBtnDef];

}

- (void)initSubViews{
    //logo
    
    self.wrapView = [[UIScrollView alloc]initWithFrame:CGRectZero];
//    self.titleWrapView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboards)];
    [self.wrapView addGestureRecognizer:tap];
    [self addSubview:self.wrapView];
//    self.hcTitleLabel = [UILabel didBuildLabelWithText:@"交易" font:font3_common_xgw textColor:color2_text_xgw wordWrap:NO];
//    [self.titleWrapView addSubview:self.hcTitleLabel];
    
//    self.sepLine = [[UIView alloc] init];
//    self.sepLine.backgroundColor = color16_other_xgw;
//    [self.titleWrapView addSubview:self.sepLine];
    
    self.hcIconView = [[UIImageView alloc] initWithImage:img_trade_logo];
    [self.wrapView addSubview:self.hcIconView];
    
//    self.hcNameView = [[UIImageView alloc] initWithImage:img_trade_name];
//    [self.titleWrapView addSubview:self.hcNameView];
    
    //账号
    self.accountWrapView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.wrapView addSubview:self.accountWrapView];
    
    self.userAccountTextField = [[UITextField alloc] init];
    self.userAccountTextField.textColor = color2_text_xgw;
    self.userAccountTextField.placeholder = @"请输入华创资金账号";
    NSMutableAttributedString * mutaStr = [[NSMutableAttributedString alloc] initWithString:self.userAccountTextField.placeholder];
    [mutaStr addAttribute:NSForegroundColorAttributeName value:color4_text_xgw range:NSMakeRange(0,self.userAccountTextField.placeholder.length)];
    self.userAccountTextField.attributedPlaceholder = mutaStr;
    self.userAccountTextField.borderStyle = UITextBorderStyleNone;
    self.userAccountTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.userAccountTextField.font = font2_number_xgw;
    self.userAccountTextField.textAlignment = NSTextAlignmentCenter;
    self.userAccountTextField.text = self.userAccount;
    [self.accountWrapView addSubview:self.userAccountTextField];

    self.seperatorLine3 = [[UIView alloc]initWithFrame:CGRectZero];
    self.seperatorLine3.backgroundColor = color16_other_xgw;
    [self.accountWrapView addSubview:self.seperatorLine3];
    
    //密码
    self.passwordWrapView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.wrapView addSubview:self.passwordWrapView];
    
    self.passwdTextField = [[UITextField alloc] init];
    self.passwdTextField.placeholder = @"请输入6位数字密码";
    NSMutableAttributedString * mutaStr1 = [[NSMutableAttributedString alloc] initWithString:self.passwdTextField.placeholder];
    [mutaStr1 addAttribute:NSForegroundColorAttributeName value:color4_text_xgw range:NSMakeRange(0,self.passwdTextField.placeholder.length)];
    self.passwdTextField.attributedPlaceholder = mutaStr1;
    self.passwdTextField.textColor = color2_text_xgw;
    self.passwdTextField.borderStyle = UITextBorderStyleNone;
    self.passwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwdTextField.font = font2_number_xgw;
    self.passwdTextField.textAlignment = NSTextAlignmentCenter;
    self.passwdTextField.secureTextEntry = YES;
    [self.passwordWrapView addSubview:self.passwdTextField];
    
    self.seperatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    self.seperatorLine.backgroundColor = color16_other_xgw;
    [self.passwordWrapView addSubview:self.seperatorLine];
    
    //验证码
    self.verifyWrapView = [[UIView alloc]initWithFrame:CGRectZero];
//    [self.wrapView addSubview:self.verifyWrapView];
    
    self.verifyTextField = [[UITextField alloc] init];
    self.verifyTextField.placeholder = kCHSLoginVerifyCodeTextFieldPlaceholder;
    NSMutableAttributedString * mutaStr2 = [[NSMutableAttributedString alloc] initWithString:self.verifyTextField.placeholder];
    [mutaStr2 addAttribute:NSForegroundColorAttributeName value:color4_text_xgw range:NSMakeRange(0,self.verifyTextField.placeholder.length)];
    self.verifyTextField.attributedPlaceholder = mutaStr2;
    self.verifyTextField.textColor = color2_text_xgw;
    self.verifyTextField.borderStyle = UITextBorderStyleNone;
    self.verifyTextField.keyboardType = UIKeyboardTypeAlphabet;
    self.verifyTextField.font = font2_number_xgw;
    self.verifyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.verifyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.verifyTextField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.verifyTextField.textAlignment = NSTextAlignmentCenter;
    [self.verifyWrapView addSubview:self.verifyTextField];
    
    self.seperatorLine1 = [[UIView alloc]initWithFrame:CGRectZero];
        self.seperatorLine1.backgroundColor = color16_other_xgw;
    [self.verifyWrapView addSubview:self.seperatorLine1];
    
    self.verifyButton = [[UIButton alloc] init];
    [self.verifyButton addTarget:self action:@selector(verifyButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
//    self.verifyButton.backgroundColor = color_trade_verifCodeBg;
    self.verifyButton.contentMode = UIViewContentModeScaleToFill;
    self.verifyButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [self.verifyWrapView addSubview:self.verifyButton];
    self.verifyButton.backgroundColor = color5_text_xgw;

    //忘记密码
    self.forgetPWBtn = [[UIButton alloc] init];
    [self.forgetPWBtn setTitle:@"忘记账号/密码?" forState:UIControlStateNormal];
    self.forgetPWBtn.titleLabel.font = font1_common_xgw;
    [self.forgetPWBtn setTitleColor:color4_text_xgw forState:UIControlStateNormal];
    [self.forgetPWBtn.titleLabel sizeToFit];
    self.forgetPWBtn.size = self.forgetPWBtn.titleLabel.size;
    [self.forgetPWBtn addTarget:self action:@selector(forgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.wrapView addSubview:self.forgetPWBtn];
    
    //登录
    self.loginButton = [UIButton didBuildButtonWithTitle:@"登录交易" normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color9_text_xgw normalBGColor:color6_text_xgw highlightBGColor:color6_text_xgw disabledBGColor:color1_text_xgw];
    self.loginButton.titleLabel.font = font2_common_xgw;
    [self.loginButton addTarget:self action:@selector(loginButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.wrapView addSubview:self.loginButton];
    
    //开户
    self.openAccountButton = [UIButton didBuildButtonWithTitle:@"立即开户" normalTitleColor:color8_text_xgw highlightTitleColor:color8_text_xgw disabledTitleColor:color8_text_xgw normalBGColor:[UIColor clearColor] highlightBGColor:[UIColor clearColor] disabledBGColor:color1_text_xgw];
    self.openAccountButton.titleLabel.font = font1_common_xgw;
    [self.wrapView addSubview:self.openAccountButton];
    [self.openAccountButton addTarget:self action:@selector(openAccountButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    //客服
//    self.openAccountIntroLabel = [UILabel didBuildLabelWithText:@"客服电话：400-088-5558" fontSize:12.0f textColor:color8_text_xgw wordWrap:YES];
    self.openAccountIntroLabel = [UILabel didBuildLabelWithText:@"为您服务" font:font1_common_xgw textColor:color8_text_xgw wordWrap:YES];
    self.openAccountIntroLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneToService)];
    [self.openAccountIntroLabel addGestureRecognizer:tap1];
//    [self.wrapView addSubview:self.openAccountIntroLabel];
    self.openAccountIntroLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offestY = 90.0f;
    if (MAIN_SCREEN_HEIGHT < 570.0f) {
        offestY = 45.0f;
    }
    CGFloat formWidth = self.width;
    CGFloat gap = 58.0f;
    
    self.contentSize = CGSizeMake(self.width, self.height);
    
//    if (self.showDefault) {
        self.bottomViewDef.frame = CGRectMake(0, 0, self.width, self.height);
    
    if (!self.isServerConfig) {
        self.rocketViewDef.x = self.width - self.rocketViewDef.width - 72.0f;
        self.rocketViewDef.y = 40.0f;
        if (MAIN_SCREEN_HEIGHT < 570.0f) {
            self.rocketViewDef.y = 0.0f;
        }
        self.originRect = self.rocketViewDef.frame;
    }
    
    if (self.defaultImgViewDef.width/self.width  > (823.0f/1080.0f)) {
        CGFloat rate = self.defaultImgViewDef.width / self.defaultImgViewDef.height;
        self.defaultImgViewDef.width = 823.0f * self.width/1080.0f;
        self.defaultImgViewDef.height = self.defaultImgViewDef.width/rate;
    }
    else if (self.defaultImgViewDef.width == 0 || self.defaultImgViewDef.height == 0){
        self.defaultImgViewDef.width = 823.0f * self.width/1080.0f;
        self.defaultImgViewDef.height = self.defaultImgViewDef.width / 0.87f;
    }
    self.defaultImgViewDef.x = (self.width - self.defaultImgViewDef.width) / 2.0f;
    self.defaultImgViewDef.y = CGRectGetMaxY(self.rocketViewDef.frame);
    
    self.openBtnDef.frame = CGRectMake(gap, self.sdScrollView.y + self.sdScrollView.height + 90.0f, formWidth - gap * 2, buttonHeight);
    
    self.loginBtnDef.frame = CGRectMake(gap, CGRectGetMaxY(self.openBtnDef.frame) + 20.0f, self.openBtnDef.width, buttonHeight);
    
//    self.serviceBtn.origin = CGPointMake((UISCREEN_SIZE.width - self.serviceBtn.width) / 2, self.loginBtnDef.y + self.loginBtnDef.height + 75);
    self.serviceBtn.frame = //CGRectMake((UISCREEN_SIZE.width - self.serviceBtn.width) / 2, self.loginBtnDef.y + self.loginBtnDef.height + 75, self.serviceBtn.width, self.serviceBtn.height);
    CGRectMake((formWidth - self.serviceBtn.width ) /2.0f, self.height - 20.0f - self.serviceBtn.height, self.serviceBtn.width, self.serviceBtn.height);
    
    if (CGRectGetMaxY(self.loginBtnDef.frame) > self.height) {
        self.bottomViewDef.contentSize = CGSizeMake(self.bottomViewDef.width, CGRectGetMaxY(self.loginBtnDef.frame) + 10.0f);
    }
    else{
        self.bottomViewDef.contentSize = CGSizeMake(self.bottomViewDef.width, self.height);
    }
    
//    }
//    else{
        self.wrapView.frame = CGRectMake(0, 0, self.width, self.height);

        self.hcIconView.x = (formWidth - self.hcIconView.width) * 0.5f;
        self.hcIconView.y = offestY;
        
        offestY += self.hcIconView.height + 40.0f;
        self.accountWrapView.frame = CGRectMake(0, offestY, formWidth, formHeight);
        self.userAccountTextField.frame = CGRectMake(gap, 0, formWidth - gap * 2.0f, formHeight - 0.5f);
        self.seperatorLine3.frame = CGRectMake(self.userAccountTextField.x, CGRectGetMaxY(self.userAccountTextField.frame), self.userAccountTextField.width, 0.5f);
        
        offestY += formHeight;
        self.passwordWrapView.frame = CGRectMake(0, offestY, formWidth, formHeight);
        self.passwdTextField.frame = CGRectMake(self.userAccountTextField.x, 0, self.userAccountTextField.width, formHeight - 0.5f);
        self.seperatorLine.frame = CGRectMake(gap, formHeight - 0.5f, self.userAccountTextField.width, 0.5f);
        
        offestY += formHeight;
        self.verifyWrapView.frame = CGRectMake(0, offestY, formWidth, formHeight);
        self.verifyTextField.frame = CGRectMake(self.userAccountTextField.x, 0, self.userAccountTextField.width, formHeight - 0.5f);
        self.seperatorLine1.frame = CGRectMake(gap, formHeight - 0.5f, self.userAccountTextField.width, 0.5f);
        
        self.verifyButton.frame = CGRectMake(formWidth - 65.0f - gap, (formHeight - 30.0f)/2.0f, 65.0f, 30.0f);
        self.verifyButton.imageView.frame = self.verifyButton.bounds;
        
        offestY += formHeight + 24.0f;
        self.loginButton.frame = CGRectMake(gap, offestY, formWidth - gap * 2, buttonHeight);
        
        offestY += buttonHeight + 12.0f;
        [self.openAccountButton.titleLabel sizeToFit];
        self.openAccountButton.frame = CGRectMake(gap, offestY, formWidth - gap * 2, self.openAccountButton.titleLabel.height);
        
        [self.openAccountIntroLabel sizeToFit];
        self.openAccountIntroLabel.frame = CGRectMake((formWidth - self.openAccountIntroLabel.width ) /2.0f, self.height - 20.0f - self.openAccountIntroLabel.height, self.openAccountIntroLabel.width, self.openAccountIntroLabel.height);

        self.forgetPWBtn.frame = CGRectMake(self.passwdTextField.x + self.passwdTextField.width - self.forgetPWBtn.width, self.passwordWrapView.y + self.passwordWrapView.height + 20, self.forgetPWBtn.width, self.forgetPWBtn.height);

    if (IS_IPHONE_4) {
        self.openAccountIntroLabel.y = CGRectGetMaxY(self.openAccountButton.frame) + 72.0f;
        self.wrapView.contentSize = CGSizeMake(self.wrapView.width, CGRectGetMaxY(self.openAccountIntroLabel.frame) + 20.0f);
    }
//    }
    
    self.bottomViewDef.hidden = !self.showDefault;
    self.sdScrollView.hidden = !self.showDefault;
    self.wrapView.hidden = self.showDefault;
}

#pragma mark -----setter getter
- (NSString *)userAccount {
    if (!_userAccount) {
        _userAccount = [self.dataStore loadHcAccountNumber];
    }
    return _userAccount;
}

- (void)setShowDefault:(BOOL)showDefault{
    _showDefault = showDefault;
    
    //根据显示页面修改navBar颜色
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithBool:showDefault] forKey:@"showDefault"];
    [param setObject:[NSNumber numberWithBool:_isServerConfig] forKey:@"isServerConfig"];
    if (!self.customByServerBgColor) {
        return;
    }
    [param setObject:self.customByServerBgColor forKey:@"configColor"];
    if (self.changeNavBarColorCallback) {
        self.changeNavBarColorCallback(param);
    }
    [self setNeedsLayout];
}

#pragma mark ------定时器操作
- (void)timerFire{
    CGRect rect = self.rocketViewDef.frame;
    rect.origin.x += 13;
    rect.origin.y -= 9;
    self.rocketViewDef.frame = rect;
    if (self.rocketViewDef.frame.origin.x > [UIScreen mainScreen].bounds.size.width + self.rocketViewDef.width) {
        self.rocketViewDef.frame = self.originRect;
    }
}

#pragma mark ------界面处理
- (void)hideKeyboards {//resignFirstResponder报错
    [self.userAccountTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
    [self.verifyTextField resignFirstResponder];
}

- (void)clearView {
    [self hideKeyboards];
    self.passwdTextField.text = @"";
    self.verifyTextField.text = @"";
}

- (BOOL)isFirstResponder {
    return self.userAccountTextField.isFirstResponder || self.passwdTextField.isFirstResponder || self.verifyTextField.isFirstResponder;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideKeyboards];
}

#pragma mark ---------交互
//默认页面跳转交易登录
- (void)hiddenDefaultViewToShowLoginView{
    self.showDefault = NO;
    //进入过默认页面 登录页面的验证码会被覆盖 需要重新刷新验证码
    [self verifyButtonTouchHandler];
    [MTA trackCustomEvent:@"deal_ad_login" args:nil];
}

//登录交易
-(void)loginButtonTouchHandler{
    if ([self.userAccountTextField.text isEqualToString:@""] || self.userAccountTextField.text.length == 0) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入华创资金账号" warningImage:nil duration:3.0f];
        return;
    }
    
    if ([self.passwdTextField.text  isEqualToString:@""] || self.passwdTextField.text.length == 0) {
        [CMProgress showWarningProgressWithTitle:nil message:@"请输入交易密码" warningImage:nil duration:3.0f];
        return;
    }
    
//    if ([self.verifyTextField.text isEqualToString:@""] || self.verifyTextField.text.length == 0) {
//        [CMProgress showWarningProgressWithTitle:nil message:@"请输入验证码" warningImage:nil duration:3.0f];
//        return;
//    }
    if (self.loginCallback) {
        [self.dataStore saveHcAccountWithAccountNumber:self.userAccountTextField.text];
        self.loginCallback([self buildRequestParam]);
    }
    [MTA trackCustomEvent:@"deal_login" args:nil];
}

-(NSMutableDictionary *)buildRequestParam {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.userAccountTextField.text forKey:@"accountContent"];
    [param setValue:@"123456" forKey:@"password"];
    [param setValue:@"123456" forKey:@"magicCode"];
    
    NSString * key = [[self encryptAccount:self.userAccountTextField.text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString * reuslt = [NEUSecurityUtil neu_encryptAESDataWithPassWord:self.passwdTextField.text andKey:[key substringToIndex:16]];
    NSString * back = [NEUSecurityUtil neu_decryptAESDataWithPassWord:reuslt andKey:[key substringToIndex:16]];
    [param setObject:[self encodeToPercentEscapeString:reuslt] forKey:@"encryptedPassword"];

    return param;
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)input,NULL,(CFStringRef)@"!*'();:@&=+ $,/?%#[]",kCFStringEncodingUTF8));
    return outputStr;
}

//资金账号加密
- (NSString *)encryptAccount:(NSString *)account {
    NSString *preMd5 = [NSString stringWithFormat:@"rxhui%@rxhui",account];
    NSString * md5Str = [self md5:preMd5];
    while ([md5Str hasPrefix:@"0"]) {
        md5Str = [md5Str substringFromIndex:1];
    }
    return md5Str;
}

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


//开户
-(void)openAccountButtonTouchHandler {
    if (self.openAccountCallback) {
        self.openAccountCallback();
    }
    if (self.showDefault) {
        [MTA trackCustomEvent:@"deal_ad_openAnAccount" args:nil];
    }
    else{
        [MTA trackCustomEvent:@"deal_openAccount" args:nil];
    }
}

//验证码
-(void)verifyButtonTouchHandler {//刷新验证码
    if (self.verifyCallback) {
        self.verifyCallback();
    }
}

//客服电话
- (void)phoneToService{
    if (self.phoneCallBack) {
        self.phoneCallBack();
    }
}

//为您服务
- (void)serviceForYou {
    if (self.serviceForYouCallBack) {
        self.serviceForYouCallBack();
    }
}

//忘记密码
- (void)forgetPassWord {
    if (self.forgetPassWordCallBack) {
        self.forgetPassWordCallBack();
    }
}

//banner点击
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.bannerCallBack) {
        self.bannerCallBack();
    }
}

@end
