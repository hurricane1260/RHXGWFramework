//
//  RHVideoRECController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/15.
//
//

#import "RHVideoRECController.h"
#import "VideoViewController.h"

#import "AnyChatPlatform.h" 
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"

#import "OARequestManager.h"

#import "CRHUserVideoStausInfoVo.h"
#import <ImageIO/ImageIO.h>
#import "GifView.h"

#import "RHOpenAccStoreData.h"
#import "MNNavigationManager.h"

#define kLocalVideo_Width                   100.0f
#define kLocalVideo_Height                  130.0f
#define kBar_Height                         30.0f
#define kSelfView_Width                     self.view.frame.size.width
#define kSelfView_Height                    self.view.frame.size.height

#define kLocalVideoPortrait_CGRect          CGRectMake(0, self.layoutStartY, kLocalVideo_Width,kLocalVideo_Height)
#define kLocalVideoLandscape_CGRect         CGRectMake(0, self.layoutStartY, kLocalVideo_Height, kLocalVideo_Width)

#define kRadians(degrees)                   M_PI / 180.0 * degrees
#define kLayer3DRotation_Z_Axis(degrees)    CATransform3DMakeRotation(kRadians(degrees), 0.0, 0.0, 1.0)


@interface RHVideoRECController ()<AnyChatNotifyMessageDelegate,AnyChatVideoCallDelegate,AnyChatTextMsgDelegate>

//- (IBAction)sendVideoRequest:(id)sender;
//
//- (IBAction)VideoInfoQuery:(id)sender;
//
//- (IBAction)VideoRelease:(UIButton *)sender;
//
//- (IBAction)uploadVideo:(id)sender;
//
//- (IBAction)queryService:(id)sender;
//
//- (IBAction)stopPing:(id)sender;


//@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;

kRhPStrong AnyChatPlatform *anyChat;

kRhPStrong OARequestManager * manager;

kRhPStrong OARequestManager * pollManager;

kRhPStrong OARequestManager * removeManager;

kRhPStrong CRHUserVideoStausInfoVo * userVideoInfo;

kRhPStrong NSTimer * timer;

kRhPStrong NSTimer * loginTimer;

kRhPAssign int myUserId;

kRhPAssign int rUserId;

kRhPAssign BOOL needRemove;

kRhPAssign BOOL hasNaviToNextPage;

kRhPStrong UIWebView *webView;

kRhPStrong UIButton * cancelBtn;
kRhPAssign int iRemoteUserId;

kRhPStrong UIImageView * imgView;

kRhPStrong GifView *dataView;

kRhPStrong UILabel * hintLabel;

kRhPAssign BOOL needNavi;

kRhPAssign BOOL hasLogin;

kRhPCopy NSString * client_id;

kRhPAssign BOOL isTimeout;

kRhPAssign BOOL canHangUp;
@end

@implementation RHVideoRECController

static int requestNum = 0;

- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = color1_text_xgw;
        self.title = @"视频录制";

//        self.hintLabel.hidden = YES;
        self.needRemove = YES;
        self.hasNaviToNextPage = NO;
        self.needNavi = YES;
        self.hasLogin = NO;
        self.isTimeout = NO;
        self.canHangUp = NO;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerUp:) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantFuture]];
        
        self.loginTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(videoRecAgain) userInfo:nil repeats:YES];
        [self.loginTimer setFireDate:[NSDate distantFuture]];
        
        [self requestBeginVideo];

    }

    return self;
}

- (OARequestManager *)manager{
    if (!_manager) {
        _manager = [[OARequestManager alloc] init];
    }
    return _manager;
}

- (OARequestManager *)pollManager{
    if (!_pollManager) {
        _pollManager = [[OARequestManager alloc] init];
    }
    return _pollManager;
}

