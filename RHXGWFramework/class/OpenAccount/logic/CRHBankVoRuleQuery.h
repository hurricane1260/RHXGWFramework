//
//  CRHBankVoRuleQuery.h
//  JinHuiXuanGuWang
//
//  Created by liyan on 2017/9/26.
//

#import <Foundation/Foundation.h>

@interface CRHBankVoRuleQuery : NSObject

+ (NSString *)queryBankInfoWithKey:(NSString *)key withBankName:(NSString *)bankName;

+ (BOOL)isSupportBank:(NSString *)bankName;
@end
