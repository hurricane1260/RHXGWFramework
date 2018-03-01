//
//  DealListViewCell.m
//  stockscontest
//
//  Created by Tiger on 15/6/18.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "DealListViewCell.h"
#import "DealListVO.h"
#import "DealHistoryListVO.h"
#import "TimeUtils.h"

@interface DealListViewCell ()

@property (nonatomic, strong) DealListVO *dealVO;

@property (nonatomic, strong) DealHistoryListVO *historyVO;

@property (nonatomic, strong) UIImageView *buySellImage;

@property (nonatomic, strong) UILabel *stockNameLabel;

@property (nonatomic, strong) UILabel *tradeTimeLabel;

@property (nonatomic, strong) UILabel *buySellAmountLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *tradeAmountLabel;

@property (nonatomic, strong) UIView *wrapperView;

@property (nonatomic, strong) UIView *line;

@end

@implementation DealListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)setItemVO:(id)aVO {
    if (_itemVO) {
        _itemVO = nil;
    }
    _itemVO = aVO;
    if ([_itemVO isKindOfClass:[DealListVO class]]) {
        self.dealVO = _itemVO;
    }
    else if ([_itemVO isKindOfClass:[DealHistoryListVO class]]) {
        self.historyVO = _itemVO;
    }
}

- (void)setDealVO:(DealListVO *)aVO {
    if (_dealVO) {
        _dealVO = nil;
    }
    _dealVO = aVO;
    [self clearData];
    [self applyDealData];
    [self setNeedsLayout];
}

- (void)setHistoryVO:(DealHistoryListVO *)aVO {
    if (_historyVO) {
        _historyVO = nil;
    }
    _historyVO = aVO;
    [self clearData];
    [self applyHistoryData];
    [self setNeedsLayout];
}

- (void)clearData {
    self.buySellImage.image = nil;
    self.stockNameLabel.text = nil;
    self.tradeTimeLabel.text = nil;
    self.buySellAmountLabel.text = nil;
    self.priceLabel.text = nil;
    self.tradeAmountLabel.text = nil;
}

- (void)applyDealData {
    UIColor *textColor = [self.dealVO.entrustBs isEqualToString:@"1"]?color6_text_xgw:color8_text_xgw;
    self.stockNameLabel.textColor = textColor;
    self.tradeTimeLabel.textColor = textColor;
    self.buySellAmountLabel.textColor = textColor;
    self.priceLabel.textColor = textColor;
    self.tradeAmountLabel.textColor = textColor;
    
    self.buySellImage.image = [self.dealVO.entrustBs isEqualToString:@"1"]?[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jy_buy"]:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jy_sell"];
    self.stockNameLabel.text = self.dealVO.stockName;
    self.tradeTimeLabel.text = [self getDateStringByTime:self.dealVO.businessTime];
    self.buySellAmountLabel.text = [NSString stringWithFormat:@"%.2f",self.dealVO.businessBalance.doubleValue];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.dealVO.businessPrice.doubleValue];
    self.tradeAmountLabel.text = self.dealVO.businessAmount.stringValue;
}

- (void)applyHistoryData {
    UIColor *textColor = [self.historyVO.entrustBs isEqualToString:@"1"]?color6_text_xgw:color8_text_xgw;
    self.stockNameLabel.textColor = textColor;
    self.tradeTimeLabel.textColor = textColor;
    self.buySellAmountLabel.textColor = textColor;
    self.priceLabel.textColor = textColor;
    self.tradeAmountLabel.textColor = textColor;
    
    self.buySellImage.image = [self.historyVO.entrustBs isEqualToString:@"1"]?[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jy_buy"]:[UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/ic_jy_sell"];
    self.stockNameLabel.text = self.historyVO.stockName;
    self.buySellAmountLabel.text = [NSString stringWithFormat:@"%.2f",self.historyVO.businessBalance.doubleValue];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.historyVO.businessPrice.doubleValue];
    self.tradeAmountLabel.text = self.historyVO.businessAmount.stringValue;
    
    if (self.viewType == TradeControllerTypeReal) {
        self.tradeTimeLabel.text = [self getDateStringBy:self.historyVO.date];
    }
    else {
        self.tradeTimeLabel.text = [TimeUtils getTimeStringWithNumber:self.historyVO.date formatString:@"yyyy/MM/dd"];
    }
}

