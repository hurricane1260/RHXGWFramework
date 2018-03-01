//
//  MNHotSpotVO.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/10/27.
//
//

#import "MNHotSpotVO.h"

@implementation MNHotSpotVO

+ (id)generateWithDict:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
//        self.height = [self cacheight];
    }
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key{
    
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.newsId = value;
    }
}

//- (CGFloat)cacheight{
//    UILabel * tLabel = [UILabel didBuildLabelWithText:self.title font:font3_boldCommon_xgw textColor:color1_text_xgw wordWrap:NO];
//    [tLabel sizeToFit];
//   
//    TTTAttributedLabel * conLabel = [[TTTAttributedLabel alloc] init];
//    conLabel.font = font2_common_xgw;
//    conLabel.text = self.outline;
//    conLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
//    conLabel.numberOfLines = 0;
//    conLabel.lineSpacing = 6.0f;
//    
//    CGSize size = [self getSizeOfContentString:conLabel.text];
//    conLabel.size = size;
//    
//    UILabel * tagLabel = [UILabel didBuildLabelWithText:@"要闻" font:font1_common_xgw textColor:color6_text_xgw wordWrap:NO];
//    [tagLabel sizeToFit];
//
//    return  conLabel.height + tLabel.height + 40.0f + 20.0f + tagLabel.height + 10.0f;
//
//}

- (CGSize)getSizeOfContentString:(NSString *)string{
//    if (!string.length) {
//        return CGSizeZero;
//    }
//    //内容为html格式
//     NSMutableAttributedString * mutaAttriString =  [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//    
//    [mutaAttriString addAttribute:NSFontAttributeName value:font2_common_xgw range:NSMakeRange(0,mutaAttriString.length)];
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
//    paraStyle.lineSpacing = 6;
//    paraStyle.lineHeightMultiple = 1;
//    paraStyle.minimumLineHeight = font2_common_xgw.lineHeight;
//    paraStyle.maximumLineHeight = font2_common_xgw.lineHeight;
//    [mutaAttriString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, mutaAttriString.length)];
//    
//    CGSize tmpSize = [TTTAttributedLabel sizeThatFitsAttributedString:mutaAttriString withConstraints:CGSizeMake(MAIN_SCREEN_WIDTH - 24.0f, NSIntegerMax) limitedToNumberOfLines:3];
//    return tmpSize;
    return CGSizeZero;
}


@end
