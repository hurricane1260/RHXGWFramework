//
//  OpenAccountController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/5.
//
//

#import "OpenAccountController.h"
#import "OARequestManager.h"

@interface OpenAccountController ()

kRhPStrong OARequestManager * oAManager;

@end

@implementation OpenAccountController

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (OARequestManager *)oAManager{
    if (!_oAManager) {
        _oAManager = [[OARequestManager alloc] init];
    }
    return _oAManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    
    [self.oAManager sendSMSVerifyCodeWithParam:param withRequestType:kProtocolList withCompletion:^(BOOL success, id resultData) {
        if (success) {
            
            
        }
    }];
}



@end
