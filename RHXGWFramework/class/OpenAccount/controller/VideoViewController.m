//
//  RootViewController.m
//  AnyChatCallCenter
//
//  Created by alex on 14-1-27.
//  Copyright (c) 2014年 GuangZhou BaiRui NetWork Technology Co.,Ltd. All rights reserved.
//

#import "VideoViewController.h"
#import "OARequestManager.h"
#import "CRHVideoServiceVo.h"
#import "RECDashView.h"
#import "RHOpenAccStoreData.h"
#import "MNNavigationManager.h"

#define kLocalVideo_Width                   135.0f
#define kLocalVideo_Height                  135.0f
#define kBar_Height                         30.0f
#define kSelfView_Width                     self.view.frame.size.width
#define kSelfView_Height                    self.view.frame.size.height

#define kLocalVideoPortrait_CGRect          CGRectMake(0, self.layoutStartY, kLocalVideo_Width,kLocalVideo_Height)
#define kLocalVideoLandscape_CGRect         CGRectMake(0, self.layoutStartY, kLocalVideo_Height, kLocalVideo_Width)

#define kRadians(degrees)                   M_PI / 180.0 * degrees
#define kLayer3DRotation_Z_Axis(degrees)    CATransform3DMakeRotation(kRadians(degrees), 0.0, 0.0, 1.0)


@interface VideoViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic)  UIImageView          *aremoteVideoSurface;
@property (strong, nonatomic)  UIView               *atheLocalView;

kRhPStrong UILabel * serviceLabel;
kRhPStrong OARequestManager * pollManager;
kRhPStrong UIButton * cancelBtn;

//kRhPStrong UILabel * hintLabel;

kRhPStrong RECDashView * dashView;

kRhPCopy NSString * client_id;
@end

@implementation VideoViewController

@synthesize iRemoteUserId;
@synthesize remoteVideoSurface;
@synthesize localVideoSurface;
@synthesize theLocalView;
@synthesize endCallBtn;
@synthesize switchCameraBtn;
@synthesize voiceBtn;
@synthesize cameraBtn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"视频录制";
        [self initSubviews];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self StartVideoChat:self.iRemoteUserId];
}

- (void)initSubviews{
   
    self.navigationBar.height = 0;
    self.atheLocalView = [[UIView alloc] init];
//    self.atheLocalView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.atheLocalView];
    
    self.aremoteVideoSurface = [[UIImageView alloc] init];
//    self.aremoteVideoSurface.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.aremoteVideoSurface];
    
    self.serviceLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color2_text_xgw wordWrap:YES];
    [self.view addSubview:self.serviceLabel];
    
//    self.hintLabel = [UILabel didBuildLabelWithText:@"请保持头部在红色虚线框里" font:font3_common_xgw textColor:color_rec_red wordWrap:NO];
//    [self.view addSubview:self.hintLabel];
    
//    [self dashLine:CGRectGetMaxY(self.hintLabel.frame) + 20.0f];
//    [self dashLine:80.0f];

//    self.cancelBtn = [UIButton didBuildB7_1ButtonWithTitle:@"结束通话"];
//    [self.cancelBtn addTarget: self action:@selector(FinishVideoChatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.cancelBtn];
    
    self.dashView = [[RECDashView alloc] init];
    [self.view addSubview:self.dashView];
}

//- (void)drawRect:(CGRect)rect{
//    [self dashLine:80.0f];
//
//}
//
////添加虚线
//-(void)dashLine:(CGFloat)y{
//    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(34.0f ,y)];
//    [path addLineToPoint:CGPointMake(self.view.width - 68.0f, y)];
//    [path addLineToPoint:CGPointMake(self.view.width - 68.0f, y + 400.0f)];
//    [path addLineToPoint:CGPointMake(34.0f, y + 400.0f)];
//    [path addLineToPoint:CGPointMake(34.0f ,y)];
//    CGFloat dash[] = {1.5,1.5};
//    [path setLineDash:dash count:2 phase:0];
//    [color_rec_red setStroke];
//    [path stroke];
//}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.atheLocalView.frame = CGRectMake(0, 0 , self.view.width, self.view.height - kLocalVideo_Height);
    
    CGSize size = [self.serviceLabel.text boundingRectWithSize:CGSizeMake(self.view.width - kLocalVideo_Width - 24.0f, kLocalVideo_Height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1_common_xgw} context:nil].size;
    self.serviceLabel.frame = CGRectMake(12.0f, CGRectGetMaxY(self.atheLocalView.frame) + (kLocalVideo_Height - size.height)/2.0f, size.width, size.height);
    
    self.aremoteVideoSurface.frame = CGRectMake(self.view.width - kLocalVideo_Width, CGRectGetMaxY(self.atheLocalView.frame), kLocalVideo_Width, kLocalVideo_Height);
    
