//
//  LetterView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/12.
//
//

#import "LetterView.h"
#import "ForumLayoutManager.h"
#import "CRHRiskResultVo.h"

@interface LetterView ()
/**投资者*/
@property (nonatomic,strong)UILabel * moneymanLb;
@property (nonatomic,strong)UILabel * evaluateTitleLb;
/**风险承受能力标题*/
@property (nonatomic,strong)UILabel * riskBearLb;
@property (nonatomic,strong)UILabel * riskBearValueLb;
/**投资期限标题*/
@property (nonatomic,strong)UILabel * investmentTimeLb;
@property (nonatomic,strong)UILabel * investmentTimeValueLb;
/**投资品种标题*/
@property (nonatomic,strong)UILabel * investmentKindLb;
@property (nonatomic,strong)UILabel * investmentKindValueLb;
/**郑重提醒文本*/
@property (nonatomic,strong)UILabel * promptLbOne;
@property (nonatomic,strong)UILabel * promptLbTwo;

/**盖章处文字*/
@property (nonatomic,strong)UILabel * sealTextLb;
/**签署日期*/
@property (nonatomic,strong)UILabel * signTimeLb;
@property (nonatomic,copy) NSString * dateTime;

@property (nonatomic,strong)NSDictionary * textParams;


@end

@implementation LetterView
-(instancetype)initWithParams:(NSDictionary *)params{
    
    if (self = [super init]) {
        
      _textParams = params;
        //获取当前的时间
        _dateTime = [TimeUtils getTimeStringWithNumber:@([NSDate getSystemTime]) formatString:@"yyyy年MM月dd日"];
        [self initSubViews];

    }
    
    
    return self;
    
}
-(void)initSubViews{

        self.moneymanLb = [UILabel didBuildLabelWithText:@"尊敬的客户" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
        [self addSubview:self.moneymanLb];


        self.evaluateTitleLb = [UILabel didBulidLabelWithText:[self.textParams objectForKey:@"evaluateTitle"] font:font1_common_xgw textColor:color2_text_xgw Spacing:12];
        [self addSubview:self.evaluateTitleLb];
        /**您的风险承受能力:*/
        self.riskBearLb = [UILabel didBuildLabelWithText:[self.textParams objectForKey:@"riskBear"] font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
        [self addSubview:self.riskBearLb];

        self.riskBearValueLb = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color6_text_xgw wordWrap:NO];
        [self addSubview:self.riskBearValueLb];
    
        /**您的拟投资期限为:*/
        self.investmentTimeLb = [UILabel didBuildLabelWithText:[self.textParams objectForKey:@"investmentTime"] font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
        [self addSubview:self.investmentTimeLb];

        self.investmentTimeValueLb = [UILabel didBuildLabelWithText:@"" font:font1_common_xgw textColor:color6_text_xgw wordWrap:NO];
        [self addSubview:self.investmentTimeValueLb];

    
    
       /**您的拟投资品种为:*/
        self.investmentKindLb = [UILabel didBuildLabelWithText:[self.textParams objectForKey:@"investmentKind"] font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
        [self addSubview:self.investmentKindLb];

        self.investmentKindValueLb = [UILabel didBulidLabelWithText:@"" font:font1_common_xgw textColor:color6_text_xgw Spacing:0];
        [self addSubview:self.investmentKindValueLb];
    
    
        self.promptLbOne = [UILabel didBulidLabelWithText:[self.textParams objectForKey:@"promptTextOne"] font:font1_common_xgw textColor:color2_text_xgw Spacing:12];
        [self addSubview:self.promptLbOne];

        self.promptLbTwo = [UILabel didBulidLabelWithText:[self.textParams objectForKey:@"promptTextTwo"] font:font1_common_xgw textColor:color2_text_xgw Spacing:12];
        [self addSubview:self.promptLbTwo];
       /**盖章处签名*/
        self.sealTextLb = [UILabel didBuildLabelWithText:[self.textParams objectForKey:@"sealText"] font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
        [self addSubview:self.sealTextLb];

        self.signTimeLb = [[UILabel alloc]init];
        self.signTimeLb.font = font1_common_xgw;
        self.signTimeLb.textColor = color4_text_xgw;
        NSMutableAttributedString *agreementLbTextColor = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"签署日期: %@",_dateTime]];
        NSRange agreeRangel = [[agreementLbTextColor string] rangeOfString:_dateTime];
        [agreementLbTextColor addAttribute:NSForegroundColorAttributeName value:color6_text_xgw range:agreeRangel];
        [self.signTimeLb setAttributedText:agreementLbTextColor];
        [self addSubview:self.signTimeLb];

}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.moneymanLb sizeToFit];
    self.moneymanLb.size = CGSizeMake(200, 12);
    self.moneymanLb.origin = CGPointMake(16, 0);
    
    
    CGSize evaluateTitleSize = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:MAIN_SCREEN_WIDTH - 48.0f-32 fontsize:12 content:self.evaluateTitleLb.text space:12.0];
    
    self.evaluateTitleLb.frame = CGRectMake(16, CGRectGetMaxY(self.moneymanLb.frame)+27, evaluateTitleSize.width, evaluateTitleSize.height);
    
    [self.riskBearLb sizeToFit];
    self.riskBearLb.origin = CGPointMake(16, CGRectGetMaxY(self.evaluateTitleLb.frame)+27);
    
    [self.riskBearValueLb sizeToFit];
    self.riskBearValueLb.origin = CGPointMake(CGRectGetMaxX(self.riskBearLb.frame)+10, self.riskBearLb.origin.y);
    
    [self.investmentTimeLb sizeToFit];
    self.investmentTimeLb.origin = CGPointMake(self.riskBearLb.origin.x, CGRectGetMaxY(self.riskBearValueLb.frame)+20);
    
    [self.investmentTimeValueLb sizeToFit];
    self.investmentTimeValueLb.origin = CGPointMake(self.riskBearValueLb.origin.x, self.investmentTimeLb.origin.y);
    
    [self.investmentKindLb sizeToFit];
    self.investmentKindLb.origin = CGPointMake(self.riskBearLb.origin.x, CGRectGetMaxY(self.investmentTimeValueLb.frame)+20);
    
    CGSize investmentKindValueSize = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:self.size.width - 32.0f-10-self.riskBearLb.size.width fontsize:12 content:self.investmentKindValueLb.text space:0];
    
    self.investmentKindValueLb.frame = CGRectMake(self.investmentTimeValueLb.origin.x, self.investmentKindLb.origin.y, investmentKindValueSize.width, investmentKindValueSize.height);
    
    CGSize promptLbOneSize = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:self.size.width-32 fontsize:12 content:self.promptLbOne.text space:12];
    
    self.promptLbOne.frame = CGRectMake(self.investmentKindLb.origin.x,CGRectGetMaxY(self.investmentKindValueLb.frame)+27, promptLbOneSize.width, promptLbOneSize.height);
    
    CGSize promptLbTwoSize = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:self.size.width-32  fontsize:12 content:self.promptLbTwo.text space:12];
    self.promptLbTwo.frame = CGRectMake(self.investmentKindLb.origin.x, CGRectGetMaxY(self.promptLbOne.frame)+27, promptLbTwoSize.width, promptLbTwoSize.height);
   
    
    
   // [self.signTimeLb sizeToFit];
    self.signTimeLb.size = CGSizeMake(160, 12);
    self.signTimeLb.origin = CGPointMake(self.size.width-16-self.signTimeLb.size.width, CGRectGetMaxY(self.promptLbTwo.frame)+56+self.signTimeLb.size.height);
    
