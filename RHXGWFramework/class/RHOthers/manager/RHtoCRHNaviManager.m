//
//  RHtoCRHNaviManager.m
//  TZYJ_IPhone
//
//  Created by rxhui on 16/9/21.
//
//

#import "RHtoCRHNaviManager.h"
#import "RHWebViewCotroller.h"
#import <CRHFramework/CRHMainViewController.h>
#import "AccountTokenDataStore.h"

@implementation RHtoCRHNaviManager

+ (void)navigationToCRHOpenAccountWithCurrent:(UIViewController *)currentController {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CRHMainViewController* _mainViewController = [[CRHMainViewController alloc] init];
        
        _mainViewController.type=@"0"; //开户
        _mainViewController.channel = @"xgw";
            //mainViewController.mobileNo = @"13000000000";
        _mainViewController.identifier = @"com.crh.sjkh.chnl";
        _mainViewController.accessKey = @"com.crh.sjkh";
            //mainViewController.delegate = (id<MainViewDelegate>)self;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int date = (long long int)time;
        NSString *timeString = [NSString stringWithFormat:@"%lld", date];
        _mainViewController.agentSequenceId = timeString;
        _mainViewController.topViewColor = [UIColor colorWithRXHexString:@"0xff3b30"];
        
//        [currentController.navigationController pushViewController:_mainViewController animated:YES];
        [currentController presentViewController:_mainViewController animated:NO completion:nil];
            //    [_mainViewController quitSjkh:^(CRHMainViewController *mainViewController) {
            //        [mainViewController dismissViewControllerAnimated:YES completion:nil];
            //    }];
        _mainViewController.mainViewBlock = ^(CRHMainViewController *mainViewController){
            [[NSNotificationCenter defaultCenter]postNotificationName:kCRHPopNotificationName object:nil];
            [mainViewController dismissViewControllerAnimated:NO completion:nil];
//            [mainViewController.navigationController popViewControllerAnimated:YES];
        };
        
    });
}

+ (void)navigationToCRHOpenAccountWithHeadBanner:(UIViewController *)currentController {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CRHMainViewController* _mainViewController = [[CRHMainViewController alloc] init];
        
        _mainViewController.type=@"0"; //开户
        _mainViewController.channel = @"xgw";
            //mainViewController.mobileNo = @"13000000000";
        _mainViewController.identifier = @"com.crh.sjkh.chnl";
        _mainViewController.accessKey = @"com.crh.sjkh";
            //mainViewController.delegate = (id<MainViewDelegate>)self;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int date = (long long int)time;
        NSString *timeString = [NSString stringWithFormat:@"%lld", date];
        _mainViewController.agentSequenceId = timeString;
        _mainViewController.topViewColor = [UIColor colorWithRXHexString:@"0xff3b30"];
//        _mainViewController->imagePickerCamera.view.backgroundColor = [UIColor whiteColor];
//        [currentController.navigationController pushViewController:_mainViewController animated:YES];
        [currentController presentViewController:_mainViewController animated:NO completion:nil];
            //不需要发显示的通知，一级页面自己会判断，只要进来的时候隐藏就可以
//        [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarHiddenNoti object:@1];
//        [_mainViewController quitSjkh:^(CRHMainViewController *mainViewController) {
//            NSLog(@"=_mainViewController quitSjkh=");
//            [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarShowNoti object:@0];
//        }];
        
        _mainViewController.mainViewBlock = ^(CRHMainViewController *mainViewController){
            [[NSNotificationCenter defaultCenter]postNotificationName:kCRHPopNotificationName object:nil];
            [mainViewController dismissViewControllerAnimated:NO completion:nil];
//            [mainViewController.navigationController popViewControllerAnimated:YES];
        };
    });
}

