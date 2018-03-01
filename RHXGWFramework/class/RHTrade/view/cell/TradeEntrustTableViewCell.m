//
//  TradeEntrustTableViewCell.m
//  stockscontest
//
//  Created by Tiger on 15/6/13.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeEntrustTableViewCell.h"
//#import "CMAlert.h"

@interface TradeEntrustTableViewCell ()

@property (nonatomic, strong) UIView *wrapperView;

@property (nonatomic, strong) UIImageView *buySellImage;

@property (nonatomic, strong) UILabel *stockNameLabel;

@property (nonatomic, strong) UILabel *tradeTimeLabel;

@property (nonatomic, strong) UILabel *stockPriceLabel;//委托价

@property (nonatomic, strong) UILabel *tradePriceLabel;//成交价

@property (nonatomic, strong) UILabel *stockNumLabel;//委托数量

@property (nonatomic, strong) UILabel *tradeNumLabel;//成交数量

@property (nonatomic, strong) UILabel *tradeStatusLabel;//交易状态

@property (nonatomic, strong) UIView *line;

@end

@implementation TradeEntrustTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)setItemVO:(EntrustListVO *)aVO {
    if (_itemVO) {
        _itemVO = nil;
    }
    _itemVO = aVO;
    [self clearData];
    [self applyData];
    [self setNeedsLayout];
}

- (void)clearData {
    self.buySellImage.image = nil;
    self.stockNameLabel.text = nil;
    self.tradeTimeLabel.text = nil;
    self.stockPriceLabel.text = nil;
    self.tradePriceLabel.text = nil;
    self.stockNumLabel.text = nil;
    self.tradeNumLabel.text = nil;
    self.tradeStatusLabel.text = nil;
}

- (void)applyData {
    UIColor *labelColor = nil;
    if ([self.itemVO.entrustBs isEqualToString:@"1"]) {
        labelColor = color6_text_xgw;
        self.buySellImage.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jy_buy"];
    }
    else {
        labelColor = color8_text_xgw;
        self.buySellImage.image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jy_sell"];
    }
    self.stockNameLabel.textColor = labelColor;
    self.tradeTimeLabel.textColor = labelColor;
    self.stockPriceLabel.textColor = labelColor;
    self.tradePriceLabel.textColor = labelColor;
    self.stockNumLabel.textColor = labelColor;
    self.tradeNumLabel.textColor = labelColor;
    
    self.stockNameLabel.text = self.itemVO.stockName;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.itemVO.entrustDateTime.longLongValue / 1000];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"HH:mm:ss"];
    format.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    self.tradeTimeLabel.text = [format stringFromDate:date];
    
    if(self.itemVO.entrustPrice.doubleValue < 0.000001 && self.itemVO.entrustPrice.doubleValue >= 0.0) {
        self.stockPriceLabel.text = @"市价";
    }
    else {
        self.stockPriceLabel.text = [NSString stringWithFormat:@"%.2f",self.itemVO.entrustPrice.doubleValue];
    }
    self.tradePriceLabel.text = [NSString stringWithFormat:@"%.2f",self.itemVO.businessPrice.doubleValue];
    
    self.stockNumLabel.text = self.itemVO.entrustAmount.stringValue;
    self.tradeNumLabel.text = self.itemVO.businessAmount.stringValue;
    self.tradeStatusLabel.text = self.itemVO.entrustStatus;
}

- (void)setViewType:(TradeControllerType)aType {
    _viewType = aType;
    if (_viewType == TradeControllerTypeSimulate) {
        [self changeViewForSimulate];
    }
}

- (void)changeViewForSimulate {
    self.tradePriceLabel.hidden = YES;
    self.tradeNumLabel.hidden = YES;
    self.tradeStatusLabel.hidden = YES;
    [self setNeedsLayout];
}

