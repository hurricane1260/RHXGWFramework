//
//  HTTPRequestManager.h
//  stockscontest
//
//  Created by rxhui on 15/3/25.
//  Copyright (c) 2015年 方海龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequestService.h"

@interface HTTPRequestManager : NSObject

+(HTTPRequestService *)appendParamForHTTPRequest:(HTTPRequestService *)request;

@end
