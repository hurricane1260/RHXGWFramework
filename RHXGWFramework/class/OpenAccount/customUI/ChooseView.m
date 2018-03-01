//
//  ChooseView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/7/4.
//
//

#import "ChooseView.h"

@interface ChooseView ()

kRhPStrong UIButton * selectBtn;

kRhPStrong UILabel * answerLabel;

kRhPCopy NSString * answer;

kRhPStrong UIButton * coverBtn;

@end

@implementation ChooseView

- (instancetype)initWithContent:(NSString * )str{
    if (self = [super init]) {
        self.isSelected = NO;
        self.answer = str;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    self.selectBtn = [UIButton didBuildButtonWithNormalImage:img_open_circleNoClick highlightImage:img_open_circleNoClick];
    [self.selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectBtn];
    
    
    self.answerLabel = [UILabel didBuildLabelWithText:self.answer font:font2_common_xgw textColor:color2_text_xgw wordWrap:YES];
    self.answerLabel.numberOfLines = 0;
    [self addSubview:self.answerLabel];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.answer];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.answer length])];
    self.answerLabel.attributedText = attributedString;

    
    self.coverBtn = [[UIButton alloc]init];
    [self.coverBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.coverBtn];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIImage * image = [UIImage imageNamed:@"icon_nonclick_survey-1"];
    self.selectBtn.frame = CGRectMake(24.0f, 0, image.size.width, image.size.height);
    //增加文本间距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:3.0];
    NSDictionary *attribute = @{NSFontAttributeName:font2_common_xgw,NSParagraphStyleAttributeName:style};
    
    CGSize size = [self.answerLabel.text boundingRectWithSize:CGSizeMake(MAIN_SCREEN_WIDTH - 48.0f-16-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    self.answerLabel.frame = CGRectMake(CGRectGetMaxX(self.selectBtn.frame)+10, self.selectBtn.y, size.width, size.height);
    
    self.coverBtn.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    
    if (self.heightCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.answerLabel.frame)] forKey:@"height"];
        self.heightCallBack(param);
    }
    
}

- (void)btnClick:(UIButton *)btn{
    _isSelected = !_isSelected;
    
    if (self.selectCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithBool:_isSelected] forKey:@"select"];
        [param setObject:self forKey:@"seleBtnView"];
        self.selectCallBack(param);
    }
    
    [self setNeedsLayout];

}
-(void)setIsSelected:(BOOL)isSelected{
        _isSelected = isSelected;

    if (isSelected) {
        [self.selectBtn setImage:img_open_circleClick forState:UIControlStateNormal];
        self.answerLabel.textColor = [UIColor colorWithRXHexString:@"0x0d64e9"];
    }
    else{
        [self.selectBtn setImage:img_open_circleNoClick forState:UIControlStateNormal];
        self.answerLabel.textColor = color2_text_xgw;

    }
    
}

@end