//    [self.hintLabel sizeToFit];
//    self.hintLabel.frame = CGRectMake((self.view.width - self.hintLabel.width)/2.0f, 40.0f, self.hintLabel.width, self.hintLabel.height);
    
    self.dashView.frame = CGRectMake(0, 40.0f, self.view.width, self.atheLocalView.height - 40.0f);

    
//    self.cancelBtn.frame = CGRectMake((self.view.width - self.cancelBtn.width)/2.0f, self.view.height - 10.0f - self.cancelBtn.height, self.cancelBtn.width, self.cancelBtn.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatUserLeaveRoom:) name:@"kChatUserLeaveRoom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelVideo:) name:@"kVideoEndNoti" object:nil];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    [self StartVideoChat:self.iRemoteUserId];

    [self setUIControls];
    
    [self requestVideoServiceInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"视频-------------捕捉到手势退出操作");
    return NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.pollManager cancelAllDelegate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kChatUserLeaveRoom" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kVideoEndNoti" object:nil];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (OARequestManager *)pollManager{
    if (!_pollManager) {
        _pollManager = [[OARequestManager alloc] init];
    }
    return _pollManager;
}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

- (void)requestVideoServiceInfo{
   
    if (!self.client_id.length) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.client_id forKey:@"client_id"];
    [param setObject:@1 forKey:@"task_type"];
    
    __weak typeof(self) welf = self;
    [self.pollManager sendCommonRequestWithParam:param withRequestType:kVideoServiceQuery withUrlString:@"crhVideoServiceQuery" withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHVideoServiceVo class]]) {
                return;
            }
            CRHVideoServiceVo * vo = resultData;
            welf.serviceLabel.text = [NSString stringWithFormat:@"尊敬的客户，您好！我是客户服务中心%@，工号%@，很高兴为您服务!",vo.emp_name,vo.emp_no];
            [welf.view setNeedsLayout];
        }
    }];
    
}



#pragma mark - Memory Warning method

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setUniversalParam:(id)universalParam{
    if (![universalParam isKindOfClass:[NSString class]]) {
        return;
    }
    NSString * rUserId = universalParam;
    self.iRemoteUserId = [rUserId intValue];

}

#pragma mark - UIActionSheet Delegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self FinishVideoChat];

    }
}

#pragma mark - Orientation Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //device orientation
    UIDeviceOrientation devOrientation = [UIDevice currentDevice].orientation;

    if (devOrientation == UIDeviceOrientationLandscapeLeft)
    {
        [self setFrameOfLandscapeLeft];
    }
    else if (devOrientation == UIDeviceOrientationLandscapeRight)
    {
        [self setFrameOfLandscapeRight];
    }
    else if (devOrientation == UIDeviceOrientationPortrait)
    {
        [self setFrameOfPortrait];
    }
}

#pragma mark - Video Rotation

-(void)setFrameOfPortrait
{
//    //Rotate
//    remoteVideoSurface.layer.transform = kLayer3DRotation_Z_Axis(0.0);
//    self.theLocalView.layer.transform = kLayer3DRotation_Z_Axis(0.0);
//    //Scale
//    self.theLocalView.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
//    self.remoteVideoSurface.frame = kLocalVideoPortrait_CGRect;
    
    
    //Rotate
    self.aremoteVideoSurface.layer.transform = kLayer3DRotation_Z_Axis(0.0);
    self.atheLocalView.layer.transform = kLayer3DRotation_Z_Axis(0.0);
    //Scale
    self.atheLocalView.frame = CGRectMake(kLocalVideo_Width, kLocalVideo_Height, self.view.width - kLocalVideo_Width, self.view.height - kLocalVideo_Height);
    self.aremoteVideoSurface.frame = kLocalVideoPortrait_CGRect;

}

