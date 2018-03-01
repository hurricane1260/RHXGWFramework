//
//  RHReadyToRECController.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/5.
//
//

#import "RHReadyToRECController.h"

#import <AVFoundation/AVFoundation.h>

#import "OARequestManager.h"

#import "RECHintView.h"

#import "MNNavigationManager.h"

@interface RHReadyToRECController ()<UIAlertViewDelegate>

- (IBAction)beginVideoRec:(id)sender;
kRhPStrong  UIButton * beginVideoBtn;

//kRhPStrong OARequestManager * manager;

kRhPAssign BOOL isAuthCamera;

kRhPAssign BOOL isAuthMicro;

kRhPAssign NSInteger num;

kRhPStrong RECHintView * hintView;

kRhPStrong UIScrollView * bottomScrollow;

kRhPStrong UIButton * backToStepBtn;

kRhPAssign BOOL needRectify;

@end

@implementation RHReadyToRECController

- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = color1_text_xgw;
        self.title = @"视频录制";
        self.needRectify = NO;

        [self initSubviews];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self checkMicroAndCameraStatus];

}

- (void)initSubviews{
    
    __weak typeof(self) welf = self;

    self.bottomScrollow = [[UIScrollView alloc] init];
    [self.view addSubview: self.bottomScrollow];
    
    self.hintView = [[RECHintView alloc] init];
    self.hintView.heightCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"height"]) {
            welf.hintView.height = [[param objectForKey:@"height"] floatValue];
            [welf.view setNeedsLayout];
        }
    };
    [self.bottomScrollow addSubview:self.hintView];
    
    self.beginVideoBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@"开始视频"];
    [self.beginVideoBtn addTarget:self action:@selector(beginVideoRec:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.beginVideoBtn];

    [self.view addAutoLineWithColor:color16_other_xgw];
    
    self.backToStepBtn = [[UIButton alloc] init];
    [self.backToStepBtn addTarget:self action:@selector(backToStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backToStepBtn];
    
    
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"重新上传证件信息"];
//    NSRange titleRange = {0,[title length]};
//    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
//    [self.backToStepBtn setAttributedTitle:title
//                      forState:UIControlStateNormal];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.bottomScrollow.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY - 28.0f - self.beginVideoBtn.height);
    
    self.hintView.frame = CGRectMake(0, 47.0f, self.bottomScrollow.width, self.hintView.height);
//    self.hintView.frame = CGRectMake(0, 0, self.bottomScrollow.width, 336.0f);
    
    self.bottomScrollow.contentSize = CGSizeMake(self.bottomScrollow.width, self.hintView.height);
    
    self.beginVideoBtn.frame = CGRectMake((self.view.width - self.beginVideoBtn.width)/2.0f, self.view.height - self.beginVideoBtn.height - 10.0f, self.beginVideoBtn.width, self.beginVideoBtn.height);

    self.view.autoLine.frame = CGRectMake(0, self.beginVideoBtn.y - 14.0f, self.view.width, 0.5f);
    
    self.backToStepBtn.frame = CGRectMake((self.view.width -  self.backToStepBtn.titleLabel.width)/2.0f, self.bottomScrollow.autoLine.y - 20.0f - self.backToStepBtn.titleLabel.height, self.backToStepBtn.titleLabel.width, self.backToStepBtn.titleLabel.height);
}

