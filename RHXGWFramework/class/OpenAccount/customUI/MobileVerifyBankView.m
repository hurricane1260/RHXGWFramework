//
//  MobileVerifyBankView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/20.
//
//

#import "MobileVerifyBankView.h"
#import "SingleBankView.h"

#define IMGARRAY  @[@"icon_bank_ny",@"icon_bank_gd",@"icon_bank_nb",@"icon_bank_gs",@"icon_bank_js",@"icon_bank_pa",@"icon_bank_pf",@"icon_bank_zg",@"icon_bank_zx",@"icon_bank_sh",@"icon_bank_ms",@"icon_bank_xy",@"icon_bank_zs",@"icon_bank_gf",@"icon_bank_yz",@"icon_bank_jt"];
#define BANKARRAY  @[@"农业银行",@"光大银行",@"宁波银行",@"工商银行",@"建设银行",@"平安银行",@"浦发银行",@"中国银行",@"中信银行",@"上海银行",@"民生银行",@"兴业银行",@"招商银行",@"广发银行",@"邮政储蓄",@"交通银行"];

@interface MobileVerifyBankView ()

kRhPStrong NSArray * imgArray;

kRhPStrong NSArray * bankArr;

//kRhPStrong SingleBankView * bankView;

kRhPStrong NSMutableArray * bankViewArr;

@end

@implementation MobileVerifyBankView


- (instancetype)init{
    if (self = [super init]) {
        self.imgArray = IMGARRAY;
        self.bankArr = BANKARRAY;
        
        self.bankViewArr = [NSMutableArray array];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    for (int i = 0; i < self.imgArray.count; i++) {
        SingleBankView * bankView = [[SingleBankView alloc] initHorizontalWithImg:[UIImage imageNamed:self.imgArray[i]] withTitle:self.bankArr[i]];
        [self addSubview:bankView];
        [self.bankViewArr addObject:bankView];
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];

    for (int i = 0; i < self.bankViewArr.count; i++) {
        SingleBankView * bankView = self.bankViewArr[i];
        
        bankView.frame = CGRectMake(i % 3 * (self.width /3.0f), i / 3 * (20.0f + 10.0f), self.width / 3.0f, 20.0f);
    }
    
}

@end
