//
//  TradeStockHeadView.m
//  stockscontest
//
//  Created by rxhui on 15/9/17.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeStockHeadView.h"
#import "TradeListHeadView.h"

@interface TradeStockHeadView ()

@property (nonatomic, strong) UILabel *totalMoneyTitleLabel;

@property (nonatomic, strong) UILabel *totalMoneyValueLabel;

@property (nonatomic, strong) UILabel *totalBenifitTitleLabel;

@property (nonatomic, strong) UILabel *totalBenifitValueLabel;

@property (nonatomic, strong) UILabel *marketPriceTitleLabel;

@property (nonatomic, strong) UILabel *marketPriceValueLabel;

@property (nonatomic, strong) UILabel *useMoneyTitleLabel;

@property (nonatomic, strong) UILabel *useMoneyValueLabel;

//@property (nonatomic, strong) UILabel *cashMoneyTitleLabel;
//
//@property (nonatomic, strong) UILabel *cashMoneyValueLabel;

@property (nonatomic, strong) UIButton *IPOButton;//新股申购

@property (nonatomic, strong) UIButton *transferButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *seperatorView;

@property (nonatomic, strong) TradeListHeadView *listHeadView;

@end

@implementation TradeStockHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)dealloc {
    self.totalBenifit = nil;
    self.totalMoneyTitleLabel = nil;
    self.totalMoneyValueLabel = nil;
    self.totalBenifitTitleLabel = nil;
    self.totalBenifitValueLabel = nil;
    self.marketPriceTitleLabel = nil;
    self.marketPriceValueLabel = nil;
    self.useMoneyTitleLabel = nil;
    self.useMoneyValueLabel = nil;
//    self.cashMoneyTitleLabel = nil;
//    self.cashMoneyValueLabel = nil;
    self.IPOButton = nil;
    self.transferButton = nil;
    self.lineView = nil;
}

- (void)setReceivedData:(NSDictionary *)aData {
    if (_receivedData) {
        _receivedData = nil;
    }
    _receivedData = aData.copy;
    [self clearData];
    [self applyData];
}

- (void)clearData {
    self.totalMoneyValueLabel.text = nil;
    self.marketPriceValueLabel.text = nil;
    self.useMoneyValueLabel.text = nil;
//    self.cashMoneyValueLabel.text = nil;
}

- (void)applyData {
    NSDecimalNumber *enableBalance = (NSDecimalNumber *)[self.receivedData objectForKey:@"enableBalance"];//可用余额
    NSDecimalNumber *marketValue = (NSDecimalNumber *)[self.receivedData objectForKey:@"marketValue"];//市值
    NSDecimalNumber *assetValue = (NSDecimalNumber *)[self.receivedData objectForKey:@"assetBalance"];//总资产
    self.totalMoneyValueLabel.text = [self getDecimalStringFor:assetValue];
    self.marketPriceValueLabel.text = [self getDecimalStringFor:marketValue];
    self.useMoneyValueLabel.text = [self getDecimalStringFor:enableBalance];

//    if (self.viewType == TradeControllerTypeSimulate) {
//        //总收益->总收益率 可取->总盈亏
//        NSDecimalNumber *totalProfit = (NSDecimalNumber *)[self.receivedData objectForKey:@"totalProfit"];//收益率
//        NSDecimalNumber *profitAndLoss = (NSDecimalNumber *)[self.receivedData objectForKey:@"profitAndLoss"];//盈亏
//        self.totalBenifitTitleLabel.text = @"总收益率";
////        NSString *profitRate = [self getDecimalStringFor:totalProfit];
//        self.totalBenifitValueLabel.text = [NSString stringWithFormat:@"%.2f%%",totalProfit.doubleValue * 100.0f];
//        UIColor *benifitColor = nil;
//        if (profitAndLoss.doubleValue - 0.0 > 0.001) {
//            benifitColor = color6_text_xgw;
//        }
//        else if (profitAndLoss.doubleValue - 0.0 <= -0.001) {
//            benifitColor = color7_text_xgw;
//        }
//        else {
//            benifitColor = color2_text_xgw;
//        }
//        self.totalBenifitValueLabel.textColor = benifitColor;
////        self.cashMoneyValueLabel.textColor = benifitColor;
////        self.cashMoneyTitleLabel.text = @"总盈亏";
////        self.cashMoneyValueLabel.text = [self getDecimalStringFor:profitAndLoss];
//    }
//    else {
//        NSDecimalNumber *fetchBalance = (NSDecimalNumber *)[self.receivedData objectForKey:@"fetchBalance"];//可取市值
////        self.cashMoneyValueLabel.text = [self getDecimalStringFor:fetchBalance];
//    }
    [self setNeedsLayout];
}

