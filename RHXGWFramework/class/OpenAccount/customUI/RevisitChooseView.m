//
//  RevisitChooseView.m
//  JinHuiXuanGuWang
//
//  Created by zhanghang on 2017/7/11.
//
//

#import "RevisitChooseView.h"
#import "CRHRiskTestVo.h"
@interface RevisitChooseView ()
@property (nonatomic,strong)UIButton * selectBtn;
@property (nonatomic,strong)UILabel * answerLabel;
kRhPCopy NSString * answer;
kRhPAssign BOOL defaultSelet;


@end
@implementation RevisitChooseView

- (instancetype)initWithContent:(NSString * )str andDefaultSelet:(NSNumber *)defaultSelet{
    
    if (self = [super init]) {
        
        self.answer = str;
        self.defaultSelet = [defaultSelet boolValue];
        
        [self initSubViews];
    }
    
    return self;
}

-(void)initSubViews{
    
  
     self.selectBtn = [UIButton didBuildButtonWithNormalImage:img_open_circleNoClick highlightImage:img_open_circleNoClick];
   
 
    [self.selectBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectBtn];
    
    self.answerLabel = [UILabel didBuildLabelWithText:self.answer font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.answerLabel];
    
    if (self.defaultSelet) {
        [self.selectBtn setImage:img_open_circleClick forState:UIControlStateNormal];
        self.answerLabel.textColor = [UIColor colorWithRXHexString:@"0x0d64e9"];
    }
    else{
        [self.selectBtn setImage:img_open_circleNoClick forState:UIControlStateNormal];
        self.answerLabel.textColor = color2_text_xgw;
        
    }

    
}
-(void)layoutSubviews{
  [super layoutSubviews];
    UIImage * image = [UIImage imageNamed:@"Frameworks/RHXGWFramework.framework/icon_nonclick_survey-1"];
    self.selectBtn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [self.answerLabel sizeToFit];
    self.answerLabel.origin = CGPointMake(CGRectGetMaxX(self.selectBtn.frame)+10, self.selectBtn.origin.y);
    
    if (self.widthCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithFloat:CGRectGetMaxX(self.answerLabel.frame)] forKey:@"width"];
        [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.answerLabel.frame)] forKey:@"height"];
        self.widthCallBack(param);
    }
    
   
}
-(void)BtnClick:(UIButton *)btn{
    
    
    if (self.selectCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithBool:self.defaultSelet] forKey:@"select"];
        [param setObject:self forKey:@"seleBtnView"];
        self.selectCallBack(param);
    }
    
    [self setNeedsLayout];
}


@end
