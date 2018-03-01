\
//
//  TTTAttributedLabel+RHJX_Inc.m
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/3/6.
//
//

#import "TTTAttributedLabel+RHJX_Inc.h"

@implementation TTTAttributedLabel (RHJX_Inc)

+(TTTAttributedLabel *)didBuildTTTLabelWithText:(NSString *)aTxt font:(UIFont *)font textColor:(UIColor *)aColor wordWrap:(BOOL)wordWrapEnable{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] init];
    label.text = aTxt;
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = aColor;
    if(wordWrapEnable){
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
    }
    return label;
}

@end
