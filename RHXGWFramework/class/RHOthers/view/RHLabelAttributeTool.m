//
//  RHLabelAttributeTool.m
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/11/17.
//
//

#import "RHLabelAttributeTool.h"
#import "ForumLayoutManager.h"
#import "TTTAttributedLabel.h"

@implementation RHLabelAttributeTool

- (NSDictionary *)getMinAttributeSizeWithString:(NSString *)contentStr withDictionary:(NSDictionary *)attributeDic{
    //行间距
    //字体样式
    //限制行数
    //最大宽度
    BOOL isOne;
    NSNumber * space = [attributeDic objectForKey:@"space"];
    NSNumber * lines = [attributeDic objectForKey:@"lines"];
    UIFont * font = [attributeDic objectForKey:@"font"];
    NSNumber * width = [attributeDic objectForKey:@"width"];
    
    NSMutableAttributedString * attStr;
    
    if (space) {
        attStr = [self getAttribute:contentStr withParagraphStyleSpace:[space floatValue] withRange:NSMakeRange(0, contentStr.length)];
    }
    
        [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, contentStr.length)];

    CGFloat contentHeight;

//    if (lines) {
            contentHeight = [ForumLayoutManager measureHeightWithString:attStr.string andMaxWidth:[width floatValue] andFont:font andLines:[lines integerValue]];
//        CGSize tmpSize = [TTTAttributedLabel sizeThatFitsAttributedString:attStr withConstraints:CGSizeMake([width floatValue], NSIntegerMax) limitedToNumberOfLines:[lines integerValue]];
//        contentHeight = tmpSize.height;
//        }
    
        [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, contentStr.length)];
        CGSize contentStringSize =[attStr boundingRectWithSize:CGSizeMake([width floatValue], MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGFloat factHeight = contentStringSize.height;
        
        contentHeight = MIN(contentHeight, factHeight);
    
    NSMutableAttributedString * attributeStr;
//    if (isOne) {
//        attributeStr = [self getAttribute:contentStr withParagraphStyleSpace:0 withFont:font];
//
//    }
//    else{
        attributeStr = [self getAttribute:contentStr withParagraphStyleSpace:space withFont:font];

//    }

    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithFloat:contentHeight] forKey:kMinAttHeight];
    if (attributeStr) {
        [param setObject:attributeStr forKey:kAttString];
    }
    
    return param;
}

- (NSDictionary *)getMaxAttributeSizeWithString:(NSString *)contentStr withDictionary:(NSDictionary *)attributeDic{
    //行间距
    //字体样式
    //限制行数
    //最大宽度
    NSNumber * space = [attributeDic objectForKey:@"space"];
    NSNumber * lines = [attributeDic objectForKey:@"lines"];
    UIFont * font = [attributeDic objectForKey:@"font"];
    NSNumber * width = [attributeDic objectForKey:@"width"];
    
    NSMutableAttributedString * attStr;
    if (space) {
        attStr = [self getAttribute:contentStr withParagraphStyleSpace:[space floatValue] withRange:NSMakeRange(0, contentStr.length)];
    }
    else{
        attStr = [self getAttribute:contentStr withParagraphStyleSpace:8.0f withRange:NSMakeRange(0, contentStr.length)];
    }
    CGFloat contentHeight;
    CGFloat factHeight;
    if (lines && space) {
        contentHeight = [ForumLayoutManager measureHeightWithString:attStr.string andMaxWidth:[width floatValue] andFont:font andLines:[lines integerValue] andSpace:[space floatValue]];
    }
    else if (lines && !space){
         contentHeight = [ForumLayoutManager measureHeightWithString:attStr.string andMaxWidth:[width floatValue] andFont:font andLines:[lines integerValue]];
    }
    else{
        [attStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, contentStr.length)];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:[space floatValue]];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,contentStr.length)];
        CGSize maxSize = CGSizeMake([width floatValue], CGFLOAT_MAX);
        CGSize contentStringSize =[attStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        factHeight = contentStringSize.height;
    }
    
    contentHeight = MAX(contentHeight, factHeight);
    
    NSMutableAttributedString * attributeStr = [self getAttribute:contentStr withParagraphStyleSpace:space withFont:font];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObject:[NSNumber numberWithFloat:contentHeight] forKey:kMaxAttHeight];
    if (attributeStr) {
        [param setObject:attributeStr forKey:kAttString];
    }
    
    return param;

}

- (NSMutableAttributedString *)getAttribute:(NSString *)string withParagraphStyleSpace:(CGFloat) lineSpace withRange:(NSRange)range{
    if (!string || string.length == 0) {
        return nil;
    }
//    CGFloat offset = -(1.0/3 * lineSpace) - 1.0/3;
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
//    if (lineSpace == 0) {
//        [attString addAttribute:NSBaselineOffsetAttributeName value:@(offset) range:range];
//    }
     paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attString;
}

- (NSMutableAttributedString *)getAttribute:(NSString *)string withParagraphStyleSpace:(NSNumber *) lineSpace withFont:(UIFont*)font{
    if (!string || string.length == 0) {
        return nil;
    }
//    CGFloat offset = -(1.0/3 * [lineSpace floatValue]) - 1.0/3;

    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:string];

     NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (lineSpace) {
        [paragraphStyle setLineSpacing:[lineSpace floatValue]];
    }
    else{
//        [paragraphStyle setLineSpacing:8.0f];
//        [attString addAttribute:NSBaselineOffsetAttributeName value:@(offset) range:NSMakeRange(0,string.length)];
    }
    
    paragraphStyle.lineHeightMultiple = 1;
    paragraphStyle.minimumLineHeight = font.lineHeight;
    paragraphStyle.maximumLineHeight = font.lineHeight;

    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,string.length)];
    
    [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,string.length)];
    return attString;
}

- (NSMutableAttributedString *)getAttribute:(NSString *)string withParagraphStyleSpace:(NSNumber *) lineSpace withFont:(UIFont*)font withColor:(UIColor *)color{
    if (!string || string.length == 0) {
        return nil;
    }
    
    NSMutableAttributedString * attString = [self getAttribute:string withParagraphStyleSpace:lineSpace withFont:font];
    NSRange range = NSMakeRange(0, string.length);
    [attString addAttributes:@{NSForegroundColorAttributeName:color} range:range];
    return attString;
}


@end