- (OARequestManager *)removeManager{
    if (!_removeManager) {
        _removeManager = [[OARequestManager alloc] init];
    }
    return _removeManager;

}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];

    [self initAnychatPlatform];

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kQuiteVideoNoti" object:nil];

    [AnyChatPlatform LeaveRoom:-1];
    [AnyChatPlatform Logout];
    
    self.hasNaviToNextPage = NO;
    self.hasLogin = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kQuiteVideoNoti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quiteVideoWithLinkClose) name:@"kQuiteVideoNoti" object:nil];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelVideo) name:@"kQuiteVideoGesNoti" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
 
    [self.manager cancelAllDelegate];
    [self.pollManager cancelAllDelegate];
    [self.removeManager cancelAllDelegate];
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer invalidate];
    self.timer = nil;
    [self.loginTimer setFireDate:[NSDate distantFuture]];
    [self.loginTimer invalidate];
    self.loginTimer = nil;
    requestNum = 0;
    
    if (self.canHangUp) {
        [self hangUp];
    }
    
    NSLog(@"视频----------%s",__func__);
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kQuiteVideoGesNoti" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kQuiteVideoNoti" object:nil];

}

- (void)initSubviews{
    
//    //得到图片的路径
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"recloading" ofType:@"gif"];
//    //将图片转为NSData
//    NSData *gifData = [NSData dataWithContentsOfFile:path];
//    //创建一个webView，添加到界面
//    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, 210, 323)];
//    [self.view addSubview:self.webView];
//    //自动调整尺寸
//    self.webView.scalesPageToFit = YES;
//    //禁止滚动
//    self.webView.scrollView.scrollEnabled = NO;
//    //设置透明效果
//    self.webView.backgroundColor = [UIColor clearColor];
//    self.webView.opaque = 0;
//    //加载数据
//    [self.webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"recloading" ofType:@"gif"];
    //创建一个第三方的View显示图片
    self.dataView = [[GifView alloc] initWithFrame:CGRectMake(0, 185.0f, 96, 148) filePath:path];
    [self.view addSubview:self.dataView];
    
    self.hintLabel = [UILabel didBuildLabelWithText:@"您前方还有2人排队等待\n请稍后" font:font3_common_xgw textColor:color2_text_xgw wordWrap:YES];
//    self.hintLabel = [UILabel didBuildLabelWithText:@"" font:font3_common_xgw textColor:color2_text_xgw wordWrap:YES];
    self.hintLabel.hidden = YES;
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.numberOfLines = 0 ;
    [self.view addSubview:self.hintLabel];
    
    self.cancelBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@"挂断"];
    [self.cancelBtn addTarget: self action:@selector(cancelVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
        
    self.dataView.frame = CGRectMake((self.view.width - self.dataView.width)/2.0f, 185.0f, 96.0f, 148.0f);
    
    CGSize size = [self.hintLabel.text boundingRectWithSize:CGSizeMake(self.view.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:27]} context:nil].size;

    self.hintLabel.frame = CGRectMake((self.view.width - self.hintLabel.width)/2.0f, CGRectGetMaxY(self.dataView.frame) + 10.0f , size.width, size.height);
    
    self.cancelBtn.frame = CGRectMake((self.view.width - self.cancelBtn.width)/2.0f, self.view.height - 10.0f - self.cancelBtn.height, self.cancelBtn.width, self.cancelBtn.height);
}

- (void)timerUp:(NSTimer *)timer{
    [self requestConnectInfo];
}

- (void)videoRecAgain{
    if (self.isTimeout) {
        NSLog(@"视频进入倒计时结束------------");
        [CMProgress showWarningProgressWithTitle:nil message:@"视频接入超时，请重新开始视频" warningImage:nil duration:2.0f];
        self.isTimeout = NO;
        [self cancelVideo];
    }
    else{
        NSLog(@"视频进入倒计时开始------------");
        self.isTimeout = YES;
    }
}

- (void)requestBeginVideo{
  
    if (!self.client_id.length) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"userId"];
    [param setObject:@10 forKey:@"orgCode"];
    [param setObject:@1 forKey:@"type"];
    NSString * appId = [[NSBundle mainBundle] bundleIdentifier];
    [param setObject:appId forKey:@"appIds"];
    [param setObject:@"1.2.20141029" forKey:@"version"];
    [param setObject:@0 forKey:@"fromServer"];
    
    __weak typeof (self) welf = self;
    [self.manager sendCommonRequestWithParam:param withRequestType:kBeginVideoRequest withUrlString:@"crhBeginVideoRequest" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            NSLog(@"视频请求成功");
            [welf requestConnectInfo];
        }
    }];

}

