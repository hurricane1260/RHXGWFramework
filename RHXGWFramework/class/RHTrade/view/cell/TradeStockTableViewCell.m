//
//  TradeStockTableViewCell.m
//  stockscontest
//
//  Created by Tiger on 15/6/12.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeStockTableViewCell.h"
#import "UIImageUtils.h"

@interface TradeStockTableViewCell ()

@property (nonatomic, strong) UIView *wrapperView;

/*! @brief 股票名 */
@property (nonatomic, strong) UILabel *stockNameLabel;
/*! @brief 市值 */
@property (nonatomic, strong) UILabel *valueLabel;

/*! @brief 盈亏 */
@property (nonatomic, strong) UILabel *profitLossLabel;
/*! @brief 盈亏率 */
@property (nonatomic, strong) UILabel *profitLossRateLabel;

/*! @brief 持仓 */
@property (nonatomic, strong) UILabel *stockNumLabel;
/*! @brief 持仓可用 */
@property (nonatomic, strong) UILabel *stockCanUseLabel;

/*! @brief 现价 */
@property (nonatomic, strong) UILabel *lastPriceLabel;
/*! @brief 市价 */
@property (nonatomic, strong) UILabel *costPriceLabel;

/*! @brief 买入 */
@property (nonatomic, strong) UIButton *buyButton;
/*! @brief 卖出 */
@property (nonatomic, strong) UIButton *sellButton;
/*! @brief 看行情 */
@property (nonatomic, strong) UIButton *kLineButton;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *line2;

@property (nonatomic, strong) UIView *line3;

@property (nonatomic, strong) UIView *selectedBackView;

@end

@implementation TradeStockTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)setCellType:(TradeControllerType)aType {
    _cellType = aType;
    if (_cellType == TradeControllerTypeSimulate) {
        self.profitLossLabel.hidden = YES;;
        self.stockCanUseLabel.hidden = YES;
    }
}

- (void)setStockVO:(StockListVO *)aVO {
    if (_stockVO) {
        _stockVO = nil;
    }
    _stockVO = aVO;
    [self clearData];
    [self applyData];
    [self setNeedsLayout];
}

- (void)clearData {
    self.stockNameLabel.text = nil;
    self.valueLabel.text = nil;
    self.profitLossLabel.text = nil;
    self.profitLossRateLabel.text = nil;
    self.stockNumLabel.text = nil;
    self.stockCanUseLabel.text = nil;
    self.lastPriceLabel.text = nil;
    self.costPriceLabel.text = nil;
}

- (void)applyData {
    UIColor *labelColor = nil;
    if (self.stockVO.incomeBalance.doubleValue >= 0.0000f) {
        labelColor = color6_text_xgw;
    }
    else if (self.stockVO.incomeBalance.doubleValue < -0.0000f) {
        labelColor = color8_text_xgw;
    }
    self.stockNameLabel.textColor = labelColor;
    self.valueLabel.textColor = labelColor;
    self.profitLossLabel.textColor = labelColor;
    self.profitLossRateLabel.textColor = labelColor;
    self.stockNumLabel.textColor = labelColor;
    self.stockCanUseLabel.textColor = labelColor;
    self.lastPriceLabel.textColor = labelColor;
    self.costPriceLabel.textColor = labelColor;
    
    self.stockNameLabel.text = self.stockVO.stockName;
    if(self.stockVO.marketValue.doubleValue < 10000.00) {
        self.valueLabel.text = [NSString stringWithFormat:@"%.2f", self.stockVO.marketValue.doubleValue];
    }
    else if(self.stockVO.marketValue.doubleValue < 100000000.00 && self.stockVO.marketValue.doubleValue >= 10000.00) {
        self.valueLabel.text = [NSString stringWithFormat:@"%.2f万", self.stockVO.marketValue.doubleValue /10000.0];
    }
    else {
        self.valueLabel.text = [NSString stringWithFormat:@"%.2f亿", (long)self.stockVO.marketValue.doubleValue /100000000.0];
    }
    
    if (self.cellType == TradeControllerTypeSimulate) {
         self.profitLossRateLabel.text  = [NSString stringWithFormat:@"%.2f%%",self.stockVO.incomeBalance.doubleValue];
    }
    else {
        self.profitLossLabel.text = [NSString stringWithFormat:@"%.2lf",self.stockVO.incomeBalance.doubleValue];
        float profitR = self.stockVO.incomeBalance.doubleValue / (self.stockVO.costPrice.doubleValue * self.stockVO.currentAmount.integerValue) * 100.0;
        if (self.stockVO.currentAmount.integerValue == 0) {
            profitR = 0.00;
        }
        if (self.stockVO.costPrice.integerValue == 0) {
            self.profitLossRateLabel.text  = @"--";
        }
        else {
            self.profitLossRateLabel.text  = [NSString stringWithFormat:@"%.2f%%",profitR];
        }
        self.stockCanUseLabel.text = [NSString stringWithFormat:@"%@",self.stockVO.enableAmount];
    }
    
    self.stockNumLabel.text = [NSString stringWithFormat:@"%@", self.stockVO.currentAmount];
    
    self.lastPriceLabel.text = [NSString stringWithFormat:@"%.3f",self.stockVO.lastPrice.doubleValue];
    self.costPriceLabel.text = [NSString stringWithFormat:@"%.3f",self.stockVO.costPrice.doubleValue];
}

