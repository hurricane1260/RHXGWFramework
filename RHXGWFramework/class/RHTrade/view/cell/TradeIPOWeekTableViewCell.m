//
//  TradeIPOWeekTableViewCell.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/12/13.
//
//

#import "TradeIPOWeekTableViewCell.h"
#import "TradeIPOWeekVO.h"
#import "TradeIPOTodayVO.h"
#import "CMStepper.h"
#import "RHStepper.h"

#define kShaStep 1000
#define kShenStep 500

typedef enum :NSInteger{
    IPOTodayType = 0,
    IPOWeekType,
    
}IPOCellType;

@interface TradeIPOWeekTableViewCell ()

kRhPStrong UILabel * typeLabel;

kRhPStrong UILabel * nameLabel;

kRhPStrong UILabel * codeLabel;

kRhPStrong UILabel * priceLabel;

kRhPStrong UILabel * PERatioLabel;

kRhPStrong UILabel * limitLabel;

kRhPStrong UIButton * applyBtn;

kRhPStrong UILabel * amountLabel;

kRhPStrong RHStepper * stepper;

kRhPAssign IPOCellType  type;

kRhPAssign NSInteger applyAmount;

kRhPStrong TradeIPOTodayVO * resultVO;

kRhPStrong NSNumber * index;
@end

@implementation TradeIPOWeekTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString     *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    _typeLabel = [UILabel didBuildT4Label];
    [self.contentView addSubview:_typeLabel];
    
    _nameLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.contentView addSubview:_nameLabel];
    
    _codeLabel = [UILabel didBuildLabelWithText:@"" font:font2_number_xgw textColor:color4_text_xgw wordWrap:NO];
    [self.contentView addSubview:_codeLabel];
    
    _priceLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.contentView addSubview:_priceLabel];
    
    _PERatioLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.contentView addSubview:_PERatioLabel];
    
    _limitLabel = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.contentView addSubview:_limitLabel];
    
    _amountLabel = [UILabel didBuildLabelWithText:@"申购数量：" font:font1_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.contentView addSubview:_amountLabel];
    
    __weak typeof (self) welf = self;
    _stepper = [[RHStepper alloc] init];
    _stepper.applyNumCallBack = ^(NSDictionary * param){
        if ([param objectForKey:@"applyNum"]) {
            NSNumber * modifyNum = [param objectForKey:@"applyNum"];
            welf.resultVO.applyAmount = modifyNum;

            if (![welf.resultVO.entrusted boolValue]) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                [dic setObject:welf.index forKey:@"index"];
                [dic setObject:modifyNum forKey:@"modifyNum"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kIPOApplyNumModNotificationName object:dic];
            }
        }
    };
    [self.contentView addSubview:_stepper];
    
    _applyBtn = [UIButton didBuildB7_1ButtonWithTitle:@""];
    [_applyBtn addTarget:self action:@selector(applyToPurchase:) forControlEvents:UIControlEventTouchUpInside];
    [_applyBtn setTitle:@"申购" forState:UIControlStateNormal];
    [self.contentView addSubview:_applyBtn];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _typeLabel.frame = CGRectMake(margin_12, margin_8, _typeLabel.width, _typeLabel.height);
    
    [_nameLabel sizeToFit];
    [_codeLabel sizeToFit];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_typeLabel.frame) + margin_12, margin_8, _nameLabel.width, _nameLabel.height);
    _codeLabel.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + margin_8, margin_8, _codeLabel.width,_codeLabel.height);
    
    [_priceLabel sizeToFit];
    _priceLabel .frame = CGRectMake(_nameLabel.x, CGRectGetMaxY(_nameLabel.frame) + margin_8, _priceLabel.width, _priceLabel.height);
    
    [_PERatioLabel sizeToFit];
    _PERatioLabel.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame) + margin_12, _priceLabel.y, _PERatioLabel.width, _PERatioLabel.height);
    _PERatioLabel.center = CGPointMake(self.center.x, _PERatioLabel.center.y);
    
    [_limitLabel sizeToFit];
    _limitLabel.frame = CGRectMake(self.width - margin_12 - _limitLabel.width, _priceLabel.y, _limitLabel.width, _limitLabel.height);
    
    [_amountLabel sizeToFit];
    _amountLabel.frame = CGRectMake(_nameLabel.x, CGRectGetMaxY(_priceLabel.frame) + margin_8 , _amountLabel.width, _amountLabel.height);
    
    _stepper.frame = CGRectMake(CGRectGetMaxX(_amountLabel.frame), _amountLabel.y, 130.0f, 27.0f);
    
    _applyBtn.frame = CGRectMake(self.width - margin_12 - _applyBtn.width, _amountLabel.y, _applyBtn.width, _applyBtn.height);
    
