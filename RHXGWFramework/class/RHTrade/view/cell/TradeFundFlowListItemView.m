//
//  TradeFundFlowListItemView.m
//  stockscontest
//
//  Created by rxhui on 15/7/14.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import "TradeFundFlowListItemView.h"
#import "TransferFlowListVO.h"
#import "TransferHistoryListVO.h"

@interface TradeFundFlowListItemView ()

@property (nonatomic, strong) UILabel *timeTitleLabel;

@property (nonatomic, strong) UILabel *operationTitleLabel;

@property (nonatomic, strong) UILabel *balanceTitleLabel;

@property (nonatomic, strong) UILabel *statusTitleLabel;

@property (nonatomic, strong) UILabel *timeValueLabel;

@property (nonatomic, strong) UILabel *operationValueLabel;

@property (nonatomic, strong) UILabel *balanceValueLabel;

@property (nonatomic, strong) UILabel *statusValueLabel;

@property (nonatomic, strong) UIView *seperatorLine;

kRhPStrong UIView * wrapView;

kRhPStrong UILabel * resonLabel;

kRhPAssign BOOL showReason;
@end

@implementation TradeFundFlowListItemView

@synthesize itemData = _itemData;



-(void)setItemData:(id)aData {
    if (_itemData) {
        _itemData = nil;
    }
    _itemData = aData;
    if ([_itemData isKindOfClass:[TransferFlowListVO class]]) {
        [self clearData];
        [self applyData];
        [self setNeedsLayout];
    }
    else if ([_itemData isKindOfClass:[TransferHistoryListVO class]]) {
        [self clearData];
        [self applyHistoryData];
        [self setNeedsLayout];
    }
}

-(void)clearData {
    self.timeValueLabel.text = @"";
    self.operationValueLabel.text = @"";
    self.balanceValueLabel.text = @"";
    self.statusValueLabel.text = @"";
}

-(void)applyData {
    TransferFlowListVO *item = (TransferFlowListVO *)_itemData;
    NSMutableString *mutaString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",item.entrustTime]];
    if (mutaString.length == 5) {
        [mutaString insertString:@"0" atIndex:0];
    }
    [mutaString insertString:@":" atIndex:2];
    [mutaString insertString:@":" atIndex:5];
    self.timeValueLabel.text = mutaString.copy;
    
    self.operationValueLabel.text = item.transName;
    
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",item.occurBalance]];
    self.balanceValueLabel.text = [self getDecimalStringFor:decimalNumber];
    
    self.statusValueLabel.text = item.entrustStatus;
    
    if (item.remark.length && [item.entrustStatus isEqualToString:@"作废"]) {
        self.resonLabel.text = item.remark;
        self.showReason = YES;
    }
    [self setNeedsLayout];
}

- (void)setShowReason:(BOOL)showReason{
    _showReason = showReason;
    if (showReason) {
        CGSize size = [self.resonLabel.text boundingRectWithSize:CGSizeMake(MAIN_SCREEN_WIDTH - 12.0f * 2.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1_common_xgw} context:nil].size;

        if (_showCallBack) {
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            [param setObject:[NSNumber numberWithFloat:size.height + 16.0f] forKey:@"height"];
            _showCallBack(param);
        }
    }
}

-(void)applyHistoryData {
    TransferHistoryListVO *item = (TransferHistoryListVO *)_itemData;
    
//    NSLog(@"--%@",item.entrustDate);
    
    NSMutableString *dateString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",item.entrustDate]];
    [dateString deleteCharactersInRange:NSMakeRange(0, 2)];
    [dateString insertString:@"/" atIndex:2];
    [dateString insertString:@"/" atIndex:5];
    
//    NSMutableString *timeString = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@",item.entrustTime]];
//    if (timeString.length == 5) {
//        [timeString insertString:@"0" atIndex:0];
//    }
//    [timeString insertString:@":" atIndex:2];
//    [timeString insertString:@":" atIndex:5];
    
//    [dateString insertString:timeString.copy atIndex:dateString.length];
    
    self.timeValueLabel.text = dateString.copy;
    
    self.operationValueLabel.text = item.businessType;
    
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",item.occurBalance]];
    self.balanceValueLabel.text = [self getDecimalStringFor:decimalNumber];
    
    self.statusValueLabel.text = item.entrustStatus;
    
    if (item.bankErrorInfo.length && [item.entrustStatus isEqualToString:@"作废"]) {
        self.resonLabel.text = item.bankErrorInfo;
        self.showReason = YES;
    }
    [self setNeedsLayout];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
        self.showReason = NO;
    }
    return self;
}