- (void)initSubviews {
    self.wrapperView = [[UIView alloc]init];
    [self.contentView addSubview:self.wrapperView];
    self.wrapperView.backgroundColor = [UIColor whiteColor];
    
//    self.stockNameLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.stockNameLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.stockNameLabel];
//    self.valueLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.valueLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.valueLabel];
//    self.valueLabel.font = font2_number_xgw;
    
//    self.profitLossLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.profitLossLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.profitLossLabel];
//    self.profitLossLabel.font = font2_number_xgw;
//    self.profitLossRateLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.profitLossRateLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.profitLossRateLabel];
//    self.profitLossRateLabel.font = font2_number_xgw;
    
//    self.stockNumLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.stockNumLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.stockNumLabel];
//    self.stockNumLabel.font = font2_number_xgw;
//    self.stockCanUseLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.stockCanUseLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.stockCanUseLabel];
//    self.stockCanUseLabel.font = font2_number_xgw;
    
//    self.costPriceLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.costPriceLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.costPriceLabel];
//    self.costPriceLabel.font = font2_number_xgw;
//    self.lastPriceLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.lastPriceLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
   [self.wrapperView addSubview:self.lastPriceLabel];
//    self.lastPriceLabel.font = font2_number_xgw;
    
    self.actionView = [[UIView alloc]init];
    [self.wrapperView addSubview:self.actionView];
    self.actionView.backgroundColor = [UIColor whiteColor];
    
    self.buyButton = [UIButton didBuildButtonWithNormalImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jiaoyi_buy_nor"] highlightImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jiaoyi_buy_nor"] withTitle:@" 买入" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw];
    self.buyButton.titleLabel.font = font2_common_xgw;
    [self.buyButton addTarget:self action:@selector(onBuy:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:self.buyButton];
    
    self.sellButton = [UIButton didBuildButtonWithNormalImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jiaoyi_sell_nor"] highlightImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jiaoyi_sell_nor"] withTitle:@" 卖出" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw];
    self.sellButton.titleLabel.font = font2_common_xgw;
    [self.sellButton addTarget:self action:@selector(onSell:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:self.sellButton];
    
    self.kLineButton = [UIButton didBuildButtonWithNormalImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jiaoyi_hangqing_nor"] highlightImage:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jiaoyi_hangqing_nor"] withTitle:@" 看行情" normalTitleColor:color2_text_xgw highlightTitleColor:color2_text_xgw];
    self.kLineButton.titleLabel.font = font2_common_xgw;
    [self.kLineButton addTarget:self action:@selector(onLearnMarket:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:self.kLineButton];
    
    self.line = [[UIView alloc]init];
    [self.wrapperView addSubview:self.line];
    self.line.backgroundColor = color16_other_xgw;
    
    self.line2 = [[UIView alloc]init];
    [self.actionView addSubview:self.line2];
    self.line2.backgroundColor = color16_other_xgw;
    
    self.line3 = [[UIView alloc]init];
    [self.actionView addSubview:self.line3];
    self.line3.backgroundColor = color16_other_xgw;
    
    self.selectedBackView  = [[UIView alloc]init];
    self.selectedBackgroundView = self.selectedBackView;
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.wrapperView.size = self.contentView.size;
    [self.stockNameLabel sizeToFit];
    [self.valueLabel sizeToFit];
    [self.profitLossLabel sizeToFit];
    [self.profitLossRateLabel sizeToFit];
    [self.stockNumLabel sizeToFit];
    [self.stockCanUseLabel sizeToFit];
    [self.costPriceLabel sizeToFit];
    [self.lastPriceLabel sizeToFit];
    
    CGFloat averWidth = self.width * 0.25f;
    CGFloat cellHeight = 60.0f;
    self.stockNameLabel.x = 20.0f;
    self.stockNameLabel.y = (cellHeight - self.stockNameLabel.height - self.valueLabel.height) * 0.5f;
    self.valueLabel.x = self.stockNameLabel.x;
    self.valueLabel.y = self.stockNameLabel.y + self.stockNameLabel.height;
    
    if (self.cellType == TradeControllerTypeSimulate) {
        self.profitLossRateLabel.x = averWidth + (averWidth - self.profitLossRateLabel.width) * 0.5f;
        self.profitLossRateLabel.y = (cellHeight - self.profitLossRateLabel.height) * 0.5f;
        
        self.stockNumLabel.x = averWidth * 2.0f + (averWidth - self.stockNumLabel.width) * 0.5f;
        self.stockNumLabel.y = (cellHeight - self.stockNumLabel.height) * 0.5f;
    }
    else {
        self.profitLossLabel.x = averWidth + (averWidth - self.profitLossLabel.width) * 0.5f;
        self.profitLossLabel.y = self.stockNameLabel.y;
        self.profitLossRateLabel.x = averWidth + (averWidth - self.profitLossRateLabel.width) * 0.5f;
        self.profitLossRateLabel.y = self.profitLossLabel.y + self.profitLossLabel.height;
        
        self.stockNumLabel.x = averWidth * 2.0f + (averWidth - self.stockNumLabel.width) * 0.5f;
        self.stockNumLabel.y = self.stockNameLabel.y;
        self.stockCanUseLabel.x = averWidth * 2.0f + (averWidth- self.stockCanUseLabel.width) * 0.5f;
        self.stockCanUseLabel.y = self.stockNumLabel.y + self.stockNumLabel.height;
    }
    self.costPriceLabel.x = averWidth * 3.0f + (averWidth - self.costPriceLabel.width) * 0.5f;
    self.costPriceLabel.y = self.stockNameLabel.y;
    self.lastPriceLabel.x = averWidth * 3.0f + (averWidth - self.lastPriceLabel.width) * 0.5f;
    self.lastPriceLabel.y = self.costPriceLabel.y + self.costPriceLabel.height;
    
    self.actionView.y = 60.0f;
    self.actionView.size = CGSizeMake(self.width, 35.0f);
    
    averWidth = self.width * 0.33f;
    self.buyButton.size = CGSizeMake(averWidth, 35.0f);
    self.sellButton.size = self.buyButton.size;
    self.sellButton.x = averWidth;
    self.kLineButton.size = self.buyButton.size;
    self.kLineButton.x = averWidth * 2.0f;
    
    [self.buyButton setBackgroundImage:[UIImageUtils buildImageWithUIColor:color17_other_xgw andFrame:self.buyButton.bounds] forState:UIControlStateNormal];
    [self.buyButton setBackgroundImage:[UIImageUtils buildImageWithUIColor:[UIColor whiteColor] andFrame:self.buyButton.bounds] forState:UIControlStateHighlighted];
    [self.sellButton setBackgroundImage:[UIImageUtils buildImageWithUIColor:color17_other_xgw andFrame:self.sellButton.bounds] forState:UIControlStateNormal];
    [self.sellButton setBackgroundImage:[UIImageUtils buildImageWithUIColor:[UIColor whiteColor] andFrame:self.sellButton.bounds] forState:UIControlStateHighlighted];
    [self.kLineButton setBackgroundImage:[UIImageUtils buildImageWithUIColor:color17_other_xgw andFrame:self.kLineButton.bounds] forState:UIControlStateNormal];
    [self.kLineButton setBackgroundImage:[UIImageUtils buildImageWithUIColor:[UIColor whiteColor] andFrame:self.kLineButton.bounds] forState:UIControlStateHighlighted];
    
    self.line.y = self.height - 0.5f;
    self.line.size = CGSizeMake(self.width, 0.5f);
    
    self.line2.origin = CGPointMake(averWidth - 0.5f, 8.5f);
    self.line2.size = CGSizeMake(0.5f, 18.0f);
    self.line3.origin = CGPointMake(averWidth * 2.0f - 0.5f, 8.5f);
    self.line3.size = CGSizeMake(0.5f, 18.0f);
    
    self.selectedBackView.size = self.size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)onBuy:(id)sender {
    if([self.delegate respondsToSelector:@selector(tradeControllerSwitchTo:withStockName:andStockCode:)]) {
        [self.delegate tradeControllerSwitchTo:tradeBuyViewIndex withStockName:self.stockVO.stockName andStockCode:self.stockVO.stockCode];
    }
}

- (void)onSell:(id)sender {
    if([self.delegate respondsToSelector:@selector(tradeControllerSwitchTo:withStockName:andStockCode:)]) {
        [self.delegate tradeControllerSwitchTo:tradeSellViewIndex withStockName:self.stockVO.stockName andStockCode:self.stockVO.stockCode];
    }
}

- (void)onLearnMarket:(id)sender {
    if([self.delegate respondsToSelector:@selector(tradeControllerSwitchTo:withStockName:andStockCode:)]) {
        [self.delegate tradeControllerSwitchTo:tradeKLineIndex withStockName:self.stockVO.stockName andStockCode:self.stockVO.stockCode];
    }
}

@end