//    _stepper.center = CGPointMake(_stepper.center.x, _amountLabel.center.y + );
    _amountLabel.center = CGPointMake(_amountLabel.center.x, _applyBtn.center.y);
    _applyBtn.center = CGPointMake(_applyBtn.center.x, _amountLabel.center.y);
}

- (void)setType:(IPOCellType)type{
    _type = type;
    BOOL isShow = [[NSNumber numberWithInteger:type] boolValue];
    _amountLabel.hidden = isShow;
    _stepper.hidden = isShow;
    _applyBtn.hidden = isShow;
}

- (void)loadDataWithModel:(id)model withIndexPath:(NSInteger)row{
    if (!model || (![model isKindOfClass:[TradeIPOWeekVO class]] && ![model isKindOfClass:[TradeIPOTodayVO class]])) {
        return;
    }
    
    NSInteger midLength;
    if ([model isKindOfClass:[TradeIPOTodayVO class]]) {
        TradeIPOTodayVO * IPOVO = (TradeIPOTodayVO *)model;
        self.resultVO = IPOVO;
//        self.resultVO.index = row;
        self.index = [NSNumber numberWithInteger:row];
        
//        self.resultVO.applyAmount = IPOVO.enableAmount;
        _nameLabel.text = IPOVO.stockName;
        _codeLabel.text = IPOVO.stockCode;
        if (!IPOVO.lastPrice || [IPOVO.lastPrice floatValue] == 0.0) {
            _priceLabel.text = @"发行价格 --";
        }
        else{
            _priceLabel.text = [NSString stringWithFormat:@"发行价格 %@",IPOVO.lastPrice];
        }
        
        if (!IPOVO.peRatio || [IPOVO.peRatio floatValue] == 0.0f) {
            _PERatioLabel.text = @"市盈率 --";
        }
        else{
            _PERatioLabel.text = [NSString stringWithFormat:@"市盈率 %@",IPOVO.peRatio];
        }
        
        self.type = IPOTodayType;
        
//        _stepper.minValue = MIN([IPOVO.enableAmount integerValue], [IPOVO.lowAmount integerValue]);
        _stepper.maxValue = MIN([IPOVO.enableAmount integerValue], [IPOVO.highAmount integerValue]);
        _stepper.currentNumber = _stepper.maxValue;
        _stepper.step = kShenStep;
        NSString * marketType;
        switch ([IPOVO.exchangeType integerValue]) {
            case 2:{
                marketType = @"深";
                _stepper.minValue = kShenStep;
                _typeLabel.backgroundColor = color_textBg_orange;
            }break;
            case 1:{
                marketType = @"沪";
                _typeLabel.backgroundColor = color_textBg_blue;
                _stepper.minValue = kShaStep;
                _stepper.step = kShaStep;
            }break;
//            case 3:{
//                marketType = @"中";
//                _stepper.minValue = kShenStep;
//                _typeLabel.backgroundColor = color_textBg_red;
//            }break;
//            case 4:{
//                marketType = @"创";
//                _stepper.minValue = kShenStep;
//                _typeLabel.backgroundColor = color_textBg_purple;
//            }break;
            default:
                break;
        }
        _typeLabel.text = marketType;
        
        if (_stepper.maxValue == 0) {
            _limitLabel.text = @"可申购 0股";
            midLength = 1;
        }
        else{
            NSString * amount = [NSString stringWithFormat:@"%ld",(long)_stepper.maxValue];
            _limitLabel.text = [NSString stringWithFormat:@"可申购 %@股",amount];
            midLength = amount.length;
        }
        
        if ([IPOVO.entrusted boolValue]) {
            _applyBtn.enabled = NO;
            [_applyBtn setTitle:@"已申购" forState:UIControlStateDisabled];
            [_stepper setButtonEnable:NO];//申购后stepper不可用
        }
        else{
            if (_stepper.currentNumber == 0) {
                _applyBtn.enabled = NO;
                [_applyBtn setTitle:@"申购" forState:UIControlStateDisabled];
            }
            else{
                _applyBtn.enabled = YES;
            }
        }
    }
    else if ([model isKindOfClass:[TradeIPOWeekVO class]]){
        TradeIPOWeekVO * IPOVO = (TradeIPOWeekVO *)model;
        _nameLabel.text = IPOVO.stockName;
        _codeLabel.text = IPOVO.stockCode;
        if (!IPOVO.price || [IPOVO.price floatValue] == 0.0) {
            _priceLabel.text = @"发行价格 --";

        }
        else{
            _priceLabel.text = [NSString stringWithFormat:@"发行价格 %@",IPOVO.price];
        }
        if (!IPOVO.peRatio || [IPOVO.peRatio floatValue] == 0.0f) {
            _PERatioLabel.text = @"市盈率 --";
        }
        else{
            _PERatioLabel.text = [NSString stringWithFormat:@"市盈率 %@",IPOVO.peRatio];
        }
        self.type = IPOWeekType;
        
        NSString * marketType;
        switch ([IPOVO.type integerValue]) {
            case 1:
            case 3:
            case 4:{
                marketType = @"深";
                _typeLabel.backgroundColor = color_textBg_orange;
            }break;
            case 2:{
                marketType = @"沪";
                _typeLabel.backgroundColor = color_textBg_blue;
            }break;
//            case 3:{
//                marketType = @"中";
//                _typeLabel.backgroundColor = color_textBg_red;
//            }break;
//            case 4:{
//                marketType = @"创";
//                _typeLabel.backgroundColor = color_textBg_purple;
//            }break;
            default:
                break;
        }
        _typeLabel.text = marketType;
        
        if (!IPOVO.personAmount || [IPOVO.personAmount floatValue] == 0.0) {
            _limitLabel.text = @"申购上限 0股";
            midLength = 1;
        }
        else{
            NSString * amount = [NSString stringWithFormat:@"%ld",(long)([IPOVO.personAmount floatValue] * 10000)];
            _limitLabel.text = [NSString stringWithFormat:@"申购上限 %@股",amount];
            midLength = amount.length;
        }
    }
    
     NSString * preStr;
     NSString * midStr;
     NSString * sufStr;
    _priceLabel.attributedText = [self getAttributeStrWithStr:_priceLabel.text];
    _PERatioLabel.attributedText = [self getAttributeStrWithString:_PERatioLabel.text];
    
    NSRange range = [_limitLabel.text rangeOfString:@" "];
     preStr = [_limitLabel.text substringToIndex:range.location];
     midStr = [_limitLabel.text substringWithRange:NSMakeRange(range.location, midLength + 1)];
     sufStr = [_limitLabel.text substringFromIndex:range.location + 1 + midLength];
     _limitLabel.attributedText = [CPStringHandler getStringWithStr:preStr withFont:font1_common_xgw andMidString:midStr withFont:font1_number_xgw AppendString:sufStr withFont:font1_common_xgw];
    
    [self setNeedsLayout];
}

- (void)applyToPurchase:(UIButton *)btn{
    if (!btn.enabled) {
        return;
    }
    if (!self.resultVO) {
        return;
    }
//    if (self.applyCallBack) {
//        NSMutableDictionary * param = [NSMutableDictionary dictionary];
//        [param setObject:self.resultVO forKey:@"applyKey"];
//        self.applyCallBack(param);
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kIPOApplyNotificationName object:self.resultVO];
    
}

- (NSAttributedString *)getAttributeStrWithString:(NSString *)str{
    return [CPStringHandler getStringWithStr:str sepByStr:@" " withPreColor:color3_text_xgw withPreFont:font1_common_xgw withSufColor:color3_text_xgw withSufFont:font1_number_xgw];
}

- (NSAttributedString *)getAttributeStrWithStr:(NSString *)str{
    return [CPStringHandler getStringWithStr:str sepByStr:@" " withPreColor:color3_text_xgw withPreFont:font1_common_xgw withSufColor:color6_text_xgw withSufFont:font1_number_xgw];
}

@end