- (void)requestConnectInfo{
    self.userVideoInfo = nil;
    
    if (!self.client_id.length) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"userId"];
    [param setObject:@0 forKey:@"queryFlag"];
    __weak typeof (self) welf = self;
    static int j = 0;
    NSLog(@"-------------查询用户视频状态%d",j++);
    [self.pollManager sendCommonRequestWithParam:param withRequestType:kUserVedioStatusInfoQuery withUrlString:@"crhUserVedioStatusInfoQuery" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHUserVideoStausInfoVo class]]) {
                return;
            }
            welf.userVideoInfo = resultData;
            if ([welf.userVideoInfo.status isEqualToString:@"0"]) {
                
                welf.hintLabel.text = [NSString stringWithFormat:@"您前方还有%@人排队等待\n请稍后",welf.userVideoInfo.waitNum];
               NSString * midStr = [NSString stringWithFormat:@"%@",welf.userVideoInfo.waitNum];
                self.hintLabel.attributedText = [CPStringHandler getStringWithStr:@"您前方还有" withFont:font2_common_xgw withColor:color2_text_xgw andMidString:midStr withFont:[UIFont boldSystemFontOfSize:27.0f] withColor:color6_text_xgw AppendString:@"人排队等待\n请稍后" withFont:font2_common_xgw withColor:color2_text_xgw];
                welf.hintLabel.hidden = NO;

                if (requestNum == 0) {
                    [welf.timer setFireDate:[NSDate distantPast]];
                    requestNum++;
                }
            }
            else if ([welf.userVideoInfo.status isEqualToString:@"1"]){
                welf.needRemove = NO;
//                welf.hintLabel.hidden = YES;
                welf.hintLabel.text = @"正在接入视频，请稍候";
                [welf.timer setFireDate:[NSDate distantFuture]];
                [welf.loginTimer setFireDate:[NSDate distantPast]];

//                [welf requestRemoveUser];
                
                [welf anyChatConnectSever];
            }
        }
        else{
            [CMProgress showWarningProgressWithTitle:nil message:@"请求视频失败" warningImage:nil duration:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [welf.view setNeedsLayout];
    }];

}

- (void)requestRemoveUser{
    if (!self.client_id.length) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"user_id"];
    
    [self.removeManager sendCommonRequestWithParam:param withRequestType:kRemoveUser withUrlString:@"crhRemoveUser" withCompletion:^(BOOL success, id resultData) {
        if (!success) {
            [CMProgress showEndProgressWithTitle:@"移除队列失败" message:nil endImage:nil duration:1.0f];
        }
        self.needRemove = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)requestUserStatus{
    if (!self.client_id.length) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id    forKey:@"client_id"];
    __weak typeof (self) welf = self;
    [self.manager sendCommonRequestWithParam:param withRequestType:kQueryUserStatus withUrlString:@"crhOpenAccStatusQuery" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            //检查开户状态 恢复到相应的场景跳转
            //            open_status状态位：证件照上传、基本资料提交、视频见证完成、协议已签署、账户设置、存管设置、暂未定义、风险问卷、回访设置、密码设置
            //            标识位：常规：0：未处理，1：已处理
            //            标识位：第3位视频见证完成：0：未见证、1：未定义、2：视频见证完成、3：见证失败
            //            1101011111
            if (!resultData || ![resultData isKindOfClass:[NSString class]]) {
                [self backButtonTouchHandler:nil];
                return;
            }
            NSString * status = resultData;
            NSString * videoStu = [status substringWithRange:NSMakeRange(2, 1)];
            switch ([videoStu integerValue]) {
                case 0:
                case 1:
                    [welf backButtonTouchHandler:nil];
                    break;
                case 2:
                    [welf naviToPassVC:YES];
                case 3:
//                    [welf naviToFailVC];
                    [welf naviToPassVC:NO];

                default:
                    break;
            }
            
        }
    }];


}