-(void)initSubviews {
    self.timeTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.timeTitleLabel];
    self.timeTitleLabel.text = @"时间";
    self.timeTitleLabel.textColor = color4_text_xgw;
    self.timeTitleLabel.font = font3_common_xgw;
    
    self.operationTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.operationTitleLabel];
    self.operationTitleLabel.text = @"操作";
    self.operationTitleLabel.textColor = color4_text_xgw;
    self.operationTitleLabel.font = font3_common_xgw;
    
    self.balanceTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.balanceTitleLabel];
    self.balanceTitleLabel.text = @"金额";
    self.balanceTitleLabel.textColor = color4_text_xgw;
    self.balanceTitleLabel.font = font3_common_xgw;
    
    self.statusTitleLabel = [[UILabel alloc]init];
    [self addSubview:self.statusTitleLabel];
    self.statusTitleLabel.text = @"状态";
    self.statusTitleLabel.textColor = color4_text_xgw;
    self.statusTitleLabel.font = font3_common_xgw;
    
    self.timeValueLabel = [[UILabel alloc]init];
    [self addSubview:self.timeValueLabel];
    self.timeValueLabel.textColor = color2_text_xgw;
    self.timeValueLabel.font = font3_number_xgw;
    
    self.operationValueLabel = [[UILabel alloc]init];
    [self addSubview:self.operationValueLabel];
    self.operationValueLabel.textColor = color2_text_xgw;
    self.operationValueLabel.font = font3_common_xgw;
    
    self.balanceValueLabel = [[UILabel alloc]init];
    [self addSubview:self.balanceValueLabel];
    self.balanceValueLabel.textColor = color2_text_xgw;
    self.balanceValueLabel.font = font3_number_xgw;
    
    self.statusValueLabel = [[UILabel alloc]init];
    [self addSubview:self.statusValueLabel];
    self.statusValueLabel.textColor = color2_text_xgw;
    self.statusValueLabel.font = font3_common_xgw;
    
    self.seperatorLine = [[UIView alloc]init];
    [self addSubview:self.seperatorLine];
    self.seperatorLine.backgroundColor = color18_other_xgw;
    
    self.wrapView = [[UIView alloc] init];
    self.wrapView.backgroundColor = color1_text_xgw;
    [self addSubview:self.wrapView];
    
    [self.wrapView addAutoLineWithColor:color16_other_xgw];
    
    self.resonLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color4_text_xgw wordWrap:YES];
    self.resonLabel.numberOfLines = 0;
    [self.wrapView addSubview:self.resonLabel];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10.0f;
    CGFloat layoutX = margin;
    CGFloat layoutY = margin;
    
    [self.timeTitleLabel sizeToFit];
    [self.timeValueLabel sizeToFit];
    [self.operationTitleLabel sizeToFit];
    [self.operationValueLabel sizeToFit];
    [self.balanceTitleLabel sizeToFit];
    [self.balanceValueLabel sizeToFit];
    [self.statusTitleLabel sizeToFit];
    [self.statusValueLabel sizeToFit];
    
    CGFloat averageMargin = ( self.width - self.timeValueLabel.width - self.operationValueLabel.width - self.balanceValueLabel.width - self.statusValueLabel.width - 30.0f ) * 0.33f;
    
    self.timeTitleLabel.y = layoutY;
    layoutY += self.timeTitleLabel.height + margin;
    self.timeValueLabel.x = layoutX;
    self.timeValueLabel.y = layoutY;
    self.timeTitleLabel.x = layoutX + (self.timeValueLabel.width - self.timeTitleLabel.width) * 0.5f;
    layoutX += self.timeValueLabel.width + averageMargin;
    layoutY = margin;
    
    self.operationTitleLabel.y = layoutY;
    layoutY += self.operationTitleLabel.height + margin;
    self.operationValueLabel.x = layoutX;
    self.operationValueLabel.y = layoutY;
    self.operationTitleLabel.x = layoutX + (self.operationValueLabel.width - self.operationTitleLabel.width) * 0.5f;
    layoutX += self.operationValueLabel.width + averageMargin;
    layoutY = margin;
    
    self.balanceTitleLabel.y = layoutY;
    layoutY += self.balanceTitleLabel.height + margin;
    self.balanceValueLabel.x = layoutX;
    self.balanceValueLabel.y = layoutY;
    self.balanceTitleLabel.x = layoutX + (self.balanceValueLabel.width - self.balanceTitleLabel.width) * 0.5f;
    layoutX += self.balanceValueLabel.width + averageMargin;
    layoutY = margin;
    
    self.statusTitleLabel.y = layoutY;
    layoutY += self.statusTitleLabel.height + margin;
    self.statusValueLabel.x = layoutX;
    self.statusValueLabel.y = layoutY;
    self.statusTitleLabel.x = layoutX + (self.statusValueLabel.width - self.statusTitleLabel.width) * 0.5f;
    
    self.wrapView.hidden = !self.showReason;
    if (self.showReason) {
        self.wrapView.frame = CGRectMake(0, CGRectGetMaxY(self.statusValueLabel.frame) + 12.0f, self.width, 100.0f);
        
        CGFloat offsetX = 12.0f;
        CGFloat offsetY = 8.0f;
        self.wrapView.autoLine.frame = CGRectMake(offsetX, 0.0, (self.width - offsetX * 2.0f), 0.5f);
        
        CGSize size = [self.resonLabel.text boundingRectWithSize:CGSizeMake(self.width - offsetX * 2.0f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1_common_xgw} context:nil].size;
        self.resonLabel.frame = CGRectMake(offsetX, offsetY, size.width,size.height);
        
        self.wrapView.height = self.resonLabel.height + offsetY * 2.0f;
        
    }
    else{
        self.wrapView.height = 0;
    }
    
    self.seperatorLine.height = margin;
    self.seperatorLine.y = self.height - self.seperatorLine.height;
    self.seperatorLine.width = self.width;
}

#pragma mark -- 千分位分隔算法
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

@end
