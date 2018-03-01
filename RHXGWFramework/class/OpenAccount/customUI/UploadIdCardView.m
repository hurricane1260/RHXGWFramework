//
//  UploadIdCardView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/26.
//
//

#import "UploadIdCardView.h"

@interface UploadIdCardView ()

kRhPStrong UIImageView * backView;

kRhPStrong UIImageView * cardImgView;

kRhPStrong UILabel * hintLabel;

kRhPCopy NSString * tagStr;

kRhPAssign BOOL isLoad;

kRhPAssign CGFloat ratio;

@end

@implementation UploadIdCardView


- (instancetype)initFrontView{
    if (self = [super init]) {
        self.isLoad = NO;
        self.tagStr = @"front";
        [self initSubviews];
    }
    return self;
}

- (instancetype)initBackView{
    if (self = [super init]) {
        self.isLoad = NO;
        self.tagStr = @"back";
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    self.backView = [[UIImageView alloc] initWithImage:img_open_idfront];
    [self addSubview:self.backView];
    
//    self.cardImgView = [[UIImageView alloc] initWithImage:img_open_idfront];
    self.cardImgView = [[UIImageView alloc] init];
    [self.backView addSubview:self.cardImgView];
    
    self.hintLabel = [UILabel didBuildLabelWithText:@"" font:font2_common_xgw textColor:color2_text_xgw wordWrap:NO];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.backView addSubview:self.hintLabel];
    
    if ([self.tagStr isEqualToString:@"front"]) {
//        self.cardImgView.backgroundColor = color_id_inblue;
//        self.cardImgView.layer.borderColor = color_id_blue.CGColor;
        [self.backView setImage:img_open_idfront];
        self.hintLabel.text = @"点击上传身份证正面";
    }
    else if ([self.tagStr isEqualToString:@"back"]){
//        self.cardImgView.backgroundColor = color_id_inred;
//        self.cardImgView.layer.borderColor = color_id_red.CGColor;
        [self.backView setImage:img_open_idback];
        self.hintLabel.text = @"点击上传身份证背面";

    }

}

- (void)loadIdImgWith:(UIImage *)img withRatio:(CGFloat)ratio{
    if (!img) {
        return;
    }
    [self.cardImgView setImage:img];
    self.isLoad = YES;
    self.ratio = ratio;
}

//- (void)setIdImg:(UIImage *)idImg{
//    if (!idImg) {
//        return;
//    }
//    _idImg = idImg;
//    [self.cardImgView setImage:_idImg];
//    self.isLoad = YES;
//
//}

- (void)setIsLoad:(BOOL)isLoad{
    _isLoad = isLoad;
    
    if (!isLoad) {
        return;
    }
    self.hintLabel.backgroundColor = color_black_alpha;
    self.hintLabel.textColor = color1_text_xgw;
    if ([self.tagStr isEqualToString:@"front"]) {
        self.hintLabel.text = @"身份证头像面识别成功";
    }
    else if ([self.tagStr isEqualToString:@"back"]){
        self.hintLabel.text = @"身份证国徽面识别成功";
        
    }
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backView.frame = CGRectMake(0, 0, self.width, self.height);
    CGFloat width = self.width * 4.0f / 5.0f;
    width = 282.0f;
    CGFloat height = 0.0;
    if (self.ratio != 0.0f) {
        height =  width / self.ratio;
    }
    self.cardImgView.frame = CGRectMake((self.backView.width - width)/2.0f, 10.0f, width, height);
    
    if (!self.isLoad) {
        [self.hintLabel sizeToFit];
        
        self.hintLabel.frame = CGRectMake((self.width - self.hintLabel.width)/2.0f, self.height - 10.0f - self.hintLabel.height, self.hintLabel.width, self.hintLabel.height);
    }
    else{
        
        self.hintLabel.frame = CGRectMake(0, self.height - 36.0f, self.width, 36.0f);
    }
    
}

@end
