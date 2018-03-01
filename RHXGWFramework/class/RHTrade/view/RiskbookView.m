//
//  RiskbookView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/24.
//
//

#import "RiskbookView.h"
#import "ForumLayoutManager.h"


#define topLabelText @"本《风险揭示书》的提示事项仅为列举性质,未能详尽列明拟终止上市公司股票退市整理期交易的所有风险.为保护投资者利益,华创证券特别提示:"
#define midLabelText @"一、客户在参与退市整理期股票交易前，应充分了解客户买卖退市整理期股票应当采用限价委托的方式.\n 二、退市整理期拟终止上市公司股票已被证券交易所作出终止上市决定,在一定期限届满后将被终止上市，风险相对较大.\n 三、退市整理期股票，自退市整理期开始之日起,在风险警示板的交易期限仅为30 个交易日,期限届满后的次,，该股票终止上市,证券交易所对其予以摘牌.客户应当密切关注退市整理股票的剩余交易日和最后交易日,否则有可能错失卖出机会,造成不必要的损失.退市整理股票在风险警示板交易期间全天停牌的,停牌期间不计入上述30 个交易日的期限内.全天停牌的天数累计不超过5 个交易日.\n 四、拟终止上市公司股票退市整理期的交易可能存在流动性风险,客户买入后可能因无法在股票终止上市前及时卖出所持股票而导致损失.\n 五、客户在参与拟终止上市公司股票退市整理期交易前,应充分了解退市制度、退市整理期股票交易规定和进入退市整理期上市公司的基本面情况,并根据自身财务状况、实际需求及风险承受能力等,审慎考虑是否买入退市整理期股票.\n 六、按照现行有关规定,虽然主板、中小板上市公司股票被终止上市后可以向证券交易所申请重新上市,但须达到交易所重新上市条件,能否重新上市存在较大的不确定性.\n七、客户应当特别关注拟终止上市公司退市整理期期间发布的风险提示性公告,及时从指定信息披露媒体、上市公司网站以及证券公司网站等渠道获取相关信息."
#define bottomLabelText @"本人确认已知晓并理解《风险揭示书》的全部内容,愿意承担拟终止上市公司股票退市整理期交易的风险和损失."
@interface RiskbookView ()

@property (nonatomic,strong) UIScrollView * bgScrollView;
/**标题*/
@property (nonatomic,strong) UILabel * titleLb;
/**收回风险揭示书的Label*/
@property (nonatomic,strong)UILabel * checkLabel;
/**提示语 文字对应上面的宏*/
@property (nonatomic,strong)UILabel * topLabel;
/**条约*/
@property (nonatomic,strong)UILabel *midLabel;
/**本人确认语*/
@property (nonatomic,strong)UILabel * bottomLabel;
/**签署日期*/
@property (nonatomic,copy)NSString * dateStr;
@property (nonatomic,strong)UILabel * dateLabel;
/**客户姓名*/
@property (nonatomic,strong)UILabel * customerNameLabel;
@property (nonatomic,copy) NSString * customerName;

@end

@implementation RiskbookView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _dateStr = //获取当前的时间
        [TimeUtils getTimeStringWithNumber:@([NSDate getSystemTime]) formatString:@"yyyy/MM/dd"];
        [self initSubViews];
    }
    
    return self;
}

-(void)initSubViews{
    
    self.checkLabel = [UILabel didBuildLabelWithText:@"点击收回风险揭示书" font:font1_common_xgw textColor:color8_text_xgw wordWrap:NO];
    self.checkLabel.userInteractionEnabled = YES;
    //加下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"点击收回风险揭示书" attributes:attribtDic];
    self.checkLabel.attributedText = attribtStr;
    UITapGestureRecognizer * checkTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkTap)];
    [self.checkLabel addGestureRecognizer:checkTap];
    [self addSubview:self.checkLabel];
    
    
    self.bgScrollView = [[UIScrollView alloc]init];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.bgScrollView];
    
    self.titleLb = [UILabel didBuildLabelWithText:@"《退市整理期股票交易风险揭示书》" font:font2_common_xgw textColor:color3_text_xgw wordWrap:NO];
    [self.bgScrollView addSubview:self.titleLb];
    
    
    self.topLabel = [UILabel didBulidLabelWithText:topLabelText font:font1_common_xgw textColor:color2_text_xgw Spacing:10];
    [self.bgScrollView addSubview:self.topLabel];
    
    self.midLabel = [UILabel didBulidLabelWithText:midLabelText font:font1_common_xgw textColor:color2_text_xgw Spacing:10];
    [self.bgScrollView addSubview:self.midLabel];
    
    self.bottomLabel = [UILabel didBulidLabelWithText:bottomLabelText font:font1_common_xgw textColor:color2_text_xgw Spacing:10];
    [self.bgScrollView addSubview:self.bottomLabel];
    
    self.dateLabel = [UILabel didBuildLabelWithText:[NSString stringWithFormat:@"签署日期: %@",self.dateStr] font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.bgScrollView addSubview:self.dateLabel];
    
    self.customerNameLabel = [UILabel didBuildLabelWithText:[NSString stringWithFormat:@"客户签名: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"TradeClientName"]]font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self.bgScrollView addSubview:self.customerNameLabel];
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.checkLabel sizeToFit];
    self.checkLabel.center = CGPointMake(self.size.width/2, self.size.height-12-self.checkLabel.size.height/2);
    self.bgScrollView.frame = CGRectMake(0, 20, self.size.width, self.size.height-12-self.checkLabel.size.height-34);
    
    [self.titleLb sizeToFit];
    self.titleLb.center = CGPointMake(self.size.width/2, self.titleLb.size.height/2);
    
    CGSize topLabelSize = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:self.bgScrollView.size.width-40 fontsize:12 content:topLabelText space:10];
    
    self.topLabel.frame = CGRectMake(20, CGRectGetMaxY(self.titleLb.frame)+20, topLabelSize.width, topLabelSize.height);
    
    CGSize midLabelSize = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:self.bgScrollView.size.width-40 fontsize:12 content:midLabelText space:10];
    
    self.midLabel.frame = CGRectMake(20, CGRectGetMaxY(self.topLabel.frame)+20, midLabelSize.width, midLabelSize.height);
    
    CGSize bottomLabelSize = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:self.bgScrollView.size.width-40 fontsize:12 content:bottomLabelText space:10];
    
    self.bottomLabel.frame = CGRectMake(20, CGRectGetMaxY(self.midLabel.frame)+20, bottomLabelSize.width, bottomLabelSize.height);
    
    
    [self.dateLabel sizeToFit];
    self.dateLabel.origin = CGPointMake(self.bgScrollView.width-40-self.dateLabel.size.width, CGRectGetMaxY(self.bottomLabel.frame)+40);
    
    [self.customerNameLabel sizeToFit];
    self.customerNameLabel .origin = CGPointMake(self.dateLabel.origin.x, CGRectGetMaxY(self.bottomLabel.frame)+20);
    
    self.bgScrollView.contentSize = CGSizeMake(self.size.width, CGRectGetMaxY(self.dateLabel.frame));
    
}
-(void)checkTap{
    
    if (self.recallBlock) {
        self.recallBlock();
    }
}

@end