+ (void)navigationToCRHControllerWithCurrent:(UIViewController *)currentController {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        
        NSRange range = [userAgent rangeOfString:@"crhsdk"];
        
        if (range.location == NSNotFound) {
            
            NSString *customUserAgent = [userAgent stringByAppendingFormat:@" %@",@"crhsdk"];
            [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
        }
        
        CRHMainViewController* _mainViewController = [[CRHMainViewController alloc] init];
        
        _mainViewController.type=@"1"; //掌厅
        _mainViewController.channel = @"xgw";
        //        _mainViewController.appId = @"200";
        _mainViewController.identifier = @"com.crh.sjkh.chnl";
        _mainViewController.accessKey = @"com.crh.sjkh";
        //    _mainViewController.mobileNo = _TelePhone.text;
        //    _mainViewController.accessKey = @"3D0DB5B9D2FD642DE37FF42202EC531171A71FC898F8D0D5";
        //        _mainViewController.channel = @"999";
        //mainViewController.delegate = (id<MainViewDelegate>)self;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int date = (long long int)time;
        NSString *timeString = [NSString stringWithFormat:@"%lld", date];
        _mainViewController.agentSequenceId = timeString;
        _mainViewController.topViewColor = [UIColor colorWithRXHexString:@"0x07569f"];
        __block typeof(_mainViewController) blockMainViewController = _mainViewController;
        _mainViewController.openExtraModuleBlock = ^(NSString *identify) {
            NSString * urlString = [NSString stringWithFormat:@"http://robot.rxhui.com/?hideTitle=0&userId=%@",[AccountTokenDataStore getAccountToken]];
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            [param setObject:urlString forKey:@"urlString"];
            [param setObject:@"智能问答机器人" forKey:@"title"];
            RHWebViewCotroller * webVc = [RHWebViewCotroller new];
            webVc.param = param;
            [blockMainViewController presentViewController:webVc animated:NO completion:nil];
        };
        //        [currentController.navigationController pushViewController:_mainViewController animated:YES];
        
        [currentController presentViewController:_mainViewController animated:NO completion:nil];
        
        
        //    [_mainViewController quitSjkh:^(CRHMainViewController *mainViewController) {
        //        [mainViewController dismissViewControllerAnimated:YES completion:nil];
        //    }];
        
        _mainViewController.mainViewBlock = ^(CRHMainViewController *mainViewController){
            
            [mainViewController dismissViewControllerAnimated:NO completion:nil];
//            [mainViewController.navigationController popViewControllerAnimated:YES];
        };
    });
}


+ (void)navigationToCRHOpenAccountEightWithCurrent:(UIViewController *)currentController {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CRHMainViewController* _mainViewController = [[CRHMainViewController alloc] init];
        
        _mainViewController.type=@"0"; //开户
                _mainViewController.channel = @"xycf";
        //mainViewController.mobileNo = @"13000000000";
        _mainViewController.identifier = @"com.crh.sjkh.chnl";
        _mainViewController.accessKey = @"com.crh.sjkh";
        //mainViewController.delegate = (id<MainViewDelegate>)self;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int date = (long long int)time;
        NSString *timeString = [NSString stringWithFormat:@"%lld", date];
        _mainViewController.agentSequenceId = timeString;
        _mainViewController.topViewColor = [UIColor colorWithRXHexString:@"0xff3b30"];
        
        //        [currentController.navigationController pushViewController:_mainViewController animated:YES];
        [currentController presentViewController:_mainViewController animated:NO completion:nil];
        //    [_mainViewController quitSjkh:^(CRHMainViewController *mainViewController) {
        //        [mainViewController dismissViewControllerAnimated:YES completion:nil];
        //    }];
        _mainViewController.mainViewBlock = ^(CRHMainViewController *mainViewController){
            [[NSNotificationCenter defaultCenter]postNotificationName:kCRHPopNotificationName object:nil];
            [mainViewController dismissViewControllerAnimated:NO completion:nil];
            //            [mainViewController.navigationController popViewControllerAnimated:YES];
        };
        
    });
}

@end