-(void)setFrameOfLandscapeLeft
{
//    //Rotate
//    remoteVideoSurface.layer.transform = kLayer3DRotation_Z_Axis(-90.0);
//    self.theLocalView.layer.transform = kLayer3DRotation_Z_Axis(-90.0);
//    //Scale
//    self.theLocalView.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
//    self.remoteVideoSurface.frame = kLocalVideoLandscape_CGRect;
    
    //Rotate
    self.aremoteVideoSurface.layer.transform = kLayer3DRotation_Z_Axis(-90.0);
    self.atheLocalView.layer.transform = kLayer3DRotation_Z_Axis(-90.0);
    //Scale
    self.atheLocalView.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
    self.aremoteVideoSurface.frame = kLocalVideoLandscape_CGRect;
}

-(void)setFrameOfLandscapeRight
{
//    //Rotate
//    remoteVideoSurface.layer.transform = kLayer3DRotation_Z_Axis(90.0);
//    self.theLocalView.layer.transform = kLayer3DRotation_Z_Axis(90.0);
//    //Scale
//    self.theLocalView.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
//    self.remoteVideoSurface.frame = kLocalVideoLandscape_CGRect;
    
    
    //Rotate
    self.aremoteVideoSurface.layer.transform = kLayer3DRotation_Z_Axis(90.0);
    self.atheLocalView.layer.transform = kLayer3DRotation_Z_Axis(90.0);
    //Scale
    self.atheLocalView.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
    self.aremoteVideoSurface.frame = kLocalVideoLandscape_CGRect;
}

#pragma mark - Instance Method


- (void) StartVideoChat:(int) userid
{
    //Get a camera, Must be in the real machine.
    NSMutableArray* cameraDeviceArray = [AnyChatPlatform EnumVideoCapture];
    if (cameraDeviceArray.count > 0)
    {
        [AnyChatPlatform SelectVideoCapture:[cameraDeviceArray objectAtIndex:1]];
    }
    
    // open local video
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_OVERLAY :1];
    [AnyChatPlatform UserSpeakControl: -1:YES];
    [AnyChatPlatform UserCameraControl:-1 : YES];
    [AnyChatPlatform SetVideoPos:-1 :self :0 :0 :0 :0];
    // request other user video
    [AnyChatPlatform UserSpeakControl: userid:YES];
    [AnyChatPlatform UserCameraControl:userid : YES];
    
//    [AnyChatPlatform SetVideoPos:userid: self.remoteVideoSurface:0:0:0:0];
    [AnyChatPlatform SetVideoPos:userid: self.aremoteVideoSurface:0:0:0:0];

    
//    self.iRemoteUserId = userid;
    //远程视频显示时随设备的方向改变而旋转（参数为int型， 0表示关闭， 1 开启[默认]，视频旋转时需要参考本地视频设备方向参数）
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_ORIENTATION : self.interfaceOrientation];
}