- (AnyChatPlatform *)anyChat{
    if (!_anyChat) {
        _anyChat = [AnyChatPlatform new];
    }
    return _anyChat;
}

- (void)initAnychatPlatform{
    
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(AnyChatNotifyHandler:) name:@"ANYCHATNOTIFY" object:nil];
    
    //初始化SDK
//    self.anyChat = [AnyChatPlatform new];
    //AnyChat通知消息代理(回调事件接收者)
    self.anyChat.notifyMsgDelegate = self;
    self.anyChat.videoCallDelegate = self;
    self.anyChat.textMsgDelegate = self;
    // 连接服务器,第一个参数为你需要连接的 AnyChat 核心服务器地址,如果您部署 AnyChat 核心服务器 的地址为 192.168.1.8,则传入这个地址;第二个参数为端口号
    
}

- (void)anyChatConnectSever{
    [AnyChatPlatform Connect:self.userVideoInfo.anyChatStreamIpOut :[self.userVideoInfo.anyChatStreamPort intValue]];
//    [AnyChatPlatform Connect:@"demo.anychat.cn":@"8906"];
//    //登录服务器
//    [AnyChatPlatform Login:@"userName":@""];

}

//消息观察者方法
- (void)AnyChatNotifyHandler:(NSNotification*)notify {
    NSDictionary* dict = notify.userInfo;
    [self.anyChat OnRecvAnyChatNotify:dict];
}

#pragma mark ---------AnyChatDelegate

// 连接服务器消息
- (void) OnAnyChatConnect:(BOOL) bSuccess{
    NSLog(@"视频---------------连接服务器成功 %d",bSuccess);
    if (bSuccess) {
        if (!self.userVideoInfo) {
            return;
        }
        [AnyChatPlatform Login:self.userVideoInfo.userName :self.userVideoInfo.loginPwd];
    }
}

// 用户登陆消息
- (void) OnAnyChatLogin:(int) dwUserId : (int) dwErrorCode{
    NSLog(@"视频---------------登录服务器成功 %d",dwErrorCode);

    if(dwErrorCode == GV_ERR_SUCCESS)
    {
        if (!self.userVideoInfo) {
            return;
        }
        self.myUserId = dwUserId;
//        if (!self.hasLogin) {
            [AnyChatPlatform EnterRoom:[self.userVideoInfo.roomId intValue] :self.userVideoInfo.roomPwd];
            NSLog(@"视频---------%s %d",__func__, dwUserId);
//            self.hasLogin = YES;
//        }
        
    }

}

// 用户进入房间消息  当客户端请求进入房间时被触发
- (void) OnAnyChatEnterRoom:(int) dwRoomId : (int) dwErrorCode{
    if (dwErrorCode != 0) {
        NSLog(@"进入房间失败");
        return;
    }

    if (!self.userVideoInfo) {
        return;
    }
    
    //拍照最佳像素
//    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_WIDTHCTRL :1280];
//    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_HEIGHTCTRL :720];
    
    //码率
//    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_BITRATECTRL :150000];
    [AnyChatPlatform SetSDKOptionString:BRAC_SO_LOCALVIDEO_BITRATECTRL :@"230000"];
    //分辨率
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_WIDTHCTRL :640];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_HEIGHTCTRL :480];
    //帧率
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_FPSCTRL :25];
    //参数设置生效
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_APPLYPARAM :1];
    
    
    NSInteger num = [AnyChatPlatform GetOnlineUser].count;
    NSLog(@"视频----------%s %ld %@ ",__func__,num,[AnyChatPlatform GetRoomOnlineUsers:dwRoomId]);
    
    if (num == 1) {
        if (!self.hasLogin) {
//            int remoteId = [[AnyChatPlatform GetRoomOnlineUsers:dwRoomId][0] intValue];
            NSArray * roomUserArray = [AnyChatPlatform GetRoomOnlineUsers:dwRoomId];
            if (!roomUserArray.count) {
                return;
            }
            int remoteId = [roomUserArray[0] intValue];
            self.userVideoInfo.remoteId = [NSString stringWithFormat:@"%d",remoteId];
//            [AnyChatPlatform VideoCallControl:BRAC_VIDEOCALL_EVENT_REQUEST :remoteId :0 :0 :0 :nil];
            NSLog(@"视频----------发起视频请求");
            [MNNavigationManager navigationToUniversalVC:self withClassName:@"VideoViewController" withParam:self.userVideoInfo.remoteId];

            self.hasLogin = YES;
        }
    }

}

