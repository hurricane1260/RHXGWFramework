//
//  RHVideoPassController.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/7.
//
//

#import "RHVideoPassController.h"

#import "ApplyFinishView.h"

#import "OARequestManager.h"
#import "MNNavigationManager.h"

@interface RHVideoPassController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

kRhPStrong OARequestManager * requestManager;

kRhPStrong OARequestManager * setManager;

kRhPStrong UIImageView * imgView;

kRhPStrong UILabel * hintLabel;

kRhPStrong UIButton * stepBtn;

@end

@implementation RHVideoPassController

- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = color1_text_xgw;
        self.backButtonHidden = YES;
        self.title = @"视频录制";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    
    [self initSubviews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO;
}


- (void)initSubviews{
    self.imgView = [[UIImageView alloc] initWithImage:img_open_sucSubmit];
    [self.view addSubview:self.imgView];
    
    self.hintLabel = [UILabel didBuildLabelWithText:@"" font:font3_common_xgw textColor:color2_text_xgw wordWrap:NO];
      self.hintLabel.attributedText = [CPStringHandler getStringWithStr:@"视频验证通过，请进行" withColor:color2_text_xgw andAppendString:@"下一步" withColor:color_rec_orange];
    [self.view addSubview:self.hintLabel];
    
    self.stepBtn = [UIButton didBuildOpenAccNextBtnWithTitle:@"下一步"];
    [self.stepBtn addTarget:self action:@selector(nextStepBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stepBtn];
    
    [self.view addAutoLineWithColor:color16_other_xgw];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.imgView.frame = CGRectMake((self.view.width - self.imgView.width ) /2.0f, 147.0f, self.imgView.width, self.imgView.height);
    
    [self.hintLabel sizeToFit];
    self.hintLabel.frame = CGRectMake((self.view.width - self.hintLabel.width)/2.0f, CGRectGetMaxY(self.imgView.frame) + 40.0f, self.hintLabel.width, self.hintLabel.height);
    
    self.stepBtn.frame = CGRectMake((self.view.width - self.stepBtn.width)/2.0f, self.view.height - 14.0f - self.stepBtn.height, self.stepBtn.width, self.stepBtn.height);
    
    self.view.autoLine.frame = CGRectMake(0, self.stepBtn.y - 14.0f, self.view.width, 0.5f);
}

- (void)nextStepBtn{
    self.stepBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.stepBtn.enabled = YES;
    });
    
    [MNNavigationManager navigationToUniversalVC:self withClassName:@"RHQuestionRevisitController" withParam:nil];
}
@end
