//
//  RiskLetterView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/12.
//
//


#define evaluateTitle @"本公司对您的风险承受能力进行了综合评估,现得到评估结果如下:"
#define sealText @"华创证券北京万寿路营业部"
#define promptText1 @"华创证券有限责任公司在此郑重提醒,本公司向您销售的金融产品或提供的金融服务将以您的风险承受能力等级和投资品种、期限为基础,若您提供的信息发生任何重大变化,您都应当及时书面通知本公司.本公司建议您审慎评判自身风险承受能力,结合自身投资行为,认真填写您的投资品种、期限作出审慎的投资判断."
#define promptText2 @"如您在审慎考虑后同意本公司的评估结果,请认真阅读下列内容,并确认以示同意."
#define promptText3 @"本人在贵公司的提示下,已经审慎考虑自身的风险承受能力在此确认:"
#define promptText4 @"本人经贵公司提示,已充分知晓贵公司向本人销售的金融产品或者提供的金融服务将以本人此次确认的风险承受能力等级和投资品种,期限为基础"
#define promptText5 @"若本人提供的信息发生任何重大变化,本人都会及时书面通知贵公司.本确认函系本人独立,自主,真是的意思表示,特此确认."
#import "RiskLetterView.h"
#import "ForumLayoutManager.h"
#import "TimeUtils.h"
#import "LetterView.h"
#import "CRHRiskResultVo.h"
#import "CRHClientInfoVo.h"

@interface RiskLetterView ()
@property (nonatomic,assign)CGFloat highet;
@property (nonatomic,strong)UIView * topView;
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UILabel * bgTitleLb;
@property (nonatomic,strong) LetterView * topLetterView;
@property (nonatomic,strong) LetterView * bottomLetterView;
/**中间的线*/
@property (nonatomic,strong)UIView * midLineView;
/**底部的线*/
@property (nonatomic,strong)UIView * bottomLineView;
/***/
@property (nonatomic,strong)UIView * leftLineView;
/***/
@property (nonatomic,strong)UIView * rightLineView;
@property (nonatomic,copy)NSString * clientName;

@end
@implementation RiskLetterView

-(instancetype)init{
    
    if (self = [super init]) {
       
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    
    self.topView = [[UIView alloc]init];
    self.topView.backgroundColor = color16_other_xgw;
    self.topView.layer.cornerRadius = 3;
    [self addSubview:self.topView];
    
    self.imageView = [[UIImageView alloc]init];
    [self addSubview:self.imageView];
    
    self.bgTitleLb = [UILabel didBuildLabelWithText:@"风险承受能力评估结果告知函" font:font3_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.topView addSubview:self.bgTitleLb];
    
    NSDictionary * oneParams = @{@"evaluateTitle":evaluateTitle,@"riskBear":@"您的风险承受能力:",@"investmentTime":@"您的拟投资期限为:",@"investmentKind":@"您的拟投资品种为:",@"promptTextOne":promptText1,@"promptTextTwo":promptText2,@"sealText":sealText};
    self.topLetterView = [[LetterView alloc]initWithParams:oneParams];
    [self addSubview:self.topLetterView];
    NSDictionary * twoParams = @{@"evaluateTitle":promptText3,@"riskBear":@"本人风险承受能力:",@"investmentTime":@"本人拟投资期限为:",@"investmentKind":@"本人拟投资品种为:",@"promptTextOne":promptText4,@"promptTextTwo":promptText5,@"sealText":sealText};
    self.bottomLetterView = [[LetterView alloc]initWithParams:twoParams];
    [self addSubview:self.bottomLetterView];

    
    self.midLineView = [[UIView alloc]init];
    self.midLineView.backgroundColor = color16_other_xgw;
    [self addSubview:self.midLineView];
    
    self.bottomLineView = [[UIView alloc]init];
    self.bottomLineView.backgroundColor = color16_other_xgw;
    [self addSubview:self.bottomLineView];
    
    self.rightLineView = [[UIView alloc]init];
    self.rightLineView.backgroundColor =color16_other_xgw;
    [self addSubview:self.rightLineView];
    //self.rightLineView=  [self addAutoLineViewWithColor:color16_other_xgw];
    
    self.leftLineView = [[UIView alloc]init];
    self.leftLineView.backgroundColor =color16_other_xgw;
    [self addSubview:self.leftLineView];
   
    //self.leftLineView = [self addAutoLineViewWithColor:color16_other_xgw];
    
 }
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.topView.frame = CGRectMake(0, 0, kDeviceWidth-48, 60);
    [self.bgTitleLb sizeToFit];
    self.bgTitleLb.center = CGPointMake(self.topView.center.x, self.topView.center.y);
   
    
    self.topLetterView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame)+24, self.size.width, [self.topLetterView getCurrentHeight]);
//    self.topLetterView.backgroundColor = [UIColor blueColor];

    self.midLineView.frame = CGRectMake(0, CGRectGetMaxY(self.topLetterView.frame)+40,self.size.width, 1.0);
    self.bottomLetterView.frame = CGRectMake(0, CGRectGetMaxY(self.midLineView.frame)+40, self.size.width, [self.bottomLetterView getCurrentHeight]);
//    self.bottomLetterView.backgroundColor = [UIColor yellowColor];
    self.bottomLineView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomLetterView.frame)+40,self.size.width, 1.0);

    self.leftLineView.frame =CGRectMake(0.5, 0, 1, self.bottomLineView.origin.y);
    self.rightLineView.frame =CGRectMake(self.size.width-0.5, 0, 1, self.bottomLineView.origin.y);

    
}
- (NSInteger)getCurrentHeight{

    self.height = CGRectGetMaxY(self.bottomLineView.frame);
   
    return self.height;
    
}
-(void)setViewData:(id)viewData{
    if (![viewData isKindOfClass:[CRHRiskResultVo class]]&&![viewData isKindOfClass:[CRHClientInfoVo class]]) {
        return;
    }
    if ([viewData isKindOfClass:[CRHClientInfoVo class]]) {
        CRHClientInfoVo * VO = viewData;
        if (![NSString isBlankString:VO.client_name]) {
            
            self.clientName = VO.client_name;
//            [self.topLetterView setMoneyman:VO.client_name andLetterType:topLetterType];
//            [self.bottomLetterView setMoneyman:VO.client_name andLetterType:bottomLetterType];
 
        }
    }
    if ([viewData isKindOfClass:[CRHRiskResultVo class]]) {
        
        self.topLetterView.viewData = viewData;
        self.bottomLetterView.viewData = viewData;
    }
    
      [self setNeedsLayout];
}

-(void)setViewDataWithClientVo:(CRHClientInfoVo *)ClientVo RiskResultVo:(CRHRiskResultVo *)RiskResultVo{
    
    if (![ClientVo isKindOfClass:[CRHClientInfoVo class]]&&![RiskResultVo isKindOfClass:[CRHRiskResultVo class]]) {
        return;
    }
    
    
    self.clientName = ClientVo.client_name;
 
    [self.topLetterView setViewDataWithModel:RiskResultVo andClientName:self.clientName andLetterType:topLetterType];
    [self.bottomLetterView setViewDataWithModel:RiskResultVo andClientName:self.clientName andLetterType:bottomLetterType];
    
    
    [self setNeedsLayout];

    
}





@end
