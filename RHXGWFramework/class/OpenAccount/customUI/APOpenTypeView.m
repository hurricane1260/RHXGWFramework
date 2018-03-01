//
//  APOpenTypeView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/27.
//
//

#import "APOpenTypeView.h"

@interface APOpenTypeView ()

kRhPStrong UIImageView * tagImgView;

kRhPStrong UILabel * titleLabel;

kRhPStrong UIButton * selectBtn;

kRhPStrong UILabel * hsLabel;

kRhPAssign BOOL isSelected;
@end

@implementation APOpenTypeView

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = color1_text_xgw;
        self.isSelected = YES;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.tagImgView = [[UIImageView alloc] initWithImage:img_open_mark];
    [self addSubview:self.tagImgView];
    
    self.titleLabel = [UILabel didBuildLabelWithText:@"选择开户类型" font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.titleLabel];
    
    self.selectBtn = [UIButton didBuildButtonWithNormalImage:img_open_circleClick highlightImage:img_open_circleClick];
    [self.selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectBtn];
    
    self.hsLabel = [UILabel didBuildLabelWithText:@"沪深A股" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    [self addSubview:self.hsLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tagImgView.frame = CGRectMake(24.0f, 16.0f, self.tagImgView.width, self.tagImgView.height);
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.tagImgView.frame) + 5.0f, self.tagImgView.y, self.titleLabel.width, self.titleLabel.height);
    
//    self.selectBtn.frame = CGRectMake(self.tagImgView.x, CGRectGetMaxY(self.tagImgView.frame) + 20.0f, self.selectBtn.imageView.width, self.selectBtn.imageView.height);
    
    self.selectBtn.frame = CGRectMake(self.tagImgView.x, CGRectGetMaxY(self.tagImgView.frame) + 20.0f, 20.0f, 20);

    
    [self.hsLabel sizeToFit];
    self.hsLabel.frame = CGRectMake(CGRectGetMaxX(self.selectBtn.frame)  + 10.0f, self.selectBtn.y, self.hsLabel.width, self.hsLabel.height);
    self.hsLabel.center = CGPointMake(self.hsLabel.center.x, self.selectBtn.center.y);
    
    if(self.heightCallBack){
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.selectBtn.frame) + 16.0f] forKey:@"height"];
        self.heightCallBack(param);
    
    }
}

- (void)selectClick:(UIButton *)btn{
    self.isSelected = !self.isSelected;
    
    if (self.isSelected) {
        [self.selectBtn setImage:img_open_circleClick forState:UIControlStateNormal];
    }
    else{
        [self.selectBtn setImage:img_open_circleNoClick forState:UIControlStateNormal];

    }

    if (self.selectCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithBool:self.isSelected] forKey:@"select"];
        self.selectCallBack(param);
    }
}

@end