//    [self.sealTextLb sizeToFit];
    self.sealTextLb.size = CGSizeMake(160, 12);

    self.sealTextLb.origin = CGPointMake(self.signTimeLb.origin.x, CGRectGetMaxY(self.promptLbTwo.frame)+40);
    
    
}
- (NSInteger)getCurrentHeight{

    self.height = CGRectGetMaxY(self.signTimeLb.frame);
    
    return self.height;
    
}
-(void)setMoneyman:(NSString *)moneyman andLetterType:(LetterType)type{
    
    switch (type) {
        case topLetterType:
            self.moneymanLb.text = [NSString stringWithFormat:@"尊敬的投资者:  %@",moneyman];
            self.sealTextLb.text = [self.textParams objectForKey:@"sealText"] ;

            break;
            
        case bottomLetterType:
            self.moneymanLb.text = @"华创证券北京万寿路营业部";
            self.sealTextLb.text = [NSString stringWithFormat:@"本人确认:  %@",moneyman];
            break;
            
        default:
            break;
    }
    
    [self setNeedsLayout];
}
-(void)setViewData:(id)viewData{
    
    CRHRiskResultVo * VO = viewData;
    
    self.riskBearValueLb.text = VO.risk_level_name;
    
    self.investmentTimeValueLb.text = VO.en_invest_term;
    
//    self.investmentKindValueLb.text = VO.en_invest_kind;
      self.investmentKindValueLb.text = @"你好吗撒娇的就开始看见看见跨境电商旷达科技啊都快三季度卡时间段就开始大开杀戒打卡机的卡视角卡萨丁看似简单卡视角大";
    [self setNeedsLayout];
}
-(void)setViewDataWithModel:(id)model andClientName:(NSString *)name andLetterType:(LetterType)type{
    
    CRHRiskResultVo * VO = model;
    
    self.riskBearValueLb.text = VO.risk_level_name;
    
    self.investmentTimeValueLb.text = VO.en_invest_term;
    
        self.investmentKindValueLb.text = VO.en_invest_kind;
//    self.investmentKindValueLb.text = @"你好吗撒娇的就开始看见看见跨境电商旷达科技啊都快三季度卡时间段就开始大开杀戒打卡机的卡视角卡萨丁看似简单卡视角大";
    switch (type) {
        case topLetterType:
            self.moneymanLb.text = [NSString stringWithFormat:@"尊敬的投资者:  %@",name];
            self.sealTextLb.text = [self.textParams objectForKey:@"sealText"];
            
            break;
            
        case bottomLetterType:
            self.moneymanLb.text = @"华创证券北京万寿路营业部";
            self.sealTextLb.text = [NSString stringWithFormat:@"本人确认:  %@",name];
            break;
            
        default:
            break;
    }
    
    [self setNeedsLayout];

    
    
}

@end
