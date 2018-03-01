//
//  VideoChatController.h
//  AnyChat
//
//  Created by bairuitech on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>
#import "AnyChatPlatform.h"
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
@protocol VideoChatControllerDelegate <NSObject>

-(void) quitVideo:(NSString*) flag;

@end

@interface VideoChatController : UIViewController <AnyChatStateChangeDelegate,VideoChatControllerDelegate>{
    
    AVCaptureVideoPreviewLayer *localVideoSurface;
    UIImageView *remoteVideoSurface;
    
    int iCurrentChatUserId;     //本地视频用户ID
    int iRemoteUserId;          //远端视频用户ID
    UIButton* buttonLogout;     //退出按钮
    double systemVersion;       //系统版本号
    
    CGFloat _width , _height;
    
    @package
    NSString* globleEmpInfo;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *localVideoSurface;
@property (nonatomic, retain) UIImageView *remoteVideoSurface;
@property (nonatomic, strong) UITextView *messageView;

- (void) OnLocalVideoInit:(id)session;

- (void) OnLocalVideoRelease:(id)sender;

- (void) StartVideoChat:(int) myselfUserId remoteUserId:(int) remoteUserId;
- (void)startmyselfUserId:(int)myselfUserId;
- (void)startremoteUserId:(int)remoteUserId;

- (void) FinishVideoChat;

- (void) setButtonStyle;

- (IBAction) OnFinishVideoChatBtnClicked:(id)sender;

- (void) showEmpinfo:(NSString *)empInfo;
//- (IBAction) OnSwitchCameraBtnClicked:(id)sender;

@end
