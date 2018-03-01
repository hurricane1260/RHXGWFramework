//
//  HTTPRequestParamFactory.h
//  stockscontest
//
//  Created by 方海龙 on 15-1-7.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface HTTPRequestParamFactory : NSObject

+(NSString *)didBuildRequestQueryStringWithUrlString:(NSString *)urlString reqParam:(id)aParam;

+(void)didBuildRequestPostParamWith:(ASIFormDataRequest *)request reqParam:(id)aParam;

@end
