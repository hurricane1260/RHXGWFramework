//
//  IPOTabHeaderView.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/15.
//
//

#import "IPOTabHeaderView.h"
#import "TradeIPOWeekVO.h"
#import "TradeIPOTodayVO.h"

@interface IPOTabHeaderView ()

kRhPStrong UILabel * dateLabel;

kRhPStrong UILabel * weekLabel;

kRhPStrong UILabel * todayLabel;

@end

@implementation IPOTabHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
        self.contentView.backgroundColor = color17_other_xgw;
        self.layer.borderColor = color16_other_xgw.CGColor;
        self.layer.borderWidth = 0.5f;
    }
    return self;
}

- (void)initSubviews{
    _dateLabel = [UILabel didBuildLabelWithText:@"" font:font1_number_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:_dateLabel];
    
    _weekLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:_weekLabel];
    
    _todayLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self addSubview:_todayLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_dateLabel sizeToFit];
    [_weekLabel sizeToFit];
    [_todayLabel sizeToFit];
    
    _dateLabel.frame = CGRectMake(margin_12, (self.height - _dateLabel.height)/2.0f, _dateLabel.width, _dateLabel.height);
    
    _weekLabel.frame = CGRectMake(CGRectGetMaxX(_dateLabel.frame) + margin_12, _dateLabel.y, _weekLabel.width, _weekLabel.height);
    
    _todayLabel.frame = CGRectMake(CGRectGetMaxX(_weekLabel.frame) + margin_12, _dateLabel.y, _todayLabel.width, _todayLabel.height);
    
}

-(void)setHeaderData:(id)headerData{
    if (!headerData || (![headerData isKindOfClass:[TradeIPOWeekVO class]] && ![headerData isKindOfClass:[TradeIPOTodayVO class]])) {
        return;
    }
    if ([headerData isKindOfClass:[TradeIPOWeekVO class]]) {
        TradeIPOWeekVO * weekVO = (TradeIPOWeekVO *)headerData;
        _dateLabel.text = weekVO.applyDate;
        NSTimeInterval time = [[TimeUtils getTimeWithString:weekVO.applyDate formatString:@"yyyy-MM-dd"] doubleValue];
        _weekLabel.text = [NSDate getWeekDayFordate:time];
    }
    else if([headerData isKindOfClass:[TradeIPOTodayVO class]]){
        TradeIPOTodayVO * weekVO = (TradeIPOTodayVO *)headerData;
        
        NSNumber * date = [TimeUtils getTimeWithString:[NSString stringWithFormat:@"%@",weekVO.businessDate] formatString:@"yyyyMMdd"];
        NSString * dateStr = [NSDate formatWithNumber:date formatString:@"yyyy-MM-dd"];
        _dateLabel.text = dateStr;
        
        NSTimeInterval time = [[TimeUtils getTimeWithString:dateStr formatString:@"yyyy-MM-dd"] doubleValue];
        if (weekVO.serverTime && [weekVO.serverTime longLongValue] != 0) {
            time = [weekVO.serverTime longLongValue];
        }
        _weekLabel.text = [NSDate getWeekDayFordate:time];
        
        NSString * today = [NSDate formatWithTimeInterval:[[NSDate date] timeIntervalSince1970] formatString:@"yyyy-MM-dd"];
        if ([today isEqualToString:dateStr]) {
            _todayLabel.text = @"今天";
        }
    }
        [self setNeedsLayout];
}


@end
