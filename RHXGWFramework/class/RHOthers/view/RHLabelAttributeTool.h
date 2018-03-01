//
//  RHLabelAttributeTool.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 16/11/17.
//
//

#import <Foundation/Foundation.h>

@interface RHLabelAttributeTool : NSObject

//- (NSDictionary *)getAttributeSizeWithString:(NSString *)contentStr withDictionary:(NSDictionary *)attributeDic;

- (NSDictionary *)getMinAttributeSizeWithString:(NSString *)contentStr withDictionary:(NSDictionary *)attributeDic;

- (NSDictionary *)getMaxAttributeSizeWithString:(NSString *)contentStr withDictionary:(NSDictionary *)attributeDic;

- (NSMutableAttributedString *)getAttribute:(NSString *)string withParagraphStyleSpace:(NSNumber *) lineSpace withFont:(UIFont*)font;

- (NSMutableAttributedString *)getAttribute:(NSString *)string withParagraphStyleSpace:(NSNumber *) lineSpace withFont:(UIFont*)font withColor:(UIColor *)color;
@end