- (void)checkMicroAndCameraStatus{
    
    __weak typeof(self)welf = self;
    self.num = 0;
    [RHReadyToRECController checkCameraAuthorizationGrand:^{
        welf.isAuthCamera = YES;
        if(welf.isAuthMicro){
            welf.beginVideoBtn.enabled = YES;
            [welf.view setNeedsLayout];
        }
        welf.num++;
        [welf showMicroAndCamera];

        
    } withNoPermission:^{
        
        welf.isAuthCamera = NO;
        welf.beginVideoBtn.enabled = NO;
        [welf.view setNeedsLayout];

        welf.num++;
        
        [welf showMicroAndCamera];
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"相机授权" message:@"未授权使用相机，请前往设置允许使用，才可进行视频认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
//
//        NSLog(@"未授权使用相机和麦克风，请前往设置允许使用，才可进行视频认证");
    }];

    
    [RHReadyToRECController checkMicroAuthorizationGrand:^{
        welf.isAuthMicro = YES;
        
        if(welf.isAuthCamera){
            
            welf.beginVideoBtn.enabled = YES;
            [welf.view setNeedsLayout];
        }
        welf.num++;
        [welf showMicroAndCamera];

    } withNoPermission:^{
        welf.isAuthMicro = NO;
        welf.beginVideoBtn.enabled = NO;
        [welf.view setNeedsLayout];

        welf.num++;
        [welf showMicroAndCamera];

//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"麦克风授权" message:@"未授权使用麦克风，请前往设置允许使用，才可进行视频认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
//        
//        NSLog(@"未授权使用相机和麦克风，请前往设置允许使用，才可进行视频认证");

    }];
}

- (void)showMicroAndCamera{
    if (self.num != 2 || (self.isAuthMicro && self.isAuthCamera)) {
        return;
    }
        NSString * title;
        NSString * message;
    
    
        if (!self.isAuthMicro && !self.isAuthCamera) {
            title = @"相机、麦克风授权";
            message = @"未授权使用相机和麦克风，请前往设置允许使用，才可进行视频认证";
        }
        else if(!self.isAuthCamera){
            title = @"相机授权";
            message = @"未授权使用相机，请前往设置允许使用，才可进行视频认证";
        
        }
        else if (!self.isAuthMicro){
            title = @"麦克风授权";
            message = @"未授权使用麦克风，请前往设置允许使用，才可进行视频认证";
        
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
   
}

/**
 检测相机的方法
 @param permissionGranted 相机授权成功执行的方法
 @param noPermission 相机授权失败或者未授权执行的方法
 */
+ (void)checkCameraAuthorizationGrand:(void (^)())permissionGranted withNoPermission:(void (^)())noPermission{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoAuthStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            //第一次提示用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                granted ? permissionGranted() : noPermission();
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            //通过授权
            permissionGranted();
            break;
        }
        case AVAuthorizationStatusRestricted:
            //不能授权
            NSLog(@"不能完成授权，可能开启了访问限制");
        case AVAuthorizationStatusDenied:{
            //提示跳转到相机设置(这里使用了blockits的弹窗方法）
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"相机授权" message:@"跳转相机授权设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//            [alert show];
            noPermission();
           
        }
            break;
        default:
            break;
    }
}

/**
 检测麦克风的方法
 @param microRermissionGranted 麦克风授权成功执行的方法
 @param microNoPermission 麦克风授权失败或者未授权执行的方法
 */
+ (void)checkMicroAuthorizationGrand:(void (^)())microRermissionGranted withNoPermission:(void (^)())microNoPermission{
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (audioAuthStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            //第一次提示用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                granted ? microRermissionGranted() : microNoPermission();
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            //通过授权
            microRermissionGranted();
            break;
        }
        case AVAuthorizationStatusRestricted:
            //不能授权
            NSLog(@"不能完成授权，可能开启了访问限制");
        case AVAuthorizationStatusDenied:{
//            //提示跳转到相机设置(这里使用了blockits的弹窗方法）
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"麦克风授权" message:@"跳转麦克风授权设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//            [alert show];
            microNoPermission();
            
        }
            break;
        default:
            break;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //请求授权
        [self requetSettingForAuth];
    }

}

- (void)requetSettingForAuth{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([ [UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)beginVideoRec:(id)sender {
    self.beginVideoBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.beginVideoBtn.enabled = YES;
    });
    
    [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHVideoRECController" withParam:nil];
    
}

- (void)backToStep:(UIButton *)btn{


}
@end
