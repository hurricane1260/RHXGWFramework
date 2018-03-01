//
//  TTTAttributedLabel+RHJX_Inc.h
//  JinHuiXuanGuWang
//
//  Created by rxhui on 17/3/6.
//
//

#import "TTTAttributedLabel.h"

@interface TTTAttributedLabel (RHJX_Inc)

+(TTTAttributedLabel *)didBuildTTTLabelWithText:(NSString *)aTxt font:(UIFont *)font textColor:(UIColor *)aColor wordWrap:(BOOL)wordWrapEnable;

@end
