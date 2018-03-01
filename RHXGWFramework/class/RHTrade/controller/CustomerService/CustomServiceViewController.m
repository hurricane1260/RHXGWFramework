//
//  CustomServiceViewController.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/4/26.
//
//

#import "CustomServiceViewController.h"
#import "CustomerServiceTopView.h"
#import "CustomerServiceMidView.h"
#import "CusstomerServiceBottomView.h"
//#import "ContactsNavigationManager.h"
//#import "StockNavigationManager.h"
#import "RHWebViewCotroller.h"
//#import "AppDelegateManager.h"
#import "CMHttpURLManager.h"

@interface CustomServiceViewController ()
@property (nonatomic,strong)UIScrollView * bgScrollView;
@property (nonatomic,strong)CustomerServiceTopView * topView;
@property (nonatomic,strong)CustomerServiceMidView * midView;
@property (nonatomic,strong)CusstomerServiceBottomView * bottomView;
@property (nonatomic,strong)UIView * telView;
/**常见问题Btn*/
@property (nonatomic,strong)UIButton * commonMistakeBtn;
/**客服电话*/
@property (nonatomic,strong)UILabel * telNumberLb;
@property (nonatomic,strong)UIImageView * telImageView;



@end

@implementation CustomServiceViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"联系客服";
        self.view.backgroundColor = color1_text_xgw;
       
        [self initSubviews];
    }
    return self;
}
-(void)initSubviews{

    __weak typeof(self) welf = self;
    
    self.bgScrollView = [[UIScrollView alloc]init];
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.bgScrollView];
    
    self.topView  = [[CustomerServiceTopView alloc]init];
   self.topView.tapBlock = ^(NSString *number, TapType type) {
       [welf openCustomServiceWithType:type];
   };
    [self.bgScrollView addSubview:self.topView];
    self.midView = [[CustomerServiceMidView alloc]init];
    self.midView.tapBlock = ^(NSString *number, TapType type) {
        [welf openCustomServiceWithType:type];
    };
    [self.bgScrollView addSubview:self.midView];
    self.bottomView = [[CusstomerServiceBottomView alloc]init];
    self.bottomView.tapBlock = ^(NSString *number, TapType type) {
        [welf openCustomServiceWithType:type];

    };
    
    self.telView = [[UIView alloc]init];
    [self.view addSubview:self.telView];

    [self.bgScrollView addSubview:self.bottomView];
    
    self.commonMistakeBtn = [[UIButton alloc]init];
    [self.commonMistakeBtn setTitle:@"常见问题" forState:UIControlStateNormal];
    [self.commonMistakeBtn setTitleColor:color4_text_xgw forState:UIControlStateNormal];
    self.commonMistakeBtn.titleLabel.font = font1_common_xgw;
    [self.commonMistakeBtn addTarget:self action:@selector(commonMistakeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.telView addSubview:self.commonMistakeBtn];
    
    
    self.telNumberLb = [[UILabel alloc]init];
    self.telNumberLb.text = @"平台电话:400-088-5558 ";
    self.telNumberLb.textColor = color3_text_xgw;
    self.telNumberLb.font = font3_common_xgw;
    self.telNumberLb.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tel)];
    [self.telNumberLb addGestureRecognizer:tap];
    [self.telView addSubview:self.telNumberLb];
    
    self.telImageView = [[UIImageView alloc]init];
    self.telImageView.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_tel"];
    [self.telView addSubview:self.telImageView];
    
    
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.bgScrollView.frame = CGRectMake(0, self.layoutStartY, kDeviceWidth, kDeviceHeight-49-100);
    self.topView.frame = CGRectMake(0, 0, kDeviceWidth, 372/3);
    self.midView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), kDeviceWidth, 248);
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.midView.frame), kDeviceWidth, 160);
     self.bgScrollView.contentSize = CGSizeMake(kDeviceWidth, self.topView.frame.size.height+self.bottomView.frame.size.height+self.midView.frame.size.height);
    
    self.telView.frame = CGRectMake(0, kDeviceHeight-100, kDeviceWidth, 100);
    
    self.commonMistakeBtn.size = CGSizeMake(100, 20);
    self.commonMistakeBtn.center = CGPointMake(kDeviceWidth/2, self.telView.size.height-self.commonMistakeBtn.size.height/2-20);
    
    UIImage * image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_tel_transactionBlack"];
    
   [self.telNumberLb sizeToFit];
    self.telNumberLb.center = CGPointMake(kDeviceWidth/2+(image.size.width+3)/2,CGRectGetMinY(self.commonMistakeBtn.frame)-20);
    
    
    self.telImageView.frame = CGRectMake(CGRectGetMinX(self.telNumberLb.frame)-image.size.width-3, self.telNumberLb.frame.origin.y, image.size.width, image.size.height);

}

