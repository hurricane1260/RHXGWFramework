//
//  RECMicAndCamView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/29.
//
//

#import "RECMicAndCamView.h"

@interface RECMicAndCamView ()

kRhPStrong UIImageView * imgView;

kRhPStrong UILabel * titleLabel;

kRhPStrong UIImage * img;

kRhPCopy NSString * title;
@end

@implementation RECMicAndCamView

- (instancetype)initWithImg:(UIImage *)img withTitle:(NSString *)title{
    if (self = [super init]) {
        self.img = img;
        self.title = title;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    self.imgView = [[UIImageView alloc] initWithImage:self.img];
    [self addSubview:self.imgView];
    
    self.titleLabel = [UILabel didBuildLabelWithText:self.title font:font1_common_xgw textColor:color2_text_xgw wordWrap:NO];
    self.titleLabel.attributedText = [CPStringHandler getStringWithStr:@"请允许访问" withColor:color2_text_xgw andAppendString:self.title withColor:color_rec_orange];
    [self addSubview:self.titleLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imgView.frame = CGRectMake(0, 0, self.imgView.width, self.imgView.height);
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame) + 12.0f, (self.imgView.height - self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    
    if (self.heightCallBack) {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [param setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.imgView.frame)] forKey:@"height"];
        [param setObject:[NSNumber numberWithFloat:CGRectGetMaxX(self.titleLabel.frame)] forKey:@"width"];
        self.heightCallBack(param);
    }
    
}

@end
