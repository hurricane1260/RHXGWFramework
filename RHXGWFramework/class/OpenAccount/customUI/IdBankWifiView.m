//
//  IdBankWifiView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/19.
//
//

#import "IdBankWifiView.h"

#import "SingleBankView.h"

@interface IdBankWifiView ()

kRhPStrong UIButton * idCardBtn;

kRhPStrong UIButton * bankCardBtn;

kRhPStrong UIButton * wifiBtn;

kRhPStrong NSArray * imgArr;

kRhPStrong NSArray * titleArr;

kRhPStrong NSMutableArray * viewArr;
@end

@implementation IdBankWifiView

- (instancetype)init{
    if (self = [super init]) {
        self.imgArr = @[img_open_id,img_open_card,img_open_wifi];
        self.titleArr = @[@"二代身份证",@"本人借记银行卡",@"WI-FI或4G"];
        self.viewArr = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithImgArr:(NSArray *)imgArr withTitleArr:(NSArray *)titleArr{
    if (self = [super init]) {
        self.imgArr = imgArr;
        self.titleArr = titleArr;
        self.viewArr = [NSMutableArray array];
        [self initSubviews];
    }
    return self;
}

//- (void)setImgArr:(NSArray *)imgArr{
//    _imgArr = imgArr;
//    if (_imgArr.count && _viewArr.count) {
//        [self initSubviews];
//    }
//}
//
//- (void)setViewArr:(NSMutableArray *)viewArr{
//    _viewArr = viewArr;
//    if (_imgArr.count && _viewArr.count) {
//        [self initSubviews];
//    }
//}

- (void)initSubviews{
//    self.idCardBtn  = [UIButton didBuildButtonWithNormalImage:img_open_id highlightImage:img_open_id withTitle:@"二代身份证" normalTitleColor:color4_text_xgw highlightTitleColor:color4_text_xgw];
//    self.idCardBtn.titleLabel.font = font1_common_xgw;
//    [UIButton didBuildEdgeInsetsForTopImageBottomTitle:self.idCardBtn];
//    [self addSubview:self.idCardBtn];
//    
//    self.bankCardBtn  = [UIButton didBuildButtonWithNormalImage:img_open_bank highlightImage:img_open_bank withTitle:@"本人借记银行卡" normalTitleColor:color4_text_xgw highlightTitleColor:color4_text_xgw];
//    self.bankCardBtn.titleLabel.font = font1_common_xgw;
//    [UIButton didBuildEdgeInsetsForTopImageBottomTitle:self.bankCardBtn];
//    [self addSubview:self.bankCardBtn];
//
//    self.wifiBtn  = [UIButton didBuildButtonWithNormalImage:img_open_wifi highlightImage:img_open_wifi withTitle:@"WI-FI或4G" normalTitleColor:color4_text_xgw highlightTitleColor:color4_text_xgw];
//    self.wifiBtn.titleLabel.font = font1_common_xgw;
//    [UIButton didBuildEdgeInsetsForTopImageBottomTitle:self.wifiBtn];
//    [self addSubview:self.wifiBtn];

//    __weak typeof (self) welf = self;
    for (int i = 0; i < self.imgArr.count; i++) {
        SingleBankView * view = [[SingleBankView alloc] initVerticalWithImg:self.imgArr[i] withTitle:self.titleArr[i]];
        view.nameLabel.font = font1_common_xgw;
        view.nameLabel.textColor = color4_text_xgw;
//        __weak typeof (view) wiew = view;

//        view.heightCallBack = ^(NSDictionary * param){
//            if ([param objectForKey:@"height"]) {
//                wiew.heightCallBack = [param objectForKey:@"height"];
//                [welf setNeedsLayout];
//            }
//        
//        };
        [self addSubview:view];
        [self.viewArr addObject:view];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.idCardBtn.frame = CGRectMake(0, 0, self.width /3.0f, self.height);
//    self.bankCardBtn.frame = CGRectMake(CGRectGetMaxX(self.idCardBtn.frame), 0, self.width /3.0f, self.height);
//    self.wifiBtn.frame = CGRectMake(CGRectGetMaxX(self.bankCardBtn.frame), 0, self.width /3.0f, self.height);

    for (int i = 0; i < self.viewArr.count; i++) {
        SingleBankView * view = self.viewArr[i];
        view.frame = CGRectMake(i % 3 * (self.width / 3.0f), 0, self.width / 3.0f, 52.0f);
    }
    
}


@end