// 房间在线用户消息 进入房间后触发一次。收到该消息后,便可对房间中的用户进行音视频 的相关操作,如请求音频、请求视频等
- (void) OnAnyChatOnlineUser:(int) dwUserNum : (int) dwRoomId{
    NSInteger num = [AnyChatPlatform GetOnlineUser].count;
    NSLog(@"视频----------%s %ld %@ %d",__func__,num,[AnyChatPlatform GetRoomOnlineUsers:dwRoomId],dwUserNum);
    
    
    if (dwUserNum == 1) {
        if (!self.hasLogin) {
            NSArray * roomUserArray = [AnyChatPlatform GetRoomOnlineUsers:dwRoomId];
            if (!roomUserArray.count) {
                return;
            }
            int remoteId = [roomUserArray[0] intValue];
            self.userVideoInfo.remoteId = [NSString stringWithFormat:@"%d",remoteId];
//            [AnyChatPlatform VideoCallControl:BRAC_VIDEOCALL_EVENT_REQUEST :remoteId :0 :0 :0 :nil];
            NSLog(@"视频----------发起视频请求");
            [MNNavigationManager navigationToUniversalVC:self withClassName:@"VideoViewController" withParam:self.userVideoInfo.remoteId];

            self.hasLogin = YES;
        }
    }
}


// 用户进入房间消息 有新的用户进入房间会触发该接口
- (void) OnAnyChatUserEnterRoom:(int) dwUserId{
    NSMutableArray * arr = [AnyChatPlatform GetOnlineUser];
    NSInteger num = [AnyChatPlatform GetOnlineUser].count;
    NSLog(@"视频----------%s %ld %@ %d %@",__func__,num,[AnyChatPlatform GetOnlineUser],dwUserId,self.userVideoInfo.remoteId);

//    if (dwUserId == [self.userVideoInfo.remoteId intValue]) {
//        [MNNavigationManager navigationToUniversalVC:self withClassName:@"VideoViewController" withParam:self.userVideoInfo.remoteId];
//    }

}

// 用户退出房间消息 当成功进入房间之后,有其它的用户离开房间会触发该接口
- (void) OnAnyChatUserLeaveRoom:(int) dwUserId{
    if (dwUserId == [self.userVideoInfo.remoteId intValue]) {
        
        NSLog(@"坐席退出房间了 可能是视频通过 也可能是异常退出 %s",__func__);

        [[NSNotificationCenter defaultCenter] postNotificationName:@"kVideoEndNoti" object:@"坐席退出了房间"];


        [self quiteVideoWithLinkClose];
    }

    self.hasNaviToNextPage = NO;

}

// 网络断开消息
- (void) OnAnyChatLinkClose:(int) dwErrorCode{
    NSLog(@"网络断开消息 %s",__func__);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"kVideoEndNoti" object:@"网络断开"];
    [self quiteVideoWithLinkClose];

//    [AnyChatPlatform LeaveRoom:-1];
//    [AnyChatPlatform Logout];
}

