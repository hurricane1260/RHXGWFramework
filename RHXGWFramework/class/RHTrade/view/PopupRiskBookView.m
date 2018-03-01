//
//  PopupRiskBookView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/24.
//
//

#import "PopupRiskBookView.h"
#import "ForumLayoutManager.h"
#import "RiskbookView.h"


@interface PopupRiskBookView ()

/**遮盖背景图*/
@property (nonatomic,strong) UIView * maskView;
/**背景View*/
@property (nonatomic,strong)UIView * bgView;

/**提示语  例如:
 您还未签署《风险警示股票风险揭示书》，无法买入风险警示股。
 */
@property (nonatomic,strong)UILabel * promptTitleLb;
@property (nonatomic,copy) NSString * promptTitle;
/**签署Btn*/
@property (nonatomic,strong)UIButton * signBtn;
@property (nonatomic,copy)NSString * signBtnTitle;
/**查看风险揭示书的Label*/
@property (nonatomic,strong)UILabel * checkLabel;
@property (nonatomic,copy)NSString * checkText;

/**风险揭示书*/
@property (nonatomic,strong)RiskbookView * riskBookView;
@property (nonatomic,assign)BOOL isCheck;



@end

@implementation PopupRiskBookView

-(instancetype)initRiskBookViewWithParams:(NSDictionary *)params{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.promptTitle = [params objectForKey:@"promptTitle"];
        self.signBtnTitle = [params objectForKey:@"signBtnTitle"];
        self.checkText = [params objectForKey:@"checkText"];
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{
    __weak typeof (self) welf = self;

    _maskView = [[UIView alloc] initWithFrame:self.frame];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.5;
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer * MaskViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskClick)];
    [_maskView addGestureRecognizer:MaskViewTap];
    [self addSubview:_maskView];
    
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = color1_text_xgw;
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    
    
    self.promptTitleLb = [UILabel didBulidLabelWithText:self.promptTitle font:font2_common_xgw  textColor:color3_text_xgw Spacing:10];
    [self.bgView addSubview:self.promptTitleLb];
    
    self.signBtn = [[UIButton alloc]init];
    [self.signBtn setTitle:self.signBtnTitle forState:UIControlStateNormal];
    [self.signBtn setTitleColor:color1_text_xgw forState:UIControlStateNormal];
    self.signBtn.titleLabel.font = font2_common_xgw;
    self.signBtn.backgroundColor = color6_text_xgw;
    self.signBtn.layer.cornerRadius = 6.0f;
    self.signBtn.layer.masksToBounds  =  YES;
    [self.signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.self.signBtn];
    
    self.checkLabel = [UILabel didBuildLabelWithText:self.checkText font:font1_common_xgw textColor:color8_text_xgw wordWrap:NO];
    self.checkLabel.userInteractionEnabled = YES;
    //加下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.checkText attributes:attribtDic];
    self.checkLabel.attributedText = attribtStr;
    UITapGestureRecognizer * checkTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkTap)];
    [self.checkLabel addGestureRecognizer:checkTap];
    [self.bgView addSubview:self.checkLabel];
    
    self.riskBookView = [[RiskbookView alloc]init];
    self.riskBookView.layer.cornerRadius = 6;
    self.riskBookView.layer.masksToBounds = YES;
    self.riskBookView.hidden = YES;
    self.riskBookView.recallBlock = ^{
        _isCheck = NO;
        welf.checkLabel.hidden = NO;
        welf.riskBookView.hidden = YES;
        [welf setNeedsLayout];
        
    };
    self.riskBookView.backgroundColor = color1_text_xgw;
    [self addSubview:self.riskBookView];
    
    
 }

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.isCheck) {
        if (IS_IPHONE_5) {
            self.bgView.frame = CGRectMake(24, 100, kDeviceWidth-48, 200);

        }else{
            
            self.bgView.frame = CGRectMake(24, 120, kDeviceWidth-48, 200);
        }

    }else{
        self.bgView.frame = CGRectMake(24, (self.maskView.height-200)/2, kDeviceWidth-48, 200);
    }
    
    CGSize promptTitleLbSize = [ForumLayoutManager autoSizeWidthOrHeight:MAXFLOAT width:self.bgView.width-40 fontsize:14 content:self.promptTitle space:10];
    
   self.promptTitleLb.frame = CGRectMake(20, 34, promptTitleLbSize.width, promptTitleLbSize
                                         .height);
    
    self.signBtn.frame = CGRectMake(52, CGRectGetMaxY(self.promptTitleLb.frame)+20, self.bgView.width-104, 44);
    
    [self.checkLabel sizeToFit];
    self.checkLabel.center = CGPointMake(self.bgView.width/2, CGRectGetMaxY(self.signBtn.frame)+12+self.checkLabel.size.height/2);
    if (IS_IPHONE_5) {
        self.riskBookView.frame = CGRectMake(24, CGRectGetMaxY(self.bgView.frame)-50, self.bgView.size.width, 280);
    }else{
      self.riskBookView.frame = CGRectMake(24, CGRectGetMaxY(self.bgView.frame)-50, self.bgView.size.width, 320);
    }
    
}
-(void)signBtnClick{
    
    if (self.singBtnBlock) {
        self.singBtnBlock();
    }
}
-(void)maskClick{
    if (self.removeRiskBookView) {
        self.removeRiskBookView();
    }
    
}

-(void)checkTap{
    _isCheck = YES;
    self.checkLabel.hidden = YES;
    self.riskBookView.hidden = NO;
    [self setNeedsLayout];
    
}
@end