- (void)initSubviews {
    self.wrapperView = [[UIView alloc]init];
    [self.contentView addSubview:self.wrapperView];
    self.wrapperView.backgroundColor = [UIColor whiteColor];
    
    self.buySellImage = [[UIImageView alloc]init];
    [self.wrapperView addSubview:self.buySellImage];
    
//    self.stockNameLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.stockNameLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
   [self.wrapperView addSubview:self.stockNameLabel];
//    self.tradeTimeLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.tradeTimeLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.tradeTimeLabel];
//    self.tradeTimeLabel.font = font2_number_xgw;
    
//    self.stockPriceLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.stockPriceLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.stockPriceLabel];
//    self.stockPriceLabel.font = font2_number_xgw;
//    self.tradePriceLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.tradePriceLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.tradePriceLabel];
//    self.tradePriceLabel.font = font2_number_xgw;
    
//    self.stockNumLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.stockNumLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.stockNumLabel];
//    self.stockNumLabel.font = font2_number_xgw;
//    self.tradeNumLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.tradeNumLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.tradeNumLabel];
    self.tradeNumLabel.font = font2_number_xgw;
    
//    self.tradeStatusLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.tradeStatusLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.tradeStatusLabel];
    
    self.line = [[UIView alloc]init];
    [self.wrapperView addSubview:self.line];
    self.line.backgroundColor = color16_other_xgw;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.wrapperView.size = self.size;
    
    self.buySellImage.size = self.buySellImage.image.size;
    [self.stockNameLabel sizeToFit];
    [self.tradeTimeLabel sizeToFit];
    [self.stockPriceLabel sizeToFit];
    [self.tradePriceLabel sizeToFit];
    [self.stockNumLabel sizeToFit];
    [self.tradeNumLabel sizeToFit];
    [self.tradeStatusLabel sizeToFit];
    
    CGFloat averWidth = self.width * 0.25f;
    CGFloat narrow = self.width * 0.2f;
    CGFloat wide = self.width * 0.3f;
    
    self.buySellImage.x = 5.0f;
    self.buySellImage.y = (self.height - self.buySellImage.height) * 0.5f;
    
    self.stockNameLabel.x = self.buySellImage.x + self.buySellImage.width + 10.0f;
    self.stockNameLabel.y = 10.0f;
    self.tradeTimeLabel.x = self.stockNameLabel.x;
    self.tradeTimeLabel.y = self.stockNameLabel.y + self.stockNameLabel.height;
    
    if (self.viewType == TradeControllerTypeSimulate) {
        CGFloat width = self.width * 0.3333f;
        self.stockPriceLabel.y = (self.height - self.stockPriceLabel.height) * 0.5f;
        self.stockPriceLabel.x = width + (width - self.stockPriceLabel.width) * 0.5f;
        self.stockNumLabel.y = self.stockPriceLabel.y;
        self.stockNumLabel.x = width * 2 + (width - self.stockNumLabel.width) * 0.5f;
    }
    else {
        self.stockPriceLabel.y = self.stockNameLabel.y;
        self.tradePriceLabel.x = wide + (averWidth - self.tradePriceLabel.width) * 0.5f;
        self.tradePriceLabel.y = self.stockPriceLabel.y + self.stockPriceLabel.height;
        self.stockPriceLabel.x = self.tradePriceLabel.x;
        
        self.stockNumLabel.x = wide + averWidth + (averWidth - self.stockNumLabel.width) * 0.5f;
        self.stockNumLabel.y = self.stockNameLabel.y;
        self.tradeNumLabel.x = self.stockNumLabel.x;
        self.tradeNumLabel.y = self.stockNumLabel.y + self.stockNumLabel.height;
        
        self.tradeStatusLabel.x = (narrow - self.tradeStatusLabel.width) * 0.5f + wide + averWidth * 2.0f;
        self.tradeStatusLabel.y = (self.height - self.tradeStatusLabel.height) * 0.5f;
    }
    
    self.line.size = CGSizeMake(self.width, 0.5f);
    self.line.y = self.height - 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