//- (void) OnAnyChatVideoCallEventCallBack:(int) dwEventType : (int) dwUserId : (int) dwErrorCode : (int) dwFlags : (int) dwParam : (NSString*) lpUserStr{
//    
////    // 视频呼叫事件类型定义（API：BRAC_VideoCallControl 传入参数、VideoCallEvent回调参数）
////#define BRAC_VIDEOCALL_EVENT_REQUEST              1        ///< 呼叫请求
////#define BRAC_VIDEOCALL_EVENT_REPLY                2        ///< 呼叫请求回复
////#define BRAC_VIDEOCALL_EVENT_START                3        ///< 视频呼叫会话开始事件
////#define BRAC_VIDEOCALL_EVENT_FINISH               4        ///< 挂断（结束）呼叫会话
////    
////    // 视频呼叫标志定义（API：BRAC_VideoCallControl 传入参数）
////#define BRAC_VIDEOCALL_FLAGS_AUDIO             0x01        ///< 语音通话
////#define BRAC_VIDEOCALL_FLAGS_VIDEO             0x02        ///< 视频通话
////#define BRAC_VIDEOCALL_FLAGS_FBSRCAUDIO        0x10        ///< 禁止源（呼叫端）音频
////#define BRAC_VIDEOCALL_FLAGS_FBSRCVIDEO        0x20        ///< 禁止源（呼叫端）视频
////#define BRAC_VIDEOCALL_FLAGS_FBTARAUDIO        0x40        ///< 禁止目标（被呼叫端）音频
////#define BRAC_VIDEOCALL_FLAGS_FBTARVIDEO        0x80        ///< 禁止目标（被呼叫端）视频
////    
////    // 视频呼叫
////#define AC_ERROR_VIDEOCALL_CANCEL             100101       ///< 源用户主动放弃会话
////#define AC_ERROR_VIDEOCALL_OFFLINE            100102       ///< 目标用户不在线
////#define AC_ERROR_VIDEOCALL_BUSY               100103       ///< 目标用户忙
////#define AC_ERROR_VIDEOCALL_REJECT             100104       ///< 目标用户拒绝会话
////#define AC_ERROR_VIDEOCALL_TIMEOUT            100105       ///< 会话请求超时
////#define AC_ERROR_VIDEOCALL_DISCONNECT         100106       ///< 网络断线
//    
//    NSLog(@"视频----------%s  在线人数%@ 用户id%d 目标id%@ 状态%d %d %@",__func__,[AnyChatPlatform GetOnlineUser],dwUserId,self.userVideoInfo.remoteId,dwEventType,dwErrorCode,lpUserStr);
//    NSString * str;
//
//    if (dwEventType == BRAC_VIDEOCALL_EVENT_REPLY) {
//        switch (dwErrorCode) {
//            case 0:{
//                NSLog(@"视频----------跳视频页判断");
//                if (!self.hasNaviToNextPage) {
//                    NSLog(@"视频----------跳视频页");
//                    [MNNavigationManager navigationToUniversalVC:self withClassName:@"VideoViewController" withParam:self.userVideoInfo.remoteId];
//                    self.hasNaviToNextPage = YES;
//                }
//            }break;
//            case AC_ERROR_VIDEOCALL_CANCEL:
//                str = @"源用户主动放弃会话";
////                NSLog(@"视频 -----------源用户主动放弃会话");
//            case AC_ERROR_VIDEOCALL_OFFLINE:
//                str = @"目标用户不在线";
////                NSLog(@"视频 -----------目标用户不在线");
//
//            case AC_ERROR_VIDEOCALL_BUSY:
//                str = @"目标用户忙";
//
////                NSLog(@"视频 -----------目标用户忙");
//
//            case AC_ERROR_VIDEOCALL_REJECT:
//                str = @"目标用户拒绝会话";
//
////                NSLog(@"视频 -----------目标用户拒绝会话");
//
//            case AC_ERROR_VIDEOCALL_TIMEOUT:
//                str = @"会话请求超时";
//
////                NSLog(@"视频 -----------会话请求超时");
//
//            case AC_ERROR_VIDEOCALL_DISCONNECT:
//                str = @"网络断线";
//
////                NSLog(@"视频 -----------网络断线");
//                self.canHangUp = YES;
//                NSLog(@"视频----------以上情况为目标用户未连接成功或断开 或网络断开");
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"kVideoEndNoti" object:str];
//                break;
//            default:
//                break;
//        }
//    }
//    else if (dwEventType == BRAC_VIDEOCALL_EVENT_START){
//        NSLog(@"视频----------视频开始 ");
//        
//    }
//    else if (dwEventType == BRAC_VIDEOCALL_EVENT_FINISH){
//        NSLog(@"视频----------呼叫结束挂断");
//    
//    }
//}