-(NSString *)getDecimalStringFor:(NSDecimalNumber *)num
{
    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    [format setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    format.positiveFormat = @"###,##0.00";
    format.negativeFormat = @"###,##0.00";
    NSString *result = [format stringFromNumber:num];
    //    NSRange range = [result rangeOfString:@"."];
    //    if(range.location == NSNotFound)
    //        result = [result stringByAppendingString:@".00"];
    return result;
}

- (void)setTotalBenifit:(NSDecimalNumber *)aBenifit {
    if (_totalBenifit) {
        _totalBenifit = nil;
    }
    _totalBenifit = aBenifit;
    self.totalBenifitValueLabel.text = [self getDecimalStringFor:_totalBenifit];

    UIColor *benifitColor = nil;
    if (_totalBenifit.doubleValue - 0.0 > 0.001) {
        benifitColor = color6_text_xgw;
    }
    else if (_totalBenifit.doubleValue - 0.0 <= -0.001) {
        benifitColor = color7_text_xgw;
    }
    else {
        benifitColor = color2_text_xgw;
    }
    self.totalBenifitValueLabel.textColor = benifitColor;
    [self setNeedsLayout];
}

- (void)setViewType:(TradeControllerType)aType {
    _viewType = aType;
    if (_viewType == TradeControllerTypeSimulate) {
        [self changeViewForSimulate];
    }
    else {
        self.listHeadView.titleList = @[@"市值",@"盈亏",@"持仓/可用",@"成本/现价"];
    }
}

- (void)initSubviews {
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    
    self.totalMoneyTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.totalMoneyTitleLabel];
    self.totalMoneyTitleLabel.font = font2_common_xgw;
    self.totalMoneyTitleLabel.textColor = color4_text_xgw;
    self.totalMoneyTitleLabel.text = @"总资产";
    
    self.totalBenifitTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.totalBenifitTitleLabel];
    self.totalBenifitTitleLabel.font = font2_common_xgw;
    self.totalBenifitTitleLabel.textColor = color4_text_xgw;
    self.totalBenifitTitleLabel.text = @"持仓盈亏";
    
    self.marketPriceTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.marketPriceTitleLabel];
    self.marketPriceTitleLabel.font = font2_common_xgw;
    self.marketPriceTitleLabel.textColor = color4_text_xgw;
    self.marketPriceTitleLabel.text = @"股票市值";
    
    self.useMoneyTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.useMoneyTitleLabel];
    self.useMoneyTitleLabel.font = font2_common_xgw;
    self.useMoneyTitleLabel.textColor = color4_text_xgw;
    self.useMoneyTitleLabel.text = @"可用余额";
    
//    self.cashMoneyTitleLabel = [[UILabel alloc]init];
//    [self addSubview:self.cashMoneyTitleLabel];
//    self.cashMoneyTitleLabel.font = font2_common_xgw;
//    self.cashMoneyTitleLabel.textColor = color4_text_xgw;
//    self.cashMoneyTitleLabel.text = @"可取余额";
    
    self.IPOButton = [UIButton didBuildB7_1ButtonWithTitle:@"新股申购"];
//    self.IPOButton = [UIButton didBuildButtonWithTitle:@"新股申购" normalTitleColor:[UIColor whiteColor] highlightTitleColor:[UIColor whiteColor] disabledTitleColor:[UIColor whiteColor] normalBGColor:color_font_orange highlightBGColor:color_font_orange disabledBGColor:color_font_orange];
    [self.IPOButton addTarget:self action:@selector(navToIPOPage) forControlEvents:UIControlEventTouchUpInside];
