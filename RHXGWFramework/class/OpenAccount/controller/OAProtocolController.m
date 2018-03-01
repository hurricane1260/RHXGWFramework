//
//  OAProtocolController.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 17/5/12.
//
//

#import "OAProtocolController.h"
#import "CRHProtocolListVo.h"
#import "OARequestManager.h"
#import "RHOpenAccStoreData.h"

@interface OAProtocolController ()<UIWebViewDelegate>

kRhPCopy NSString * showProtocol;

kRhPStrong OARequestManager * oAManager;

//kRhPStrong UIScrollView * backScrollow;
//
//kRhPStrong TTTAttributedLabel * showLabel;

kRhPStrong CRHProtocolListVo * protocolVo;

kRhPStrong UIWebView * webView;

kRhPCopy NSString * client_id;
@end

@implementation OAProtocolController

- (instancetype)init{
    if (self = [super init]) {
        self.title = @"开户协议";
        [self initSubviews];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestProtocolContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.oAManager cancelAllDelegate];

}

- (void)initSubviews{
//    self.backScrollow = [[UIScrollView alloc] init];
//    [self.view addSubview:self.backScrollow];
//    
//    self.showLabel = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font1_common_xgw textColor:color2_text_xgw wordWrap:YES];
//    self.showLabel.numberOfLines = 0;
//    [self.backScrollow addSubview:self.showLabel];

    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
//    self.backScrollow.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
//    
//    self.showLabel.frame = CGRectMake(24.0, 0, self.showLabel.width, self.showLabel.height);
//    
//    self.backScrollow.contentSize = CGSizeMake(self.backScrollow.width, self.showLabel.height /10.0f);

    self.webView.frame = CGRectMake(0, self.layoutStartY, self.view.width, self.view.height - self.layoutStartY);
}

- (void)setUniversalParam:(id)universalParam{
    if (!universalParam) {
        return;
    }
//    //区分显示开户协议还是三方存管协议
    if ([universalParam isKindOfClass:[NSDictionary class]]) {
        //开户相关协议
        NSDictionary * param = universalParam;
        if ([param objectForKey:@"protocol"]) {
            self.showProtocol = @"开户相关协议";
            self.protocolVo = [param objectForKey:@"protocol"];
        }
        else if ([param objectForKey:@"match"]){
            self.protocolVo = [param objectForKey:@"match"];
            self.showProtocol = self.protocolVo.econtract_name;
        }

    }
    else if ([universalParam isKindOfClass:[CRHProtocolListVo class]]){
        self.showProtocol = @"三方存管协议";
        self.protocolVo = universalParam;

    }
    
    self.title = self.showProtocol;
    
}

- (NSString *)client_id{
    if (!_client_id) {
        _client_id = [RHOpenAccStoreData getOpenAccCachUserInfoWithKey:kOpenAccClientId];
    }
    
    return _client_id;
}

- (OARequestManager *)oAManager{
    if (!_oAManager) {
        _oAManager = [[OARequestManager alloc] init];
    }
    return _oAManager;
}


//请求内容
- (void)requestProtocolContent{
    if (!self.protocolVo) {
        return;
    }
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:self.protocolVo.econtract_id forKey:@"econtract_id"];
    
    if (self.client_id.length) {
        [param setObject:self.client_id forKey:@"client_id"];
    }
    
    [self.oAManager requestProtocolContentWithParam:param withRequestType:kProtocolContent withCompletion:^(BOOL success, id resultData) {
        if (success) {
            if (!resultData || ![resultData isKindOfClass:[CRHProtocolListVo class]]) {
                return;
            }
            //vo.econtract_content即协议内容
            CRHProtocolListVo * vo = resultData;
//            [self loadProtocolContent:vo];
            
            [self.webView loadHTMLString:vo.econtract_content baseURL:nil];
            [self.view setNeedsLayout];

        }
        else{
            [CMProgress showWarningProgressWithTitle:nil message:@"获取协议失败" warningImage:nil duration:2];
            
        }
    }];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.9"];

    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];//修改百分比即可
}



//- (void)loadProtocolContent:(CRHProtocolListVo *)vo{
//    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[vo.econtract_content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
//    [paragraph setLineSpacing:6];
//    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attrStr.string.length)];
//    self.showLabel.attributedText = attrStr;
//    CGSize size = [TTTAttributedLabel sizeThatFitsAttributedString:attrStr withConstraints:CGSizeMake(self.view.width - 48.0f, MAXFLOAT) limitedToNumberOfLines:0];
//    self.showLabel.size = size;
//    [self.view setNeedsLayout];
//}

@end
