//
//  RHCameraController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/10.
//
//

#import "RHCameraController.h"

#import <AVFoundation/AVFoundation.h>

@interface RHCameraController ()

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
kRhPStrong AVCaptureDevice * device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
kRhPStrong AVCaptureDeviceInput * input;

//当启动摄像头开始捕获输入
kRhPStrong AVCaptureMetadataOutput *output;

kRhPStrong AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
kRhPStrong AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
kRhPStrong AVCaptureVideoPreviewLayer *previewLayer;

kRhPStrong UIButton * photographBtn;

kRhPStrong UILabel * hintLabel;

kRhPStrong UIButton * flashBtn;

kRhPStrong UIButton * changeBtn;

kRhPStrong UIButton * cancelBtn;

kRhPStrong UIView * focusView;

kRhPAssign BOOL canCa;
@end

@implementation RHCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.canCa = [self canUserCamear];

    [self customCamera];
    [self customUI];
}

- (BOOL)canUserCamear{
    AVAuthorizationStatus  authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;


}

- (void)customCamera{
    self.view.backgroundColor = color1_text_xgw;

    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc] init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
     //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [self.device unlockForConfiguration];
    }
    
}

- (void)customUI{
    self.hintLabel = [UILabel didBuildLabelWithText:@"确保证件完全放置在方框内，且文字清晰刻度，并关闭闪光灯" font:font1_common_xgw textColor:color1_text_xgw wordWrap:NO];
    self.hintLabel.backgroundColor = color_clear;
    self.hintLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:self.hintLabel];
    
    self.cancelBtn = [UIButton didBuildButtonWithTitle:@"取消" normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color1_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    [self.cancelBtn addTarget:self action:@selector(cancelPhotograph:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    self.photographBtn = [UIButton didBuildButtonWithNormalImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/photograph"] highlightImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/photograph_Select"]];
    [self.photographBtn setImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/photograph_Select"] forState:UIControlStateSelected];
    [self.photographBtn addTarget:self action:@selector(beginPhotograph:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photographBtn];
    
    self.flashBtn = [UIButton didBuildButtonWithTitle:@"闪光灯" normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color1_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    [self.flashBtn addTarget:self action:@selector(flashClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashBtn];
    
    self.changeBtn = [UIButton didBuildButtonWithTitle:@"切换" normalTitleColor:color1_text_xgw highlightTitleColor:color1_text_xgw disabledTitleColor:color1_text_xgw normalBGColor:color_clear highlightBGColor:color_clear disabledBGColor:color_clear];
    [self.changeBtn addTarget:self action:@selector(changeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changeBtn];

}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.hintLabel sizeToFit];
    self.hintLabel.frame = CGRectMake(0, 20, self.hintLabel.width, self.hintLabel.height);
    
    [self.cancelBtn.titleLabel sizeToFit];
    self.photographBtn.frame = CGRectMake(MAIN_SCREEN_WIDTH*1/2.0-30, MAIN_SCREEN_HEIGHT-100, 60, 60);
    self.cancelBtn.frame = CGRectMake(self.photographBtn.x - self.cancelBtn.titleLabel.width - 20.0f, self.photographBtn.y, self.cancelBtn.titleLabel.width, self.cancelBtn.titleLabel.height);
    
    [self.changeBtn.titleLabel sizeToFit];
    self.changeBtn.frame = CGRectMake(CGRectGetMaxX(self.photographBtn.frame) + 20.0f, self.photographBtn.y, self.changeBtn.titleLabel.width, self.changeBtn.titleLabel.height);
    
//    self.flashBtn.frame =
    

}

- (void)cancelPhotograph:(UIButton *)btn{

}

- (void)beginPhotograph:(UIButton *)btn{

}

- (void)flashClicked:(UIButton *)btn{
    
}

- (void)changeClicked:(UIButton *)btn{
    
}
@end