-(NSString *)getDateStringBy:(NSNumber *)date
{
    NSInteger y, m, d;
    y = (date.integerValue / 10000) % 100;
    m = (date.integerValue % 10000) / 100;
    d = date.integerValue % 100;
    NSString *result = [NSString stringWithFormat:@"%02ld/%02ld/%02ld", (long)y, (long)m, (long)d];
    return result;
}

-(NSString *)getDateStringByTime:(NSNumber *)time
{
    NSInteger hh, mm, ss;
    hh = time.integerValue / 10000;
    mm = (time.integerValue % 10000) / 100;
    ss = time.integerValue % 100;
    
    NSString *result = [NSString stringWithFormat:@"%02ld:%02ld:%2ld",(long)hh, (long)mm,(long)ss];
    return result;
}

- (void)initSubviews {
    self.wrapperView = [[UIView alloc]init];
    [self.contentView addSubview:self.wrapperView];
    self.wrapperView.backgroundColor = [UIColor whiteColor];
    
    self.line = [[UIView alloc]init];
    [self.wrapperView addSubview:self.line];
    self.line.backgroundColor = color16_other_xgw;
    
//    self.stockNameLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.stockNameLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.stockNameLabel];
//    self.tradeTimeLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.tradeTimeLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.tradeTimeLabel];
//    self.tradeTimeLabel.font = font2_number_xgw;
    
//    self.buySellAmountLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.buySellAmountLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.buySellAmountLabel];
//    self.buySellAmountLabel.font = font2_number_xgw;
//    self.priceLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.priceLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.wrapperView addSubview:self.priceLabel];
//    self.priceLabel.font = font2_number_xgw;
    
//    self.tradeAmountLabel = [UILabel didBuildLabelWithText:@"" fontSize:14.0f textColor:color2_text_xgw wordWrap:NO];
    self.tradeAmountLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color2_text_xgw wordWrap:NO];

    [self.wrapperView addSubview:self.tradeAmountLabel];
//    self.tradeAmountLabel.font = font2_number_xgw;
    
    self.buySellImage = [[UIImageView alloc]init];
    [self.wrapperView addSubview:self.buySellImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.wrapperView.size = self.size;
    self.buySellImage.size = self.buySellImage.image.size;
    [self.stockNameLabel sizeToFit];
    [self.tradeTimeLabel sizeToFit];
    [self.priceLabel sizeToFit];
    [self.tradeAmountLabel sizeToFit];
    [self.buySellAmountLabel sizeToFit];
    
    self.buySellImage.x = 10.0f;
    self.buySellImage.y = (self.height - self.buySellImage.height) * 0.5f;
    self.stockNameLabel.x = self.buySellImage.x + self.buySellImage.width + 5.0f;
    self.stockNameLabel.y = (self.height - self.stockNameLabel.height - self.tradeTimeLabel.height) * 0.5f;
    self.tradeTimeLabel.x = self.stockNameLabel.x;
    self.tradeTimeLabel.y = self.stockNameLabel.y + self.stockNameLabel.height;
    
//    CGFloat narrow = self.width * 0.17f;
//    CGFloat wide = self.width * 0.33f;
//    CGFloat narrow = self.width * 0.2f;
    self.priceLabel.x = self.width * 0.4f + (self.width * 0.1f - self.priceLabel.width);
    self.priceLabel.y = (self.height - self.priceLabel.height) * 0.5f;
    
    self.tradeAmountLabel.x = self.width * 0.55f + (self.width * 0.1f - self.tradeAmountLabel.width);
    self.tradeAmountLabel.y = self.priceLabel.y;
    
    self.buySellAmountLabel.x = self.width - self.buySellAmountLabel.width - 10.0f;
    self.buySellAmountLabel.y = self.priceLabel.y;
    
    self.line.size = CGSizeMake(self.width, 0.5f);
    self.line.y = self.height - 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
