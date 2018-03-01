//
//  APHintView.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/6/28.
//
//

#import "APHintView.h"
#import "TTTAttributedLabel.h"
#import "RHLabelAttributeTool.h"
#import "TTTAttributedLabel+RHJX_Inc.h"

@interface APHintView ()

kRhPStrong UILabel * titleLabel;

kRhPStrong TTTAttributedLabel * contentLabel;

kRhPStrong RHLabelAttributeTool * tool;
@end

@implementation APHintView


- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = color1_text_xgw;
        self.tool = [[RHLabelAttributeTool alloc] init];
        [self initSubviews];
        [self loadContent];
    }
    return self;
}

- (void)initSubviews{
    self.titleLabel = [UILabel didBuildLabelWithText:@"温馨提示" font:font1_common_xgw textColor:color4_text_xgw wordWrap:NO];
    [self addSubview:self.titleLabel];
    
    self.contentLabel = [TTTAttributedLabel didBuildTTTLabelWithText:@"" font:font1_common_xgw textColor:color4_text_xgw wordWrap:YES];
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
    
}

- (void)loadContent{
    NSString * content = @"1.密码不能为身份证、手机号一部分\n2.不能出现连续三个数字（例：345）\n3.不能出现回文数字（例：135531）\n4.同一数字不能连续出现三次（例：333)";
    self.contentLabel.text = content;
    self.contentLabel.attributedText = [self.tool getAttribute:self.contentLabel.text withParagraphStyleSpace:[NSNumber numberWithFloat:6.0f] withFont:font1_common_xgw withColor:color4_text_xgw];
    [self setNeedsLayout];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(24.0f, 20.0f, self.titleLabel.width, self.titleLabel.height);
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    CGFloat width = (self.width - 48.0f);
    [param setObject:font1_common_xgw forKey:@"font"];
    [param setObject:[NSNumber numberWithFloat:6.0f] forKey:@"space"];
    [param setObject:[NSNumber numberWithFloat:width] forKey:@"width"];
    CGFloat height = [[[self.tool getMaxAttributeSizeWithString:self.contentLabel.text withDictionary:param] objectForKey:kMaxAttHeight] floatValue];
    
    self.contentLabel.frame = CGRectMake(self.titleLabel.x, CGRectGetMaxY(self.titleLabel.frame ) + 10.0f, width, height);
    
    if (self.heightCallBack) {
        NSMutableDictionary * aParam = [NSMutableDictionary dictionary];
        [aParam setObject:[NSNumber numberWithFloat:CGRectGetMaxY(self.contentLabel.frame) + 20.0f] forKey:@"height"];
        self.heightCallBack (aParam);
    }
}

@end
