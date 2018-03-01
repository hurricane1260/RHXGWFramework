//
//  PresentModalManager.m
//  stockscontest
//
//  Created by 方海龙 on 15-1-15.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "PresentModalManager.h"

@interface PresentModalManager()

@property (nonatomic, strong) UIView *tModalView;

@property (nonatomic, copy) void (^presentCompleteCallback)(void);

@property (nonatomic, copy) void (^dismissCompleteCallback)(void);

@end

@implementation PresentModalManager

static PresentModalManager *instance = nil;

+(PresentModalManager *)shareInstance{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[PresentModalManager alloc] init];
    });
    return instance;
}

+(void)presentModalView:(UIView *)modalView animation:(BOOL)animation completion:(void (^)(void))completion{
    PresentModalManager *aInstance = [PresentModalManager shareInstance];
    [aInstance presentModalViewImpl:modalView animation:animation completion:completion];
}

-(void)presentModalViewImpl:(UIView *)modalView animation:(BOOL)animation completion:(void (^)(void))completion{
    self.presentCompleteCallback = completion;
    
    UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
    
    CGRect startFrame;
    if(animation){
        startFrame = CGRectMake(appWindow.bounds.origin.x, appWindow.bounds.size.height, appWindow.bounds.size.width, appWindow.bounds.size.height);
    }else{
        startFrame = appWindow.bounds;
    }
    
    modalView.frame = startFrame;
    
    [appWindow addSubview:modalView];
    
    if(animation){
        __block __typeof(self) welf = self;
        
        CGRect targetFrame = appWindow.bounds;
        
        [UIView animateWithDuration:0.35f animations:^{
            modalView.frame = targetFrame;
        } completion:^(BOOL finished) {
            [welf presentModalCompleteHandler];
        }];
    }else{
        [self presentModalCompleteHandler];
    }
}

-(void)presentModalCompleteHandler{
    if(self.presentCompleteCallback){
        self.presentCompleteCallback();
        self.presentCompleteCallback = NULL;
    }
}

+(void)dismissModalView:(UIView *)modalView animation:(BOOL)animation completion:(void (^)(void))completion{
    PresentModalManager *aInstance = [PresentModalManager shareInstance];
    [aInstance dismissModalViewImpl:modalView animation:animation completion:completion];
}

-(void)dismissModalViewImpl:(UIView *)modalView animation:(BOOL)animation completion:(void (^)(void))completion{
    self.dismissCompleteCallback = completion;
    self.tModalView = modalView;
    
    UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
    
    CGRect targetFrame = CGRectMake(appWindow.bounds.origin.x, appWindow.bounds.size.height, appWindow.bounds.size.width, appWindow.bounds.size.height);
    
    if(animation){
        __block __typeof(self) welf = self;

        [UIView animateWithDuration:0.35f animations:^{
            modalView.frame = targetFrame;
        } completion:^(BOOL finished) {
            [welf dismissModalCompleteHandler];
        }];
    }else{
        [self dismissModalCompleteHandler];
    }
}


-(void)dismissModalCompleteHandler{
    [self.tModalView removeFromSuperview];
    self.tModalView = nil;
    if(self.dismissCompleteCallback){
        self.dismissCompleteCallback();
        self.dismissCompleteCallback = NULL;
    }
}


@end