- (void) FinishVideoChat
{
    // 关闭摄像头
    [AnyChatPlatform UserSpeakControl: -1 : NO];
    [AnyChatPlatform UserCameraControl: -1 : NO];
    
//    [AnyChatPlatform UserSpeakControl: self.iRemoteUserId : NO];
//    [AnyChatPlatform UserCameraControl: self.iRemoteUserId : NO];
    
    self.iRemoteUserId = -1;
    
//    [AnyChatPlatform LeaveRoom:-1];
//    [AnyChatPlatform Logout];
    
//    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)OnCloseVoiceBtnClicked:(id)sender
{
    if (voiceBtn.selected == NO)
    {
        [AnyChatPlatform UserSpeakControl:-1 :NO];
        voiceBtn.selected = YES;
    }
    else
    {
        [AnyChatPlatform UserSpeakControl: -1:YES];
        voiceBtn.selected = NO;
    }
}

- (IBAction)OnCloseCameraBtnClicked:(id)sender
{
        if ([AnyChatPlatform GetCameraState:-1] == 1)
        {   //open local Camera
            [AnyChatPlatform SetVideoPos:-1 :self :0 :0 :0 :0];
            [AnyChatPlatform UserCameraControl:-1 : YES];
//            self.theLocalView.hidden = NO;
            self.atheLocalView.hidden = NO;
            cameraBtn.selected = NO;
        }
    
        if ([AnyChatPlatform GetCameraState:-1] == 2)
        {   //close local Camera
            [AnyChatPlatform UserCameraControl:-1 :NO];
//            self.theLocalView.hidden = YES;
            self.atheLocalView.hidden = YES;

            cameraBtn.selected = YES;
        }
}

- (void)FinishVideoChatBtnClicked:(id)sender
{
    UIActionSheet *isFinish = [[UIActionSheet alloc]
                               initWithTitle:@"确定结束会话?"
                               delegate:self
                               cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                               otherButtonTitles:@"确定",@"取消", nil];
    isFinish.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [isFinish showInView:self.view];
}

- (IBAction) OnSwitchCameraBtnClicked:(id)sender
{
    static int CurrentCameraDevice = 1;
    NSMutableArray* cameraDeviceArray = [AnyChatPlatform EnumVideoCapture];
    if(cameraDeviceArray.count == 2)
    {
        CurrentCameraDevice = (CurrentCameraDevice+1) % 2;
        [AnyChatPlatform SelectVideoCapture:[cameraDeviceArray objectAtIndex:CurrentCameraDevice]];
    }
    
    [self btnSelectedOnClicked:switchCameraBtn];
}

- (void) OnLocalVideoRelease:(id)sender
{
    if(self.localVideoSurface) {
        self.localVideoSurface = nil;
    }
}

- (void) OnLocalVideoInit:(id)session
{
    self.localVideoSurface = [AVCaptureVideoPreviewLayer layerWithSession: (AVCaptureSession*)session];
//    self.localVideoSurface.frame = CGRectMake(0, 0, kSelfView_Width - kLocalVideo_Width, kSelfView_Height - kLocalVideo_Height);
    self.localVideoSurface.frame = CGRectMake(0, 0, self.atheLocalView.width, self.atheLocalView.height);

    self.localVideoSurface.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
//    [self.theLocalView.layer addSublayer:self.localVideoSurface];
    [self.atheLocalView.layer addSublayer:self.localVideoSurface];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)btnSelectedOnClicked:(UIButton*)button
{
    if (button.selected)
    {
        button.selected = NO;
    }
    else
    {
        button.selected = YES;
    }
}

- (IBAction)changeContentModeFromImageView:(id)sender
{
    if (self.remoteVideoSurface.contentMode == UIViewContentModeScaleAspectFit)
    {
        self.remoteVideoSurface.contentMode = UIViewContentModeScaleAspectFill;
    }
    else if (self.remoteVideoSurface.contentMode == UIViewContentModeScaleAspectFill)
    {
        self.remoteVideoSurface.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void)setUIControls
{
    [switchCameraBtn setBackgroundImage:[UIImage imageNamed:@"Icon_camera_w_b"] forState:UIControlStateSelected];
    
//    //Local View line
//    theLocalView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    theLocalView.layer.borderWidth = 1.0f;
//    //Rounded corners
//    theLocalView.layer.cornerRadius = 4;
//    theLocalView.layer.masksToBounds = YES;
    
    //disable the “idle timer” to avert system sleep.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

// 用户退出房间消息
- (void)chatUserLeaveRoom:(NSNotification *)noti{
   
    NSLog(@"视频验证完成");
//    [CMProgress showWarningProgressWithTitle:nil message:@"视频验证完成" warningImage:nil duration:2];
//    [self FinishVideoChat];
    
    [AnyChatPlatform UserSpeakControl: -1 : NO];
    [AnyChatPlatform UserCameraControl: -1 : NO];
    [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHVideoPassController" withParam:[NSNumber numberWithBool:YES]];

//    [self.navigationController popViewControllerAnimated:NO];

}

- (void)cancelVideo:(NSNotification * )noti{
    NSLog(@"网络断开视频终止");
    NSString * str = noti.object;
    [CMProgress showWarningProgressWithTitle:nil message:str warningImage:nil duration:2];
    [self FinishVideoChat];
    [self.navigationController popViewControllerAnimated:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kQuiteVideoNoti" object:nil];
}
@end
