//
//  IPOQueryTableViewCell.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/15.
//
//

#import "IPOQueryTableViewCell.h"
#import "TradeIPOTodayVO.h"

@interface IPOQueryTableViewCell ()

kRhPStrong UILabel * nameLabel;

kRhPStrong UILabel * codeLabel;

kRhPStrong UILabel * firstL1Label;//配号 申购日期

kRhPStrong UILabel * firstL2Label;//市场类型 申购价格

kRhPStrong UILabel * secondL1Label;//数量 中签数量

kRhPStrong UILabel * secondL2Label;//委托日期 缴款金额

kRhPStrong UIImageView * stateImgView;//中签状态
@end


@implementation IPOQueryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    _nameLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:_nameLabel];
    
    _codeLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.contentView addSubview:_codeLabel];
    
    _firstL1Label = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.contentView addSubview:_firstL1Label];
    
    _firstL2Label = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.contentView addSubview:_firstL2Label];
    
    _secondL1Label = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.contentView addSubview:_secondL1Label];
    
    _secondL2Label = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.contentView addSubview:_secondL2Label];
    
    _stateImgView = [[UIImageView alloc] initWithImage:img_IPO_default];
    [self.contentView addSubview:_stateImgView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_nameLabel sizeToFit];
    [_codeLabel sizeToFit];
    _nameLabel.frame = CGRectMake(margin_12, margin_8, _nameLabel.width, _nameLabel.height);
    _codeLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + margin_8, margin_8, _codeLabel.width,_codeLabel.height);
    
    [_firstL1Label sizeToFit];
    _firstL1Label .frame = CGRectMake(_nameLabel.x, CGRectGetMaxY(_nameLabel.frame) + margin_8, _firstL1Label.width, _firstL1Label.height);
    
    [_firstL2Label sizeToFit];
    _firstL2Label.frame = CGRectMake(self.width / 2.0f, _firstL1Label.y, _firstL2Label.width, _firstL2Label.height);
    
    [_secondL1Label sizeToFit];
    _secondL1Label.frame = CGRectMake(_nameLabel.x, CGRectGetMaxY(_firstL1Label.frame) + margin_8, _secondL1Label.width, _secondL1Label.height);
    
    [_secondL2Label sizeToFit];
    _secondL2Label.frame = CGRectMake(_firstL2Label.x, _secondL1Label.y, _secondL2Label.width, _secondL2Label.height);
    
    _stateImgView.frame = CGRectMake(self.width - margin_12 - _stateImgView.width, (self.height - _stateImgView.height)/2.0f, _stateImgView.width, _stateImgView.height);
}

- (void)loadDataWithModel:(id)model{
    if (!model || ![model isKindOfClass:[TradeIPOTodayVO class]]) {
        return;
    }
    TradeIPOTodayVO * queryVO = (TradeIPOTodayVO *)model;
    _nameLabel.text = queryVO.stockName;
    _codeLabel.text = queryVO.stockCode;

    NSNumber * date = [TimeUtils getTimeWithString:[NSString stringWithFormat:@"%@",queryVO.businessDate] formatString:@"yyyyMMdd"];
    NSString * formatStr = [NSDate formatWithNumber:date formatString:@"yyyy-MM-dd"];
    
//    NSString * formatStr = [TimeUtils getTimeStringWithNumber:queryVO.businessDate formatString:@"yyyy-MM-dd"];
    if ([queryVO.type isEqualToString:kMatch]) {
        
        if (!queryVO.beginIssueNo || [queryVO.beginIssueNo integerValue] == 0) {
            _firstL1Label.text = @"配号 --";
        }
        else{
            _firstL1Label.text = [NSString stringWithFormat:@"配号 %@",queryVO.beginIssueNo];
        }
        NSString * marketType;
        switch ([queryVO.exchangeType integerValue]) {
            case 2:
                marketType = @"深证A股";
                break;
            case 1:
                marketType = @"上证A股";
                break;
//            case 3:
//                marketType = @"中小板";
//                break;
//            case 4:
//                marketType = @"创业板";
//                break;
            default:
                break;
        }
        _firstL2Label.text = [NSString stringWithFormat:@"市场类型 %@",marketType];
        _secondL1Label.text = [NSString stringWithFormat:@"数量 %@",queryVO.occurAmount];
        _secondL2Label.text = [NSString stringWithFormat:@"委托日期 %@",formatStr];
        _stateImgView.hidden = YES;
    }
    else if ([queryVO.type isEqualToString:kLucky]){
//        queryVO.businessPrice = @14.89;
//        queryVO.occurAmount = @1000;
        _firstL1Label.text = [NSString stringWithFormat:@"申购日期 %@",formatStr];
        if ([queryVO.businessPrice floatValue] == 0.0f) {
            _firstL2Label.text = @"申购价格 --";
        }
        else{
            _firstL2Label.text = [NSString stringWithFormat:@"申购价格 %@",queryVO.businessPrice];
        }
//        _secondL1Label.text = [NSString stringWithFormat:@"中签数量 %@",queryVO.occurAmount];
        if ([queryVO.issueStatus isEqual:@0]) {
            //待公布
            _secondL1Label.text = @"中签数量 --";
            _secondL2Label.hidden = YES;
            _stateImgView.image = img_IPO_wait;
        }
        else if([queryVO.issueStatus isEqual:@1]){
            //已公布
            if ([queryVO.businessPrice floatValue] == 0.0f) {
                _secondL1Label.text = @"中签数量 0";
                _secondL2Label.hidden = YES;
                _stateImgView.image = img_IPO_unLucky;
            }
            else{
                _secondL1Label.text = [NSString stringWithFormat:@"中签数量 %@",queryVO.occurAmount];
                _secondL2Label.hidden = NO;
                _secondL2Label.text = [NSString stringWithFormat:@"缴款金额 %.2f",[queryVO.businessPrice floatValue] * [queryVO.occurAmount floatValue]];
                _stateImgView.image = img_IPO_lucky;
            }
        }
    }
    
    _firstL1Label.attributedText = [CPStringHandler getStringWithStr:_firstL1Label.text sepByStr:@" " withPreColor:color3_text_xgw withPreFont:font1_common_xgw withSufColor:color3_text_xgw withSufFont:font1_number_xgw];
    _firstL2Label.attributedText = [self getAttributeStrWithString:_firstL2Label.text];
    _secondL1Label.attributedText = [self getAttributeStrWithString:_secondL1Label.text];
    _secondL2Label.attributedText = [self getAttributeStrWithString:_secondL2Label.text];
    
    [self setNeedsLayout];
}

- (NSAttributedString *)getAttributeStrWithString:(NSString *)str{
   return [CPStringHandler getStringWithStr:str sepByStr:@" " withPreColor:color3_text_xgw withPreFont:font1_common_xgw withSufColor:color3_text_xgw withSufFont:font1_number_xgw];
}

@end