//    self.IPOButton.titleLabel.font = font3_common_xgw;
//    self.IPOButton.layer.cornerRadius = 4.0f;
//    self.IPOButton.layer.masksToBounds = YES;
    [self addSubview:self.IPOButton];
    
    self.totalMoneyValueLabel = [[UILabel alloc]init];
    [self addSubview:self.totalMoneyValueLabel];
    self.totalMoneyValueLabel.textColor = color2_text_xgw;
    self.totalMoneyValueLabel.font = font3_number_xgw;
    
    self.totalBenifitValueLabel = [[UILabel alloc]init];
    [self addSubview:self.totalBenifitValueLabel];
    self.totalBenifitValueLabel.textColor = color2_text_xgw;
    self.totalBenifitValueLabel.font = font3_number_xgw;
    self.totalBenifitValueLabel.text = @"0.00";
    
    self.marketPriceValueLabel = [[UILabel alloc]init];
    [self addSubview:self.marketPriceValueLabel];
    self.marketPriceValueLabel.textColor = color2_text_xgw;
    self.marketPriceValueLabel.font = font3_number_xgw;
    
    self.useMoneyValueLabel = [[UILabel alloc]init];
    [self addSubview:self.useMoneyValueLabel];
    self.useMoneyValueLabel.textColor = color2_text_xgw;
    self.useMoneyValueLabel.font = font3_number_xgw;
    
//    self.cashMoneyValueLabel = [[UILabel alloc]init];
//    [self addSubview:self.cashMoneyValueLabel];
//    self.cashMoneyValueLabel.textColor = color2_text_xgw;
//    self.cashMoneyValueLabel.font = font3_common_xgw;
    
//    self.transferButton = [[UIButton alloc]init];
    self.transferButton = [UIButton didBuildB7_2ButtonWithTitle:@"银证转账"];
    [self addSubview:self.transferButton];