#pragma mark--打开QQ 微信 小E  牛大发
-(void)openCustomServiceWithType:(TapType)type{
    switch (type) {
        case WXType:{
            
            NSURL *url = [NSURL URLWithString:@"weixin://"];
            [self whetherOrNotFixWithUrl:url andType:WXType];
        }
            break;
        case QQType:{

            //跳转QQ群
            NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"287247530",@"e16a0ae1708775c8c76809ed138a2dc244213ca0f542f5d6ac0216aa68850bf7"];
            NSURL *url = [NSURL URLWithString:urlStr];
            //跳转QQ号
//            NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=3349107496&version=1&src_type=web"];

            [self whetherOrNotFixWithUrl:url andType:QQType];

        }
            break;
        case WeChatPublic:{
            NSURL *url = [NSURL URLWithString:@"weixin://"];
            [self whetherOrNotFixWithUrl:url andType:WeChatPublic];

        }
            break;
        case EType:
            [self touchIntelligentRobot];
            break;
        case NType:
            //跳转到牛大发
//            [ContactsNavigationManager navigationToCustomerServiceController:self];
            break;

        default:
            break;
    }
    
}
#pragma mark--判断用户是否安装 QQ 微信
-(void)whetherOrNotFixWithUrl:(NSURL *)url andType:(TapType)type {
    
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    
    if (canOpen) {
//            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }else{
        
        if (type==WXType||type==WeChatPublic) {
            [CMProgress showWarningProgressWithTitle:nil message:@"您的设备未安装微信" warningImage:nil duration:2.0];

        }else if (type ==QQType){
            [CMProgress showWarningProgressWithTitle:nil message:@"您的设备未安装QQ" warningImage:nil duration:2.0];

            
        }
    }
    
    
}
#pragma mark-- 跳转小E
- (void)touchIntelligentRobot
{
//    NSString * urlString = [NSString stringWithFormat:@"http://robot.rxhui.com/?hideTitle=0&userId=%@",[AccountTokenDataStore getAccountToken]];;
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObject:urlString forKey:@"urlString"];
//    [param setObject:@"智能问答机器人" forKey:@"title"];
//
//    [StockNavigationManager navigationToPushWeb:self withParams:param];
//    [MTA trackCustomEvent:@"zx_robot" args:nil];
}
#pragma mark--客服电话
-(void)tel{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-088-5558"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark--跳转常见问题页面
-(void)commonMistakeBtnClick{
    
    NSString * h5Str = @"/questions.html?tabNum=0";
    NSString * host = [CMHttpURLManager getHostIPWithServID:@"h5PageUrl"];
    NSString * url = [NSString stringWithFormat:@"%@%@",host,h5Str];
    
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:url forKey:@"urlString"];
    [param setObject:@"常见问题" forKey:@"title"];
    [param setObject:[NSNumber numberWithInteger:2] forKey:@"webType"];
//    [StockNavigationManager navigationToPushWeb:self withParams:param];
    
    RHWebViewCotroller * webVc = [RHWebViewCotroller new];
    webVc.param = param;
    [self.navigationController pushViewController:webVc animated:YES];
}
-(void)backButtonTouchHandler:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