// 发送文字的回调函数
- (void) OnAnyChatTextMsgCallBack:(int) dwFromUserid : (int) dwToUserid : (BOOL) bSecret : (NSString*) lpMsgBuf{
    NSLog(@"视频----------%s  %@",__func__,lpMsgBuf);

    //视频验证是否成功
//    unverified;基本资料有误:    unverified;风险评测信息有误: unverified;三方存管信息有误: unverified;账户选择信息有误: unverified;证件照采集失败:  unverified;其他:   公安验证  unverified;公安认证信息不一致:     用户中断无提示
    
    if ([lpMsgBuf containsString:@"unverified"]) {
        if (lpMsgBuf.length > 11) {
            //根据提示内容返回到相应问题页面
            NSString * msg = [lpMsgBuf substringFromIndex:11];
            
            NSString * class;
            if ([msg containsString:@"基本资料"] || [msg containsString:@"证件照采集"] || [msg containsString:@"公安认证"] || [msg containsString:@"其他"])//|| [msg containsString:@"风险评测"] || [msg containsString:@"账户选择信息"] || [msg containsString:@"三方存管"] || [msg containsString:@"其他"]
            {
                //跳上传图片
                class = @"RHIDCardController";
            }
            else if([msg containsString:@"风险评测"]){
                
                class = @"RHRiskEvaluationController";
            }
            else if([msg containsString:@"账户选择信息"]){
                
                class = @"RHAccountPasswordController";
            }
            else if([msg containsString:@"三方存管"]){
                
                class = @"RHBankCardBindController";
            }
            else{

                class = @"RHReadyToRECController";
            }
            for (BaseViewController *VC in self.navigationController.viewControllers) {
                if ([VC isKindOfClass:NSClassFromString(class)]) {
                    [self hangUp];
//                    self.canHangUp = YES;
                    [self.navigationController popToViewController:VC animated:YES];
                    return;
                }
            }
            
            if (class.length) {
                [self hangUp];
//                self.canHangUp = YES;
                NSMutableDictionary * param = [NSMutableDictionary dictionary];
                [param setObject:@1 forKey:@"hiddenBack"];
                [param setObject:@0 forKey:@"hasPrePage"];
                [MNNavigationManager navigationToUniversalVC:self withClassName:class withParam:param];
                return;
            }
        }
    }
    else if ([lpMsgBuf containsString:@"verified"]){

        NSLog(@"视频---------------验证通过");
        if (self.needNavi) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kChatUserLeaveRoom" object:nil];

            [self hangUp];
//            self.canHangUp = YES;
//            self.needNavi = NO;
//                [self naviToPassVC:YES];
            return;
        }
    }
    else{
//        尊敬的客户,您好。我是客户服务中心龚山艳,工号066000,很高兴为您服务
    }
}

- (void)backButtonTouchHandler:(id)sender{
    if (self.needRemove) {
//        [self requestRemoveUser];
        self.needRemove = NO;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hangUp{
    [AnyChatPlatform Logout];
    self.anyChat = nil;

}

- (void)cancelVideo{
    NSLog(@"--------------结束视频");
//    [self hangUp];
    self.canHangUp = YES;
    
    for (BaseViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:NSClassFromString(@"RHReadyToRECController")]) {
            [self.navigationController popToViewController:VC animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)naviToPassVC:(BOOL)isSuccess{
    [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHVideoPassController" withParam:[NSNumber numberWithBool:isSuccess]];
}

- (void)quiteVideoWithLinkClose{
    NSLog(@"视频---------接收了关闭的消息");
    self.canHangUp = YES;
    [self backButtonTouchHandler:nil];

}
@end