//    self.transferButton.backgroundColor = color_font_orange;
//    [self.transferButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal | UIControlStateHighlighted | UIControlStateSelected];
//    [self.transferButton setTitle:@"银证转账" forState:UIControlStateNormal];
//    [self.transferButton setTitle:@"银证转账" forState:UIControlStateHighlighted];
//    [self.transferButton setTitle:@"银证转账" forState:UIControlStateSelected];
//    self.transferButton.titleLabel.font = font3_common_xgw;
//    self.transferButton.layer.cornerRadius = 4.0f;
//    self.transferButton.layer.masksToBounds = YES;
    [self.transferButton addTarget:self action:@selector(transferButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    
    self.seperatorView = [[UIView alloc]init];
    [self addSubview:self.seperatorView];
    self.seperatorView.backgroundColor = color18_other_xgw;
    
    self.listHeadView = [[TradeListHeadView alloc]init];
    [self addSubview:self.listHeadView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat averWidth = self.width * 0.33f;
    
    if (self.lineView.subviews.count == 0) {
        for (int i = 0; i < 6; i++) {
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = color16_other_xgw;
            [self.lineView addSubview:line];
            switch (i) {
                case 0:
                    line.frame = CGRectMake( averWidth, 10.0f, 0.5f, 45.0f);
                    break;
                case 1:
                    line.frame = CGRectMake( averWidth * 2.0f, 10.0f, 0.5f, 45.0f);
                    break;
                case 2:
                    line.frame = CGRectMake( averWidth, 75.0f, 0.5f, 45.0f);
                    break;
                case 3:
                    line.frame = CGRectMake( averWidth * 2.0f, 75.0f, 0.5f, 45.0f);
                    break;
                case 4:
                    line.frame = CGRectMake( 0.0f, 64.5f, averWidth * 3.0f, 0.5f);
                    break;
                case 5:
                    line.frame = CGRectMake( 0.0f, 129.5f, averWidth * 3.0f, 0.5f);
                    break;
                default:
                    break;
            }
        }
    }
    
    [self.totalMoneyTitleLabel sizeToFit];
    [self.totalMoneyValueLabel sizeToFit];
    if (self.totalMoneyValueLabel.width > averWidth - 8.0f) {
        self.totalMoneyValueLabel.width = averWidth - 8.0f;
        self.totalMoneyValueLabel.adjustsFontSizeToFitWidth = YES;
    }
    self.totalMoneyValueLabel.x = (averWidth - self.totalMoneyValueLabel.width) * 0.5f;
    self.totalMoneyValueLabel.y = 10.0f;
    self.totalMoneyTitleLabel.x = (averWidth - self.totalMoneyTitleLabel.width) * 0.5f;
    self.totalMoneyTitleLabel.y = self.totalMoneyValueLabel.y + self.totalMoneyValueLabel.height + 5.0f;
    
    [self.totalBenifitValueLabel sizeToFit];
    [self.totalBenifitTitleLabel sizeToFit];
    self.totalBenifitValueLabel.x = averWidth + (averWidth - self.totalBenifitValueLabel.width) * 0.5f;
    self.totalBenifitValueLabel.y = 10.0f;
    self.totalBenifitTitleLabel.x = averWidth + (averWidth - self.totalBenifitTitleLabel.width) * 0.5f;
    self.totalBenifitTitleLabel.y = self.totalBenifitValueLabel.y + self.totalBenifitValueLabel.height + 5.0f;
    
    [self.marketPriceTitleLabel sizeToFit];
    [self.marketPriceValueLabel sizeToFit];
    if (self.marketPriceValueLabel.width > averWidth - 8.0f) {
        self.marketPriceValueLabel.width = averWidth - 8.0f;
        self.marketPriceValueLabel.adjustsFontSizeToFitWidth = YES;
    }
    self.marketPriceValueLabel.x = averWidth * 1.0f + (averWidth - self.marketPriceValueLabel.width) * 0.5f;
    self.marketPriceValueLabel.y = 75.0f;
    self.marketPriceTitleLabel.x = averWidth * 1.0f + (averWidth - self.marketPriceTitleLabel.width) * 0.5f;
    self.marketPriceTitleLabel.y = self.marketPriceValueLabel.y + self.marketPriceValueLabel.height + 5.0f;
    
    [self.useMoneyTitleLabel sizeToFit];
    [self.useMoneyValueLabel sizeToFit];
    if (self.useMoneyValueLabel.width > averWidth - 8.0f) {
        self.useMoneyValueLabel.width = averWidth - 8.0f;
        self.useMoneyValueLabel.adjustsFontSizeToFitWidth = YES;
    }
    self.useMoneyValueLabel.x = (averWidth - self.useMoneyValueLabel.width) * 0.5f;
    self.useMoneyValueLabel.y = 75.0f;
    self.useMoneyTitleLabel.x = (averWidth - self.useMoneyTitleLabel.width) * 0.5f;
    self.useMoneyTitleLabel.y = self.useMoneyValueLabel.y + self.useMoneyValueLabel.height + 5.0f;
    
//    [self.cashMoneyTitleLabel sizeToFit];
//    [self.cashMoneyValueLabel sizeToFit];
//    if (self.cashMoneyValueLabel.width > averWidth - 8.0f) {
//        self.cashMoneyValueLabel.width = averWidth - 8.0f;
//        self.cashMoneyValueLabel.adjustsFontSizeToFitWidth = YES;
//    }
//    self.cashMoneyValueLabel.x = averWidth + (averWidth - self.cashMoneyValueLabel.width) * 0.5f;
//    self.cashMoneyValueLabel.y = 75.0f;
//    self.cashMoneyTitleLabel.x = averWidth + (averWidth - self.cashMoneyTitleLabel.width) * 0.5f;
//    self.cashMoneyTitleLabel.y = self.cashMoneyValueLabel.y + self.cashMoneyValueLabel.height + 5.0f;
    
    self.IPOButton.size = CGSizeMake(averWidth - 20.0f, 35.0f);
    self.IPOButton.origin = CGPointMake(averWidth * 2.0f + 10.0f, 15.0f);
    
    self.transferButton.size = CGSizeMake(averWidth - 20.0f, 35.0f);
    self.transferButton.origin = CGPointMake(averWidth * 2.0f + 10.0f, 80.0f);
    
    self.lineView.size = CGSizeMake(self.width, 130.0f);
    
    self.seperatorView.size = CGSizeMake(self.width, 10.0f);
    self.seperatorView.y = 130.0f;
    
    self.listHeadView.y = 140.0f;
    self.listHeadView.size = CGSizeMake(self.width, 27.0f);
}

#pragma mark ----------
- (void)navToIPOPage{
    //层级太多使用通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kTradeToIPONotificationName object:nil];
}

- (void)transferButtonTouchHandler {
    if (!self.delegate) {
        NSLog(@"-TradeStockHeadView-未设置代理");
    }
    if (![self.delegate respondsToSelector:@selector(navigationToTransferController)]) {
        NSLog(@"-TradeStockHeadView-未实现方法");
    }
    [self.delegate navigationToTransferController];
}

- (void)changeViewForSimulate {
//    self.cashMoneyTitleLabel.hidden = YES;
//    self.cashMoneyValueLabel.hidden = YES;
    self.transferButton.hidden = YES;
    self.listHeadView.titleList = @[@"市值",@"盈亏率",@"持仓",@"成本/现价"];
}

@end
